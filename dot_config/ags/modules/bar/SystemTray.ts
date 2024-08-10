import { icons } from "lib/icons"
import { TrayItem } from "types/service/systemtray"

const sysTray = await Service.import("systemtray")

const SystemTrayItem = (item: TrayItem) => {
  if (item.menu !== undefined) {
    item.menu["class_name"] = "systray-menu"
  }

  return Widget.Button({
    child: Widget.Icon({
      class_name: "systray-icon",
      icon: item.bind("icon").as((i) => i || icons.missing),
    }),
    cursor: "pointer",
    tooltip_markup: item.bind("tooltip_markup"),
    on_primary_click: (_, event) => item.activate(event),
    on_secondary_click: (_, event) => item.openMenu(event),
  })
}

export const SystemTray = () =>
  Widget.Box({
    class_name: "systray-container",
    children: sysTray.bind("items").as((i) => i.map(SystemTrayItem)),
  })
