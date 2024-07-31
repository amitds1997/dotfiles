import Gdk from "gi://Gdk?version=3.0"
import options from "options"
import { openMenu } from "./utils"

const { icon: launcherIcon } = options.car.launcher

export const Menu = () => {
  return {
    component: Widget.Box({
      child: Widget.Label({
        class_name: "bar-menu_label",
        label: launcherIcon.bind("value"),
      }),
    }),
    isVisible: true,
    boxClass: "dashboard",
    props: {
      on_primary_click: (clicked: any, event: Gdk.Event) => {
        openMenu(clicked, event, "dashboardmenu")
      },
    },
  }
}
