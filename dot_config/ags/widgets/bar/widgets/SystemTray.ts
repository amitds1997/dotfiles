import { type TrayItem } from "types/service/systemtray"
import PanelWidget from "../PanelWidget"
import Gdk from "gi://Gdk?version=3.0"

const systemtray = await Service.import("systemtray")

const SystemTrayItem = (item: TrayItem) =>
  PanelWidget({
    class_name: "tray-item",
    child: Widget.Icon({ icon: item.bind("icon") }),
    tooltip_markup: item.bind("tooltip_markup"),
    on_primary_click: (_, event) => item.activate(event),
    on_secondary_click: (btn) =>
      item.menu?.popup_at_widget(
        btn,
        Gdk.Gravity.SOUTH,
        Gdk.Gravity.NORTH,
        null,
      ),
  })

export default () =>
  Widget.Box({
    children: systemtray
      .bind("items")
      .as((tray_item) => tray_item.map(SystemTrayItem)),
  })
