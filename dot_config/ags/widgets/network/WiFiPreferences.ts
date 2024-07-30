import icons from "lib/icons"
import GObject from "types/@girs/gobject-2.0/gobject-2.0"
import { apps, debouncedWiFiScan, APType, WiFiAPItem } from "./Network"
import options from "options"

const { preferences } = options
const { wifi } = await Service.import("network")

export const WiFiPreferences = () =>
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
              debouncedWiFiScan()
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
                // Network Manager does not allow connecting to different AP endpoints if they have
                // the same SSID. So, there is no point showing it here. The only option is to
                // delete the connection manually using the CMD and make the new connection manually
                Object.values(
                  aps.reduce<{ [ssid: string]: APType }>((n, ap) => {
                    if (
                      ap.ssid !== null &&
                      (!n[ap.ssid] || ap.frequency > n[ap.ssid].frequency)
                    ) {
                      n[ap.ssid] = ap
                    }
                    return n
                  }, {}),
                )
                  .sort((ap1, ap2) => {
                    if (wifi.ssid === ap1.ssid) {
                      return -1
                    }
                    if (wifi.ssid === ap2.ssid) {
                      return 1
                    }

                    return ap2.strength - ap1.strength
                  })
                  .map(WiFiAPItem),
              ),
            }),
          }),
        ],
      }),
    ],
  })
