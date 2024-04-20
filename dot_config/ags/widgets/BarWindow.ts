import options from "options"
import PopupWindow from "widgets/PopupWindow"

const { bar, preferences } = options
const layout = Utils.derive(
  [bar.position, preferences.position],
  (bar, p) => `${bar}-${p}` as const,
)

export default ({ name, child }) =>
  PopupWindow({
    name: name,
    exclusivity: "exclusive",
    transition: bar.position
      .bind()
      .as((p) => (p === "top" ? "slide_down" : "slide_up")),
    layout: layout.value,
    child: child,
  })

export function setUpBarWindow({ name, child }) {
  const BarWindow = () =>
    PopupWindow({
      name: name,
      exclusivity: "exclusive",
      transition: bar.position
        .bind()
        .as((p) => (p === "top" ? "slide_down" : "slide_up")),
      layout: layout.value,
      child: child,
    })

  App.addWindow(BarWindow())
  layout.connect("changed", () => {
    App.removeWindow("datemenu")
    App.addWindow(BarWindow())
  })
}
