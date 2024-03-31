import Gtk from "gi://Gtk?version=3.0"
import options from "options"
import PopupWindow from "widgets/window/PopupWindow"
import { Header } from "./widgets/Header"
import { Media } from "./widgets/Media"
import { BluetoothDevices, BluetoothToggle } from "./widgets/Bluetooth"
import { MicMute } from "./widgets/MicMute"
import { DND } from "./widgets/DND"
import { AppMixer, Microphone, SinkSelector, Volume } from "./widgets/Volume"
import { NetworkToggle, WifiSelection } from "./widgets/Network"

const { bar, quicksettings } = options
const media = (await Service.import("mpris")).bind("players")
const layout = Utils.derive(
  [bar.position, quicksettings.position],
  (bar, qs) => `${bar}-${qs}` as const,
)

const Row = (
  toggles: Array<() => Gtk.Widget> = [],
  menus: Array<() => Gtk.Widget> = [],
) =>
  Widget.Box({
    vertical: true,
    children: [
      Widget.Box({
        homogeneous: true,
        class_name: "row horizontal",
        children: toggles.map((w) => w()),
      }),
      ...menus.map((w) => w()),
    ],
  })

const Settings = () =>
  Widget.Box({
    vertical: true,
    class_name: "quicksettings vertical",
    css: quicksettings.width.bind().as((w) => `min-width: ${w}px;`),
    children: [
      Header(),
      Widget.Box({
        class_name: "sliders-box vertical",
        vertical: true,
        children: [Row([Volume], [SinkSelector, AppMixer]), Microphone()],
      }),
      Row([NetworkToggle, BluetoothToggle], [WifiSelection, BluetoothDevices]),
      Row([MicMute, DND]),
      Widget.Box({
        visible: media.as((l) => l.length > 0),
        child: Media(),
      }),
    ],
  })

const QuickSettings = () =>
  PopupWindow({
    name: "quicksettings",
    exclusivity: "exclusive",
    transition: bar.position
      .bind()
      .as((pos) => (pos === "top" ? "slide_down" : "slide_up")),
    layout: layout.value,
    child: Settings(),
  })

export function setupQuickSettings() {
  App.addWindow(QuickSettings())
  layout.connect("changed", () => {
    App.removeWindow("quicksettings")
    App.addWindow(QuickSettings())
  })
}
