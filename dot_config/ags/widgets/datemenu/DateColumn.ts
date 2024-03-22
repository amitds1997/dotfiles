import { clock } from "lib/variables"

export default () =>
  Widget.Box({
    vertical: true,
    class_name: "date-column vertical",
    children: [
      Widget.Box({
        class_name: "clock-box",
        vertical: true,
        children: [
          Widget.Label({
            class_name: "clock",
            label: clock.bind().as((t) => t.format("%H:%M")!),
          }),
        ],
      }),
      Widget.Box({
        class_name: "calendar",
        children: [
          Widget.Calendar({
            hexpand: true,
            hpack: "center",
          }),
        ],
      }),
    ],
  })
