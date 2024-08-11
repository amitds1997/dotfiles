import options from "options"
import { RoundedAngleEnd } from "./RoundedCorner"
import { Workspaces } from "./bar/Workspaces"
import { WindowTitle } from "./bar/WindowTitle"
import { Clock } from "./bar/Clock"
import { Battery } from "./bar/Battery"
import { Audio } from "./bar/Audio"
import { Network } from "./bar/Network"
import { SystemTray } from "./bar/SystemTray"
import { NotificationIndicator } from "./bar/Notifications"
import { MusicBarContainerRevealer } from "./bar/Music"

const { position } = options.bar
const { hideEmpty } = options.bar.workspaces

export enum WindowNames {
  Launcher = "launcher",
  QuickSettings = "quicksettings",
  PopupNotifications = "popupNotifications",
}

const Left = () =>
  Widget.EventBox({
    hpack: "start",
    on_secondary_click_release: () => (hideEmpty.value = !hideEmpty.value),
    child: Widget.Box({
      children: [Workspaces(), WindowTitle()],
    }),
  })

const Center = () =>
  Widget.Box({
    css: "margin: 0px 1px 1px 1px;",
    children: [MusicBarContainerRevealer()],
  })

const Right = () =>
  Widget.EventBox({
    hpack: "end",
    child: Widget.Box({
      children: [
        SystemTray(),
        Widget.EventBox({
          on_primary_click_release: () =>
            App.toggleWindow(WindowNames.QuickSettings),
          on_secondary_click_release: () =>
            App.toggleWindow(WindowNames.Launcher),
          child: Widget.Box({
            children: [
              Audio(),
              Battery(),
              Network(),
              NotificationIndicator(),
              Clock(),
            ],
          }),
        }),
      ],
    }),
  })

const Bar = () => {
  const left = Left()
  const center = Center()
  const right = Right()

  const bar = Widget.CenterBox({
    start_widget: Widget.Box({
      children: position
        .bind("value")
        .as((p) => [
          left,
          RoundedAngleEnd(`${p}right`, { class_name: "angle" }),
        ]),
    }),
    center_widget: center,
    end_widget: Widget.Box({
      children: position.bind("value").as((p) => [
        Widget.Box({
          hexpand: true,
        }),
        RoundedAngleEnd(`${p}left`, {
          class_name: "angle",
          click_through: true,
        }),
        right,
      ]),
    }),
  })

  return bar
}

export const BarWindow = (monitor: number) =>
  Widget.Window({
    monitor,
    name: `bar-${monitor}`,
    class_name: "bar",
    anchor: position.bind("value").as((pos) => [pos, "left", "right"]),
    exclusivity: "exclusive",
    child: Bar(),
  })
