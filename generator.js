const fs = require('fs')
const path = require('path')

const deepMerge = require('deepmerge')
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
  .help()
  .alias('help', 'h')
  .argv

const projectPath = argv.path || process.cwd()

const stackDevelopmentPath = path.join(projectPath, 'development', 'stack.yml')
const stackProductionPath = path.join(projectPath, 'production', 'production.yml')

if (!fs.existsSync(stackDevelopmentPath)) {
  console.error('Development stack file not found!')
  process.exit(1)
}

if (!fs.existsSync(stackProductionPath)) {
  console.error('Production stack file not found!')
  process.exit(1)
}

const developmentYaml = yaml.parseDocument(fs.readFileSync(stackDevelopmentPath, 'utf8'))
const productionYaml = yaml.parseDocument(fs.readFileSync(stackProductionPath, 'utf8'))

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

documentItems = []

if (productionYaml.contents !== null) {
  documentItems.push(productionYaml.contents.items)
}

for (let i = 0; i < documentItems.length; i++) {
  const documentItem = documentItems[i]
  const elementItems = documentItem.value.items

  if (documentItem.value.type !== 'MAP') {
    continue
  }

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

console.log(json2md(mdjson))
