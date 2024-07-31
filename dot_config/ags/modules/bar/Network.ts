import Gdk from "gi://Gdk?version=3.0"
import options from "options"
import { openMenu } from "./utils"

const { show_label: showLabel } = options.car.network

const network = await Service.import("network")
export const Network = () => {
  const wifiIndicator = [
    Widget.Icon({
      class_name: "bar-button-icon network",
      icon: network.wifi.bind("icon_name"),
    }),
    Widget.Box({
      children: Utils.merge(
        [network.bind("wifi"), showLabel.bind("value")],
        (wifi, shouldShowLabel) => {
          if (!shouldShowLabel) {
            return []
          }
          return [
            Widget.Label({
              class_name: "bar-button-label network",
              label: wifi.ssid ? `${wifi.ssid.substring(0, 7)}` : "--",
            }),
          ]
        },
      ),
    }),
  ]

  const wiredIndicator = [
    Widget.Icon({
      class_name: "bar-button-icon network",
      icon: network.wired.bind("icon_name"),
    }),
    Widget.Box({
      children: showLabel.bind("value").as((s) => {
        if (!s) {
          return []
        }
        return [
          Widget.Label({
            class_name: "bar-button-label network",
            label: "Wired",
          }),
        ]
      }),
    }),
  ]

  return {
    component: Widget.Box({
      vpack: "center",
      class_name: "bar-network",
      children: network
        .bind("primary")
        .as((w) => (w === "wired" ? wiredIndicator : wifiIndicator)),
    }),
    isVisible: true,
    boxClass: "network",
    props: {
      on_primary_click: (clicked: any, event: Gdk.Event) => {
        openMenu(clicked, event, "networkmenu")
      },
    },
  }
}
