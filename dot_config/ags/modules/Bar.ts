import options from "options"

import { BarItemBox as WidgetContainer } from "shared/barItemBox"
import { ClientTitle } from "./bar/WindowTitle"
import { Workspaces } from "./bar/Workspaces"
import { SysTray } from "./bar/SysTray"
import { Media } from "./bar/Media"
import { BatteryLabel } from "./bar/Battery"
import { Clock } from "./bar/Clock"

const { layouts } = options.car
export type BarWidget = keyof typeof widget

type Section =
  | "battery"
  | "dashboard"
  | "workspaces"
  | "windowtitle"
  | "media"
  | "notifications"
  | "volume"
  | "network"
  | "bluetooth"
  | "clock"
  | "systray"

type Layout = {
  left: Section[]
  middle: Section[]
  right: Section[]
}

type BarLayout = {
  [key: string]: Layout
}

const getLayoutForMonitor = (monitor: number, preferredLayouts: BarLayout) => {
  const foundMonitor = Object.keys(preferredLayouts).find(
    (mon) => mon === monitor.toString(),
  )
  const defaultLayout = {
    left: ["dashboard", "workspaces", "windowtitle"],
    middle: ["media"],
    right: [
      "volume",
      "network",
      "bluetooth",
      "battery",
      "systray",
      "clock",
      "notifications",
    ],
  }

  if (foundMonitor === undefined) {
    return defaultLayout
  }

  return preferredLayouts[foundMonitor]
}

const widget = {
  battery: () => WidgetContainer(BatteryLabel()),
  dashboard: () => WidgetContainer(Menu()),
  workspaces: (monitor: number) => WidgetContainer(Workspaces(monitor, 10)),
  windowtitle: () => WidgetContainer(ClientTitle()),
  media: () => WidgetContainer(Media()),
  notifications: () => WidgetContainer(Notifications()),
  volume: () => WidgetContainer(Volume()),
  network: () => WidgetContainer(Network()),
  bluetooth: () => WidgetContainer(Bluetooth()),
  clock: () => WidgetContainer(Clock()),
  systray: () => WidgetContainer(SysTray()),
}

export const Bar = (monitor: number) => {
  return Widget.Window({
    name: `bar-${monitor}`,
    class_name: "bar",
    monitor,
    visible: true,
    anchor: ["top", "left", "right"],
    exclusivity: "exclusive",
    child: Widget.Box({
      class_name: "bar-panel-container",
      child: Widget.CenterBox({
        class_name: "bar-panel",
        css: "padding: 1px",
        startWidget: Widget.Box({
          class_name: "box-left",
          hexpand: true,
          setup: (self) => {
            self.hook(layouts, (self) => {
              const foundLayout = getLayoutForMonitor(
                monitor,
                layouts.value as BarLayout,
              )
              self.children = foundLayout.left
                .filter((mod) => Object.keys(widget).includes(mod))
                .map((w) => widget[w](monitor))
            })
          },
        }),
        centerWidget: Widget.Box({
          class_name: "box-center",
          hpack: "center",
          setup: (self) => {
            self.hook(layouts, (self) => {
              const foundLayout = getLayoutForMonitor(
                monitor,
                layouts.value as BarLayout,
              )
              self.children = foundLayout.middle
                .filter((mod) => Object.keys(widget).includes(mod))
                .map((w) => widget[w](monitor))
            })
          },
        }),
        endWidget: Widget.Box({
          class_name: "box-right",
          hpack: "end",
          setup: (self) => {
            self.hook(layouts, (self) => {
              const foundLayout = getLayoutForMonitor(
                monitor,
                layouts.value as BarLayout,
              )
              self.children = foundLayout.right
                .filter((mod) => Object.keys(widget).includes(mod))
                .map((w) => widget[w](monitor))
            })
          },
        }),
      }),
    }),
  })
}
