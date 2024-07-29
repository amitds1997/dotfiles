import icons from "lib/icons"
import { get_icon } from "lib/utils"
import GObject from "gi://GObject"
import { BluetoothDevice } from "types/service/bluetooth"
import { setUpBarWindow } from "widgets/BarWindow"
import { PopupNames } from "widgets/PopupWindow"

const bluetooth = await Service.import("bluetooth")
const apps = await Service.import("applications")

const DeviceItem = (device: BluetoothDevice) => {
  return Widget.ToggleButton({
    hexpand: true,
    on_toggled: () => {
      device.setConnection(!device.connected)
    },
    child: Widget.Box({
      hexpand: true,
      children: [
        Widget.Box({
          hpack: "start",
          children: [
            Widget.Icon(
              get_icon(device.icon_name + "-symbolic", icons.bluetooth.enabled),
            ),
            Widget.Label(device.alias),
          ],
        }),
        Widget.Box({
          hpack: "end",
          hexpand: true,
          children: [
            Widget.Label({
              visible: device.bind("connected"),
              label: device.bind("battery_percentage").as((p) => `${p}%`),
            }),
            Widget.Spinner({
              active: device.bind("connecting"),
              visible: device.bind("connecting"),
            }),
          ],
        }),
      ],
    }),
  })
}

const BluetoothPreferences = () =>
  Widget.Box({
    vertical: true,
    class_name: "bluetooth-preferences",
    children: [
      Widget.Box({
        vertical: false,
        hexpand: true,
        children: [
          Widget.Label({
            hpack: "start",
            visible: bluetooth.bind("enabled").as((p) => !p),
            label: "Bluetooth is disabled",
          }),
          Widget.Button({
            visible: bluetooth.bind("enabled"),
            child: Widget.Icon(icons.ui.settings),
            on_clicked: () => {
              apps.query("Bluetooth")[0].launch()
            },
          }),
          Widget.Switch({
            hpack: "end",
            hexpand: true,
            active: bluetooth.enabled,
            setup: (self) => {
              self.bind_property(
                "active",
                bluetooth,
                "enabled",
                GObject.BindingFlags.BIDIRECTIONAL,
              )
            },
          }),
        ],
      }),
      Widget.Box({
        vertical: true,
        visible: bluetooth.bind("enabled"),
        children: [
          Widget.Label({
            xalign: 0,
            justification: "left",
            label: "Connected devices",
          }),
          Widget.Separator({
            vertical: false,
          }),
          Widget.Box({
            class_name: "bluetooth-connected-devices",
            hexpand: true,
            vertical: true,
            children: bluetooth.bind("connected_devices").as((cd) => {
              return cd.map(DeviceItem)
            }),
          }),
          Widget.Label({
            xalign: 0,
            justification: "left",
            label: "Available devices",
          }),
          Widget.Separator({
            vertical: false,
            visible: bluetooth.bind("devices").as((d) => d.length > 0),
          }),
          Widget.Scrollable({
            hscroll: "never",
            vscroll: "automatic",
            class_name: "bluetooth-available-devices",
            child: Widget.Box({
              hexpand: true,
              vertical: true,
              children: bluetooth
                .bind("devices")
                .as((dvs) => dvs.filter((d) => !d.connected).map(DeviceItem)),
              setup: (self) => {
                self.hook(
                  bluetooth,
                  () =>
                    (self.children = bluetooth.devices
                      .filter((d) => !d.connected)
                      .map(DeviceItem)),
                  "changed",
                )
              },
            }),
          }),
        ],
      }),
    ],
  })

export function setUpBluetoothMenu() {
  setUpBarWindow({ name: PopupNames.Bluetooth, child: BluetoothPreferences() })
}
