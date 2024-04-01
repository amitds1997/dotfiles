import icons from "lib/icons"
import powermenu, { Action } from "services/powermenu"

const battery = await Service.import("battery")

const SysButton = (action: Action) =>
  Widget.Button({
    vpack: "center",
    child: Widget.Icon(icons.powermenu[action]),
    on_clicked: () => {
      powermenu.action(action)
    },
  })

export const Header = () =>
  Widget.Box(
    { class_name: "header horizontal" },
    Widget.Box({
      vertical: true,
      vpack: "center",
      children: [
        Widget.Box({
          visible: battery.bind("available"),
          children: [
            Widget.Icon({ icon: battery.bind("icon_name") }),
            Widget.Label({ label: battery.bind("percent").as((p) => `${p}%`) }),
          ],
        }),
      ],
    }),
    Widget.Box({ hexpand: true }),
    Widget.Button({
      vpack: "center",
      child: Widget.Icon(icons.ui.settings),
      on_clicked: () => {
        App.closeWindow("quicksettings")
        App.closeWindow("settings-dialog")
        App.openWindow("settings-dialog")
      },
    }),
    SysButton("logout"),
    SysButton("shutdown"),
  )
