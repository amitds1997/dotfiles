import icons from "lib/icons"
import { ToggleButton } from "./ToggleButton"
import options from "options"

const { scheme } = options.theme

export const DarkModeToggle = () =>
  ToggleButton({
    icon: scheme.bind().as((s) => icons.theme[s]),
    label: scheme.bind().as((s) => (s === "dark" ? "Dark" : "Light")),
    toggle_action: () =>
      (scheme.value = scheme.value === "dark" ? "light" : "dark"),
    connection: [scheme, () => scheme.value === "dark"],
  })
