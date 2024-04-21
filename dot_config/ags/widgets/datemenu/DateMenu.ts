import NotificationColumn from "./NotificationColumn"
import DateColumn from "./DateColumn"
import { setUpBarWindow } from "widgets/BarWindow"
import { PopupNames } from "widgets/PopupWindow"

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
  setUpBarWindow({ name: PopupNames.DateMenu, child: DateMenu() })
}
