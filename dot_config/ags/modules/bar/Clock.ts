import { clock } from "lib/variables"

export const Clock = () =>
  Widget.EventBox({
    child: Widget.Box({
      class_name: "clock-container",
      vertical: true,
      children: [
        Widget.Label({
          class_name: "clock-date",
          hpack: "end",
          label: clock
            .bind("value")
            .as((c) => c.format("%a %d-%m-%Y") || "No date"),
        }),
        Widget.Label({
          class_name: "clock-time",
          hpack: "end",
          label: clock
            .bind("value")
            .as((c) => c.format("%H:%M:%S") || "No time"),
        }),
      ],
    }),
  })
