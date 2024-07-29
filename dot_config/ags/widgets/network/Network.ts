import icons from "lib/icons"
import options from "options"
import PopupWindow, { PopupNames } from "widgets/PopupWindow"
import { debounce, get_icon } from "lib/utils"
import { setUpBarWindow } from "widgets/BarWindow"
import { WiFiPreferences } from "./WiFiPreferences"

const { preferences } = options
const network = await Service.import("network")
const { wired, wifi } = network
export const apps = await Service.import("applications")
export type APType = (typeof wifi.access_points)[number]

export const debouncedWiFiScan = debounce(wifi.scan, 2000)

const isActiveAP = (ap: APType) => {
  return wifi.ssid === ap.ssid && wifi.frequency === ap.frequency
}

export const WiFiAPItem = (ap: APType) =>
  Widget.ToggleButton({
    hexpand: true,
    on_toggled: () => {
      if (isActiveAP(ap)) {
        const cmd = `bash -c "nmcli -t -f FILENAME,UUID connection show --active | \
        grep -i '${ap.ssid}' | \
        cut -d ':' -f 2 | \
        xargs -I {} nmcli connection down {}"`
        Utils.execAsync(cmd).catch((err) =>
          console.error(
            `Error disconnecting from ${ap.ssid} (${ap.bssid})`,
            err,
          ),
        )
      } else {
        const cmd = `nmcli device wifi connect ${ap.bssid}`
        Utils.execAsync(cmd).catch((err) => {
          if (
            typeof err === "string" &&
            err.includes("Secrets were required, but not provided")
          ) {
            // If there is need for a password, show the popup now
            const password_input_window = PopupWindow({
              name: PopupNames.PasswordInput,
              exclusivity: "exclusive",
              keymode: "exclusive",
              layout: "center",
              transition: "crossfade",
              child: Widget.Box({
                child: Widget.Entry({
                  placeholder_text: "Enter your WiFi password",
                  visibility: false,
                  onAccept: (self) => {
                    Utils.execAsync(
                      `nmcli device wifi connect ${ap.bssid} password ${self.text}`,
                    ).catch((err) => {
                      console.error(
                        `Failed connecting to ${ap.ssid} (${ap.bssid}) even with password`,
                        err,
                      )
                    })
                    App.closeWindow(PopupNames.PasswordInput)
                    App.removeWindow(App.getWindow(PopupNames.PasswordInput)!)
                  },
                }),
              }),
            })
            App.addWindow(password_input_window)
            password_input_window.show()
          } else {
            console.error(`Error connecting to ${ap.ssid} (${ap.bssid})`, err)
          }
        })
      }
    },
    child: Widget.Box({
      hexpand: true,
      children: [
        Widget.Box({
          hpack: "start",
          children: [
            Widget.Icon(get_icon(ap.iconName || null, icons.network.ap)),
            Widget.Label(ap.ssid!),
          ],
        }),
        Widget.Box({
          hpack: "end",
          hexpand: true,
          children: [
            Widget.Icon({
              visible: wifi
                .bind("internet")
                .as((i) => isActiveAP(ap) && i === "connected"),
              icon: get_icon(icons.network.selected),
            }),
            Widget.Spinner({
              active: wifi.bind("internet").as((i) => i === "connecting"),
              visible: wifi
                .bind("internet")
                .as((i) => i === "connecting" && isActiveAP(ap)),
            }),
          ],
        }),
      ],
    }),
  })

const WiredPreferences = () => {
  return Widget.Box({
    vertical: true,
    class_name: "wired-preferences vertical",
    css: preferences.width.bind().as((w) => `min-width: ${w}px;`),
    children: [
      Widget.Box({
        vertical: false,
        hexpand: true,
        children: [
          Widget.Label({
            hpack: "start",
            visible: wired.bind("internet").as((p) => p === "disconnected"),
            label: "Ethernet is disabled",
          }),
          Widget.Button({
            child: Widget.Icon(icons.ui.settings),
            on_clicked: () => {
              apps.query("Network")[0].launch()
            },
          }),
        ],
      }),
    ],
  })
}

export function setUpNetworkMenu() {
  setUpBarWindow({
    name: PopupNames.Network,
    child: network
      .bind("primary")
      .as((p) => (p === "wired" ? WiredPreferences() : WiFiPreferences())),
  })
}
