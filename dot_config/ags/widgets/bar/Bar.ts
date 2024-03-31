import options from "options"
import Battery from "./buttons/Battery"
import Date from "./buttons/Date"
import Media from "./buttons/Media"
import PowerMenu from "./buttons/PowerMenu"
import Workspaces from "./buttons/Workspaces"
import SysTray from "./buttons/SysTray"
import ColorPicker from "./buttons/ColorPicker"
import ScreenRecord from "./buttons/ScreenRecord"
import Messages from "./buttons/Messages"
import SystemIndicators from "./buttons/SystemIndicators"

const { start, center, end } = options.bar.layout
const pos = options.bar.position.bind()

export type BarWidget = keyof typeof widget

const widget = {
  battery: Battery,
  date: Date,
  media: Media,
  powermenu: PowerMenu,
  workspaces: Workspaces,
  systray: SysTray,
  screenrecord: ScreenRecord,
  colorpicker: ColorPicker,
  messages: Messages,
  system: SystemIndicators,
  expander: () => Widget.Box({ expand: true }),
}

export default (monitor: number) =>
  Widget.Window({
    monitor,
    class_name: "bar",
    name: `bar-${monitor}`,
    exclusivity: "exclusive",
    anchor: pos.as((pos) => [pos, "right", "left"]),
    child: Widget.CenterBox({
      css: "min-width: 2px; min-height: 2px;",
      startWidget: Widget.Box({
        hexpand: true,
        children: start.bind().as((s) => s.map((w) => widget[w]())),
      }),
      centerWidget: Widget.Box({
        hpack: "center",
        children: center.bind().as((c) => c.map((w) => widget[w]())),
      }),
      endWidget: Widget.Box({
        hexpand: true,
        children: end.bind().as((e) => e.map((w) => widget[w]())),
      }),
    }),
  })
