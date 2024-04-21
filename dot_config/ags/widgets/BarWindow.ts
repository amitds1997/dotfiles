import options from "options"
import PopupWindow, { PopupNames, PopupWindowProps } from "widgets/PopupWindow"

const { bar, preferences } = options
const layout = Utils.derive(
  [bar.position, preferences.position],
  (bar, p) => `${bar}-${p}` as const,
)

export function setUpBarWindow({ name, child }: PopupWindowProps) {
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
    App.removeWindow(PopupNames.DateMenu)
    App.addWindow(BarWindow())
  })
}
