import icons from "lib/icons"
import PanelWidget from "../PanelWidget"

const bluetooth = await Service.import("bluetooth")

const DisabledWidget = () =>
  Widget.Icon({
    icon: icons.bluetooth.disabled,
    tooltip_text: "Bluetooth is disabled",
  })

const EnabledWidget = () =>
  Widget.Icon({
    icon: icons.bluetooth.enabled,
    tooltip_text: bluetooth.bind("connected_devices").as((p) => {
      if (p.length == 0) return "No devices connected"
      if (p.length == 1) return `Connected to ${p[0].alias}`

      return `${bluetooth.connected_devices.length} devices connected`
    }),
  })

export default () =>
  PanelWidget({
    class_name: "bluetooth",
    child: bluetooth
      .bind("enabled")
      .as((e) => (e ? EnabledWidget() : DisabledWidget())),
    tooltip_text: Utils.watch("Disabled", bluetooth, () => {
      if (!bluetooth.enabled) return "Bluetooth is disabled"

      if (bluetooth.connected_devices.length == 1)
        return `Connected to ${bluetooth.connected_devices[0].alias}`

      return `${bluetooth.connected_devices.length} devices connected`
    }),
    on_clicked: () => App.toggleWindow("bluetooth"),
  })
