import options from "options"
import PanelWidget from "../PanelWidget"
import icons from "lib/icons"

const battery = await Service.import("battery")
const { low } = options.bar.battery

const Indicator = () =>
  Widget.Icon({
    hpack: "start",
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
  Widget.Label({
    hpack: "end",
    hexpand: true,
    label: battery.bind("percent").as((p) => `${p}%`),
  })

export default () =>
  PanelWidget({
    window_class: "battery",
    hexpand: false,
    visible: battery.bind("available"),
    child: Widget.Box({
      expand: true,
      children: [Indicator(), PercentLabel()],
    }),
    tooltip_text: battery.bind("time_remaining").as((t) => {
      const format = (p: number) => {
        p = Math.round(p * 100) / 100
        return p < 10 ? "0" + p : p
      }
      const sec = format(t % 60)
      const min = format(Math.floor((t % 3600) / 60))
      const hr = Math.floor(t / 3600)

      const chargeState = battery.charging ? "to full charge" : "to empty"
      if (hr < 1) {
        return `${min} mins ${sec} sec(s) ${chargeState}`
      } else {
        return `${format(hr)} hrs ${min} min(s) ${chargeState}`
      }
    }),
    setup: (self) =>
      self.hook(battery, (w) => {
        w.toggleClassName("charging", battery.charging)
        w.toggleClassName("charged", battery.charged)
        w.toggleClassName("low", battery.percent < low.value)
      }),
  })
