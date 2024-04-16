import options from "options"
import Date from "./widgets/Date"
import Workspaces from "./widgets/Workspaces"
import ColorPicker from "./widgets/ColorPicker"
import Messages from "./widgets/Messages"
import Battery from "./widgets/Battery"
import PowerMenu from "./widgets/PowerMenu"
import SystemTray from "./widgets/SystemTray"
import Preferences from "./widgets/Preferences"
import ScreenRecordingIndicator from "./widgets/ScreenRecordingIndicator"
import MicrophoneIndicator from "./widgets/MicrophoneIndicator"
import Bluetooth from "./widgets/Bluetooth"
import Network from "./widgets/Network"
import Audio from "./widgets/Audio"

const { start, center, end } = options.bar.layout
const pos = options.bar.position.bind()

export type BarWidget = keyof typeof widget

const widget = {
  battery: Battery,
  powermenu: PowerMenu,
  systray: SystemTray,
  date: Date,
  workspaces: Workspaces,
  screenrecord: ScreenRecordingIndicator,
  microphone: MicrophoneIndicator,
  colorpicker: ColorPicker,
  messages: Messages,
  preferences: Preferences,
  audio: Audio,
  bluetooth: Bluetooth,
  network: Network,
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
