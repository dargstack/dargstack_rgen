#!/usr/bin/env node

const fs = require('fs')
const path = require('path')

const deepMerge = require('deepmerge')
const diff = require('diff')
const json2md = require('json2md')
const yaml = require('yaml')
const yargs = require('yargs')

json2md.converters.vanilla = function (input, json2md) {
  return input
}

const argv = yargs
  .option('path', {
    alias: 'p',
    description: 'Path to a DargStack stack project',
    type: 'string'
  })
  .option('validate', {
    alias: 'v',
    description: 'Flag that enabled validation only',
    type: 'boolean'
  })
  .help()
  .alias('help', 'h')
  .argv

const projectPath = argv.path || process.cwd()
const validate = argv.validate || false

const stackDevelopmentPath = path.join(projectPath, 'src', 'development', 'stack.yml')
const stackProductionPath = path.join(projectPath, 'src', 'production', 'production.yml')

// Read YAMLs.

let developmentYaml
let productionYaml

if (fs.existsSync(stackDevelopmentPath)) {
  developmentYaml = yaml.parseDocument(fs.readFileSync(stackDevelopmentPath, 'utf8'))
} else {
  console.error('Development stack file not found!')
  process.exit(1)
}

if (fs.existsSync(stackProductionPath)) {
  productionYaml = yaml.parseDocument(fs.readFileSync(stackProductionPath, 'utf8'))
} else {
  console.info('Production stack file not found!')
}

if (developmentYaml.commentBefore === null) {
  console.error('YAML is missing metadata!')
  process.exit(1)
}

const metadata = developmentYaml.commentBefore.split('\n')

if (metadata.length !== 4) {
  console.error('YAML metadata is missing keys!')
  process.exit(1)
}

const webName = metadata[0].trim()
const webUrl = metadata[1].trim()
const sourceName = metadata[2].trim()
const sourceUrl = metadata[3].trim()

const toc = []
const content = {}

let commentMissing = false

// Parse development YAML.

let documentItems = developmentYaml.contents.items

for (let i = 0; i < documentItems.length; i++) {
  const documentItem = documentItems[i]
  const elementItems = documentItem.value.items

  if (documentItem.value.type !== 'MAP') {
    continue
  }

  const contentElementItems = {}

  for (let j = 0; j < elementItems.length; j++) {
    const elementItem = elementItems[j]
    const contentElementItem = {}

    if (elementItem.value.commentBefore === undefined) {
      if (!process.argv.includes('--no-comments')) {
        console.error(`${documentItem.key.value}: ${elementItem.key.value} is missing a comment!`)
        commentMissing = true
      }
    } else {
      contentElementItem.comment = elementItem.value.commentBefore.split('\n').map(element => element.trim()).join('\n')
    }

    contentElementItems[elementItem.key.value] = contentElementItem
  }

  toc.push(documentItem.key.value)
  content[documentItem.key.value] = contentElementItems
}

// Parse production YAML.

documentItems = []

if (productionYaml !== undefined && productionYaml.contents !== null) {
  documentItems = productionYaml.contents.items
}

for (let i = 0; i < documentItems.length; i++) {
  const documentItem = documentItems[i]

  if (documentItem.value === undefined || documentItem.value.type !== 'MAP') {
    continue
  }

  const elementItems = documentItem.value.items
  const contentElementItems = {}

  for (let j = 0; j < elementItems.length; j++) {
    const elementItem = elementItems[j]
    const contentElementItem = { production: !(elementItem.key.value in content[documentItem.key.value]) }

    if (elementItem.value.commentBefore === undefined) {
      if (!process.argv.includes('--no-comments') && !(elementItem.key.value in content[documentItem.key.value])) {
        console.error(`${documentItem.key.value}: ${elementItem.key.value} is missing a comment!`)
        commentMissing = true
      }
    } else {
      contentElementItem.comment = elementItem.value.commentBefore.split('\n').map(element => element.trim()).join('\n')
    }

    contentElementItems[elementItem.key.value] = contentElementItem
  }

  if (!toc.includes(documentItem.key.value)) {
    toc.push(documentItem.key.value)
  }

  content[documentItem.key.value] = deepMerge(content[documentItem.key.value], contentElementItems)
}

if (commentMissing) {
  process.exit(1)
}

const mdjson = [
  { h1: path.basename(projectPath) },
  {
    p: [
      `The Docker stack configuration for [${webName}](${webUrl}).`,
      `This project is deployed in accordance to the [DargStack template](https://github.com/dargmuesli/dargstack_template/) to make deployment a breeze. It is closely related to [${sourceName}'s source code](${sourceUrl}).`
    ]
  },
  { h2: 'Table of Contents' },
  {
    ol: toc.map(element => { return { link: { title: element, source: '#' + element } } })
  },
  Object.entries(content).map(contentElement => {
    return [
      { h2: contentElement[0] },
      {
        ul: [
          ...Object.entries(contentElement[1]).sort().map(itemElement => {
            const itemElementMarkdown = [{
              h3: `\`${itemElement[0]}\`${'production' in itemElement[1] && itemElement[1].production ? ' ![production](https://img.shields.io/badge/-production-informational.svg?style=flat-square)' : ''}`
            }]

            if ('comment' in itemElement[1] && itemElement[1].comment) {
              itemElementMarkdown.push({ vanilla: itemElement[1].comment.split('\n').map(comment => comment.trim()).join('\n') })
            }

            return itemElementMarkdown
          })
        ]
      }]
  })
]

const md = json2md(mdjson)

if (validate) {
  const readmePath = path.join(projectPath, 'README.md')
  let readme

  if (fs.existsSync(readmePath)) {
    readme = fs.readFileSync(readmePath, 'utf8')
  } else {
    console.error('README.md file not found!')
    process.exit(1)
  }

  const difference = diff.diffLines(md + '\n', readme)

  if (difference.length > 1) {
    console.error('The README is not up-2-date!\n' +
      'Remember that newline diffs aren\'t visibly highlighted.')

    difference.forEach((part) => {
      let color = part.added
        ? 'green'
        : part.removed ? 'red' : 'grey'

      switch (color) {
        case 'green':
          color = '[32m'
          break
        case 'red':
          color = '[31m'
          break
        default:
          color = '[0m'
      }

      if (color !== '[0m') {
        process.stderr.write('\x1b' + color + part.value + '\x1b[0m')
      }
    })

    process.exit(difference.length)
  }
} else {
  console.log(md)
}
