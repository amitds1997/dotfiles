import Gdk from "gi://Gdk?version=3.0"
import { clock } from "lib/variables"
import options from "options"
import { openMenu } from "./utils"

const { format } = options.car.clock
const time = Utils.derive([clock, format], (c, f) => c.format(f) || "")

export const Clock = () => {
  return {
    component: Widget.Label({
      class_name: "clock",
      label: time.bind(),
    }),
    isVisible: true,
    boxClass: "clock",
    props: {
      on_primary_click: (clicked: any, event: Gdk.Event) => {
        openMenu(clicked, event, "calendarmenu")
      },
    },
  }
}
