import { type Opt } from "lib/option"
import { bash, dependencies, sh } from "lib/utils"
import options from "options"

const deps = [
  "font",
  "theme",
  "bar.flatButtons",
  "bar.position",
  "bar.battery.charging",
  "bar.battery.blocks",
]

const {
  dark,
  light,
  blur,
  padding,
  spacing,
  radius,
  shadows,
  widget,
  border,
  scheme,
} = options.theme

const popoverPaddingMultiplier = 1.6

const t = (dark: Opt<any> | string, light: Opt<any> | string) =>
  scheme.value === "dark" ? `${dark}` : `${light}`

const $ = (name: string, value: string | Opt<any>) => `$${name}: ${value};`

const variables = () => [
  $(
    "bg",
    blur.value
      ? `transparentize(${t(dark.bg, light.bg)}, ${blur.value / 100})`
      : t(dark.bg, light.bg),
  ),
  $("fg", t(dark.fg, light.fg)),

  $("primary-bg", t(dark.primary.bg, light.primary.bg)),
  $("primary-fg", t(dark.primary.fg, light.primary.fg)),

  $("error-bg", t(dark.error.bg, light.error.bg)),
  $("error-fg", t(dark.error.fg, light.error.fg)),

  $("scheme", scheme),
  $("padding", `${padding}pt`),
  $("spacing", `${spacing}pt`),
  $("radius", `${radius}px`),
  $("transition", `${options.transition}ms`),

  $("shadows", `${shadows}`),

  $(
    "widget-bg",
    `transparentize(${t(dark.widget, light.widget)}, ${widget.opacity.value / 100})`,
  ),

  $(
    "hover-bg",
    `transparentize(${t(dark.widget, light.widget)}, ${(widget.opacity.value * 0.9) / 100})`,
  ),
  $("hover-fg", `lighten(${t(dark.fg, light.fg)}, 8%)`),

  $("border-width", `${border.width}px`),
  $(
    "border-color",
    `transparentize(${t(dark.border, light.border)}, ${border.opacity.value / 100})`,
  ),
  $("border", "$border-width solid $border-color"),

  $(
    "active-gradient",
    `linear-gradient(to right, ${t(dark.primary.bg, light.primary.bg)}, darken(${t(dark.primary.bg, light.primary.bg)}, 4%))`,
  ),
  $("shadow-color", t("rgba(0,0,0,.6)", "rgba(0,0,0,.4)")),
  $("text-shadow", t("2pt 2pt 2pt $shadow-color", "none")),

  $(
    "popover-border-color",
    `transparentize(${t(dark.border, light.border)}, ${Math.max((border.opacity.value - 1) / 100, 0)})`,
  ),
  $("popover-padding", `$padding * ${popoverPaddingMultiplier}`),
  $("popover-radius", radius.value === 0 ? "0" : "$radius + $popover-padding"),

  $("font-size", `${options.font.size}pt`),
  $("font-name", options.font.name),

  // etc
  $("charging-bg", options.bar.battery.charging),
  $("bar-battery-blocks", options.bar.battery.blocks),
  $("bar-position", options.bar.position),
  $("hyprland-gaps-multiplier", options.hyprland.gaps),
]

async function resetCSS() {
  if (!dependencies("sass", "fd")) return

  try {
    const vars = `${TMP}/variables.scss`
    await Utils.writeFile(variables().join("\n"), vars)

    const fd = await sh(`fd ".scss" ${App.configDir}`)
    const files = fd.split(/\s+/).map((f) => `@import '${f}';`)
    const scss = [`@import '${vars}';`, ...files].join("\n")
    const css = await bash`echo "${scss}" | sass --stdin`
    const style_file = `${TMP}/style.scss`

    await Utils.writeFile(css, style_file)

    App.resetCss()
    App.applyCss(style_file)
  } catch (error) {
    logError(error)
  }
}

export default function init() {
  Utils.monitorFile(App.configDir, resetCSS)
  options.handler(deps, resetCSS)
  resetCSS()
}
