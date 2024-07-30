import { Opt } from "lib/options"
import { dependencies, zsh } from "lib/utils"
import options from "options"

const deps = [
  "font",
  "theme",
  "bar.flatButtons",
  "bar.position",
  "bar.battery.charging",
  "bar.battery.blocks",
]

const $ = (name: string, value: string | Opt<unknown>) => `$${name}: ${value}`

function extractVariables(theme: any, prefix: string = ""): string[] {
  let result: string[] = []
  for (let key in theme) {
    if (theme.hasOwnProperty(key)) {
      const value = theme[key]
      const prefixedKey = prefix ? `${prefix}-${key}` : key

      if (
        typeof value === "object" &&
        value !== null &&
        !Array.isArray(value)
      ) {
        if (typeof value.value !== "undefined") {
          result.push($(`${prefixedKey}`, `${value.value}`))
        } else {
          result = result.concat(extractVariables(value, prefixedKey))
        }
      } else if (typeof value === "function" && value.name === "opt") {
        result.push($(`${prefixedKey}`, value))
      }
    }
  }

  return result
}

const variables = () => [...extractVariables(options.theme)]

async function resetCSS() {
  if (!dependencies("sass")) {
    return
  }

  try {
    const mainScssFilepath = `${App.configDir}/scss/main.scss`
    const variablesFilepath = `${App.configDir}/scss/generated/variables.scss`
    const scssInputFilepath = `${App.configDir}/scss/generated/entry.scss`
    const cssOutputFilepath = `${TMP_DIR}/main.css`

    // All variables are written to the variables file
    await Utils.writeFile(variables().join("\n"), variablesFilepath)

    // Generate the SCSS file
    let mainSCSS = Utils.readFile(mainScssFilepath)
    const scssFiles: string = await zsh(
      `fd ".scss" --no-require-git ${App.configDir}/scss/style`,
    )
    const scssFileImport = scssFiles.split(/\s+/).map((f) => `@import '${f}';`)
    mainSCSS = `@import ${variablesFilepath};\n${mainSCSS}\n${scssFileImport}`
    await Utils.writeFile(scssInputFilepath, mainSCSS)

    // Generate CSS from SCSS and apply it to the app
    await zsh(`sass ${scssInputFilepath} ${cssOutputFilepath}`)
    App.applyCss(cssOutputFilepath, true)
  } catch (error) {
    console.log(error)
  }
}

Utils.monitorFile(`${App.configDir}/scss/style`, resetCSS)
options.handler(deps, resetCSS)

await resetCSS()
