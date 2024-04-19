import icons from "lib/icons"
import GObject from "gi://GObject"
import options from "options"
import PopupWindow from "widgets/PopupWindow"
import { debounce, get_icon } from "lib/utils"

const { bar, preferences } = options
const layout = Utils.derive(
  [bar.position, preferences.position],
  (bar, p) => `${bar}-${p}` as const,
)
const network = await Service.import("network")
const { wired, wifi } = network
const apps = await Service.import("applications")
type APType = (typeof wifi.access_points)[number]

const debounced_scan = debounce(wifi.scan, 2000)

const isActiveAp = (ap: APType) => {
  return wifi.ssid === ap.ssid && wifi.frequency === ap.frequency
}

const APItem = (ap: APType) =>
  Widget.ToggleButton({
    hexpand: true,
    on_toggled: () => {
      if (isActiveAp(ap)) {
        const cmd = `bash -c "nmcli -t -f FILENAME,UUID connection show --active | grep -i '${ap.ssid}' | cut -d ':' -f 2 | xargs -I {} nmcli connection down {}"`
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
              name: "password-input",
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
                    App.closeWindow("password-input")
                    App.removeWindow(App.getWindow("password-input")!)
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
                .as((i) => isActiveAp(ap) && i === "connected"),
              icon: get_icon(icons.network.selected),
            }),
            Widget.Spinner({
              active: wifi.bind("internet").as((i) => i === "connecting"),
              visible: wifi
                .bind("internet")
                .as((i) => i === "connecting" && isActiveAp(ap)),
            }),
          ],
        }),
      ],
    }),
  })

const WiFiPreferences = () =>
  Widget.Box({
    vertical: true,
    class_name: "wifi-preferences vertical",
    css: preferences.width.bind().as((w) => `min-width: ${w}px;`),
    children: [
      Widget.Box({
        vertical: false,
        hexpand: true,
        children: [
          Widget.Label({
            hpack: "start",
            visible: wifi.bind("enabled").as((p) => !p),
            label: "WiFi is disabled",
          }),
          Widget.Button({
            child: Widget.Icon(icons.ui.settings),
            on_clicked: () => {
              apps.query("Network")[0].launch()
            },
          }),
          Widget.Button({
            visible: wifi.bind("enabled"),
            child: Widget.Icon(icons.network.scan),
            on_clicked: () => {
              debounced_scan()
            },
          }),
          Widget.Switch({
            hpack: "end",
            hexpand: true,
            active: wifi.enabled,
            setup: (self) => {
              self.bind_property(
                "active",
                wifi,
                "enabled",
                GObject.BindingFlags.BIDIRECTIONAL,
              )
            },
          }),
        ],
      }),
      Widget.Box({
        vertical: true,
        visible: wifi.bind("enabled"),
        children: [
          Widget.Label({
            xalign: 0,
            justification: "left",
            label: "Networks",
          }),
          Widget.Separator({
            vertical: false,
            visible: wifi.bind("access_points").as((ap) => ap.length > 0),
          }),
          Widget.Scrollable({
            hscroll: "never",
            vscroll: "automatic",
            class_name: "wifi-networks",
            child: Widget.Box({
              hexpand: true,
              vertical: true,
              children: wifi.bind("access_points").as((aps) =>
                // Network Manager does not allow connecting to different AP endpoints if they have the same SSID :/
                // So, there is no point showing it here. The only option is to delete the connection manually using
                // the CMD and make the new connection manually
                Object.values(
                  aps.reduce<{ [ssid: string]: APType }>((n, ap) => {
                    if (
                      ap.ssid != null &&
                      (!n[ap.ssid] || ap.frequency > n[ap.ssid].frequency)
                    ) {
                      n[ap.ssid] = ap
                    }
                    return n
                  }, {}),
                )
                  .sort((ap1, ap2) => {
                    if (wifi.ssid === ap1.ssid) return -1
                    if (wifi.ssid === ap2.ssid) return 1

                    return ap2.strength - ap1.strength
                  })
                  .map(APItem),
              ),
            }),
          }),
        ],
      }),
    ],
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

export default () =>
  PopupWindow({
    name: "network",
    exclusivity: "exclusive",
    transition: bar.position
      .bind()
      .as((p) => (p === "top" ? "slide_down" : "slide_up")),
    layout: layout.value,
    child: network
      .bind("primary")
      .as((p) => (p == "wired" ? WiredPreferences() : WiFiPreferences())),
  })
