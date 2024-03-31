import icons from "lib/icons"
import { ArrowToggleButton, Menu } from "../ToggleButton"
import { zsh } from "lib/utils"

const { wifi } = await Service.import("network")

export const NetworkToggle = () =>
  ArrowToggleButton({
    name: "network",
    icon: wifi.bind("icon_name"),
    label: wifi.bind("ssid").as((ssid) => ssid || "Not connected"),
    connection: [wifi, () => wifi.enabled],
    deactivate: () => (wifi.enabled = false),
    activate: () => {
      wifi.enabled = true
      wifi.scan()
    },
  })

export const WifiSelection = () =>
  Menu({
    name: "network",
    icon: wifi.bind("icon_name"),
    title: "Select WiFi",
    content: [
      Widget.Box({
        vertical: true,
        setup: (self) =>
          self.hook(
            wifi,
            () =>
              (self.children = wifi.access_points.map((ap) =>
                Widget.Button({
                  on_clicked: () => {
                    Utils.execAsync(`nmcli device wifi connect ${ap.bssid}`)
                  },
                  child: Widget.Box({
                    children: [
                      Widget.Icon(ap.iconName),
                      Widget.Label(ap.ssid || ""),
                      Widget.Icon({
                        icon: icons.ui.tick,
                        hexpand: true,
                        hpack: "end",
                        setup: (self) =>
                          Utils.idle(() => {
                            if (!self.is_destroyed) self.visible = ap.active
                          }),
                      }),
                    ],
                  }),
                }),
              )),
          ),
      }),
      Widget.Separator(),
      Widget.Button({
        on_clicked: () => zsh("nmtui"),
        child: Widget.Box({
          children: [Widget.Icon(icons.ui.settings), Widget.Label("Network")],
        }),
      }),
    ],
  })
