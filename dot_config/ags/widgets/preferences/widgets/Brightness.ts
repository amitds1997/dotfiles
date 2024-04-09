import icons from "lib/icons"
import brightness from "services/brightness"

const BrightnessSlider = (id: number) =>
  Widget.Slider({
    draw_value: false,
    hexpand: true,
    value: brightness.bind("monitors").as((mon) => mon.get(id)!.percent!),
    on_change: ({ value }) => brightness.brightness(value, id),
  })

export const Brightness = () =>
  Widget.Box({
    class_name: "brightness",
    vertical: true,
    setup: (self) =>
      (self.children = Array.from(brightness.monitors.keys()).map((id) =>
        Widget.Box({
          children: [
            Widget.Button({
              vpack: "center",
              child: Widget.Icon(icons.brightness.indicator),
              on_clicked: () => brightness.toggleBrightness(id),
              tooltip_text: brightness
                .bind("monitors")
                .as(
                  (mon) =>
                    `Screen brightness: ${Math.floor(mon.get(id)!.percent! * 100)}%`,
                ),
            }),
            BrightnessSlider(id),
          ],
        }),
      )),
  })
