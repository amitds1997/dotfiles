import icons from "lib/icons"
import PanelWidget from "../PanelWidget"

const bluetooth = await Service.import("bluetooth")

const BluetoothWidget = () =>
  Widget.Overlay({
    class_name: "bluetooth",
    pass_through: true,
    child: Widget.Icon({
      icon: icons.bluetooth.enabled,
      visible: bluetooth.bind("enabled"),
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
    on_clicked: () => App.toggleWindow("bluetooth"),
  })
