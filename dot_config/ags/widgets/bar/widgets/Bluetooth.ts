import icons from "lib/icons"
import PanelWidget from "../PanelWidget"
import { PopupNames } from "widgets/PopupWindow"

const bluetooth = await Service.import("bluetooth")

const BluetoothWidget = () =>
  Widget.Overlay({
    class_name: "bluetooth",
    pass_through: true,
    child: Widget.Icon({
      icon: bluetooth
        .bind("enabled")
        .as((e) => (e ? icons.bluetooth.enabled : icons.bluetooth.disabled)),
    }),
    overlay: Widget.Label({
      hpack: "end",
      vpack: "start",
      label: bluetooth.bind("connected_devices").as((c) => `${c.length}`),
      visible: bluetooth.bind("connected_devices").as((c) => c.length > 0),
    }),
  })

export default () =>
  PanelWidget({
    class_name: "bluetooth",
    child: BluetoothWidget(),
    tooltip_text: Utils.watch("Disabled", bluetooth, () => {
      if (!bluetooth.enabled) return "Bluetooth is disabled"

      if (bluetooth.connected_devices.length == 1)
        return `Connected to ${bluetooth.connected_devices[0].alias}`

      return `${bluetooth.connected_devices.length} devices connected`
    }),
    on_clicked: () => App.toggleWindow(PopupNames.Bluetooth),
  })
