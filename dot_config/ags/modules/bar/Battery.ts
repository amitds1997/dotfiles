import Gdk from "gi://Gdk?version=3.0"
import options from "options"
import { openMenu } from "./utils"

const battery = await Service.import("battery")

const { label: show_label } = options.car.battery

export const BatteryLabel = () => {
  const isVis = Variable(battery.available)

  const icon = () =>
    battery
      .bind("percent")
      .as((p) => `battery-level-${Math.floor(p / 10) * 10}-symbolic`)

  battery.connect("changed", ({ available }) => {
    isVis.value = available
  })

  const formatTime = (seconds: number) => {
    const hours = Math.floor(seconds / 3600)
    const minutes = Math.floor((seconds % 3600) / 60)
    return { hours, minutes }
  }

  const generateTooltip = (
    timeSeconds: number,
    isCharging: boolean,
    isCharged: boolean,
  ) => {
    if (isCharged) {
      return "Fully charged"
    }

    const { hours, minutes } = formatTime(timeSeconds)

    if (isCharging) {
      return `${hours} hours ${minutes} minutes until full`
    } else {
      return `${hours} hours ${minutes} minutes left`
    }
  }

  return {
    component: Widget.Box({
      class_name: "battery",
      visible: battery.bind("available"),
      tooltip_text: battery.bind("time_remaining").as((t) => t.toString()),
      children: Utils.merge(
        [battery.bind("available"), show_label.bind("value")],
        (isAvailable, showLabel) => {
          if (isAvailable && showLabel) {
            return [
              Widget.Icon({
                class_name: "bar-button-icon battery",
                icon: icon(),
              }),
              Widget.Label({
                class_name: "bar-button-label battery",
                label: battery.bind("percent").as((p) => `${Math.floor(p)}%`),
              }),
            ]
          } else if (isAvailable && !showLabel) {
            return [
              Widget.Icon({
                icon: icon(),
              }),
            ]
          } else {
            return []
          }
        },
      ),
      setup: (self) => {
        self.hook(battery, () => {
          if (battery.available) {
            self.tooltip_text = generateTooltip(
              battery.time_remaining,
              battery.charging,
              battery.charged,
            )
          }
        })
      },
    }),
    isVis,
    boxClass: "battery",
    props: {
      on_primary_click: (clicked: any, event: Gdk.Event) => {
        openMenu(clicked, event, "energymenu")
      },
    },
  }
}
