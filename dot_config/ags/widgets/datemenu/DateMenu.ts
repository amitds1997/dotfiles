import options from "options"
import PopupWindow from "widgets/window/PopupWindow"
import NotificationColumn from "./NotificationColumn"
import DateColumn from "./DateColumn"

const { bar, datemenu } = options
const pos = options.bar.position.bind()
const layout = Utils.derive(
  [bar.position, datemenu.position],
  (bar, dm) => `${bar}-${dm}` as const,
)

const Settings = () =>
  Widget.Box({
    class_name: "datemenu horizontal",
    vexpand: false,
    children: [
      NotificationColumn(),
      Widget.Separator({ orientation: 1 }),
      DateColumn(),
    ],
  })

const DateMenu = () =>
  PopupWindow({
    name: "datemenu",
    exclusivity: "exclusive",
    transition: pos.as((pos) => (pos === "top" ? "slide_down" : "slide_up")),
    layout: layout.value,
    child: Settings(),
  })

export function setupDateMenu() {
  App.addWindow(DateMenu()),
    layout.connect("changed", () => {
      App.removeWindow("datemenu")
      App.addWindow(DateMenu())
    })
}
