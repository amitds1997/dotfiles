import NotificationColumn from "./NotificationColumn"
import DateColumn from "./DateColumn"
import { setUpBarWindow } from "widgets/BarWindow"

const DateMenu = () =>
  Widget.Box({
    class_name: "datemenu horizontal",
    vexpand: false,
    children: [
      NotificationColumn(),
      Widget.Separator({ orientation: 1 }),
      DateColumn(),
    ],
  })

export function setUpDateMenu() {
  setUpBarWindow({ name: "datemenu", child: DateMenu() })
}
