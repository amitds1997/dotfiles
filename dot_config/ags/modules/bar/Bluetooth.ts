import Gdk30 from "gi://Gdk?version=3.0"
import options from "options"
import { openMenu } from "./utils"

const bluetooth = await Service.import("bluetooth")

const { show_label: showLabel } = options.car.bluetooth

export const Bluetooth = () => {
  const btIcon = Widget.Label({
    label: bluetooth.bind("enabled").as((v) => (v ? "󰂯" : "󰂲")),
    class_name: "bar-button-icon bluetooth",
  })

  const btText = Widget.Label({
    label: Utils.merge(
      [bluetooth.bind("enabled"), bluetooth.bind("connected_devices")],
      (isEnabled, btDevices) => {
        return isEnabled && btDevices.length > 0
          ? `Connected (${btDevices.length})`
          : isEnabled
            ? "On"
            : "Off"
      },
    ),
    class_name: "bar-button-label bluetooth",
  })

  return {
    component: Widget.Box({
      class_name: "bluetooth",
      children: showLabel.bind("value").as((showLabel) => {
        if (showLabel) {
          return [btIcon, btText]
        }
        return [btIcon]
      }),
    }),
    isVisible: true,
    boxClass: "bluetooth",
    props: {
      on_primary_click: (clicked: any, event: Gdk30.Event) => {
        openMenu(clicked, event, "bluetoothmenu")
      },
    },
  }
}
