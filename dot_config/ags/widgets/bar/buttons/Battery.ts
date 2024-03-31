import options from "options"
import PanelButton from "../PanelButton"
import icons from "lib/icons"
import { singleSpaceWidget } from "lib/utils"

const battery = await Service.import("battery")
const { percentage, bar, low } = options.bar.battery

const Indicator = () =>
  Widget.Icon({
    setup: (self) =>
      self.hook(battery, () => {
        self.icon = battery.charging
          ? icons.battery.charging
          : battery.charged
            ? icons.battery.charged
            : battery.icon_name
      }),
  })

const PercentLabel = () =>
  Widget.Revealer({
    transition: "slide_right",
    click_through: true,
    reveal_child: percentage.bind(),
    child: Widget.Label({
      label: battery.bind("percent").as((p) => `${p}%`),
    }),
  })

const Regular = () =>
  Widget.Box({
    class_name: "regular",
    children: [Indicator(), singleSpaceWidget(), PercentLabel()],
  })

export default () =>
  PanelButton({
    class_name: "battery-button",
    hexpand: false,
    on_clicked: () => {
      percentage.value = !percentage.value
    },
    visible: battery.bind("available"),
    child: Widget.Box({
      expand: true,
      visible: battery.bind("available"),
      child: Regular(),
    }),
    tooltip_text: battery.bind("time_remaining").as((t) => {
      const format = (p: number) => {
        p = Math.round(p * 100) / 100
        return p < 10 ? "0" + p : p
      }
      const sec = format(t % 60)
      const min = format(Math.floor((t % 3600) / 60))
      const hr = Math.floor(t / 3600)

      const chargeState = `(${battery.charging ? "charging" : "discharging"})`
      if (hr < 1) {
        return `${min}:${sec} min(s) remaining ${chargeState}`
      } else {
        return `${format(hr)}:${min} hour(s) remaining ${chargeState}`
      }
    }),
    setup: (self) =>
      self
        .hook(bar, (w) =>
          w.toggleClassName("bar-hidden", bar.value === "hidden"),
        )
        .hook(battery, (w) => {
          w.toggleClassName("charging", battery.charging || battery.charged)
          w.toggleClassName("low", battery.percent < low.value)
        }),
  })
