import options from "options"
import Date from "./buttons/Date"
import Media from "./buttons/Media"
import Workspaces from "./buttons/Workspaces"
import ColorPicker from "./buttons/ColorPicker"
import Messages from "./buttons/Messages"
import SystemIndicators from "./buttons/SystemIndicators"
import Battery from "./widgets/Battery"
import PowerMenu from "./widgets/PowerMenu"
import SystemTray from "./widgets/SystemTray"
import Preferences from "./widgets/Preferences"
import ScreenRecordingIndicator from "./widgets/ScreenRecordingIndicator"
import MicrophoneIndicator from "./widgets/MicrophoneIndicator"

const { start, center, end } = options.bar.layout
const pos = options.bar.position.bind()

export type BarWidget = keyof typeof widget

const widget = {
  battery: Battery,
  powermenu: PowerMenu,
  systray: SystemTray,
  date: Date,
  media: Media,
  workspaces: Workspaces,
  screenrecord: ScreenRecordingIndicator,
  microphone: MicrophoneIndicator,
  colorpicker: ColorPicker,
  messages: Messages,
  preferences: Preferences,
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
