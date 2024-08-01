import powermenu, { Action } from "services/powermenu"
import { PopupNames, PopupWindow } from "../PopupWindow"
import icons from "lib/icons"

const SysButton = (action: Action, label: string) =>
  Widget.Button({
    class_name: `widget-button powermenu-button-${action}`,
    on_clicked: () => powermenu.action(action),
    child: Widget.Box({
      vertical: true,
      class_name: "system-button widget-box",
      children: [
        Widget.Icon({
          class_name: `system-button_icon ${action}`,
          icon: icons.powermenu[action],
        }),
        Widget.Label({
          class_name: `system-button_label ${action}`,
          label,
        }),
      ],
    }),
  })

export const PowerMenu = () =>
  PopupWindow({
    name: PopupNames.PowerMenu,
    transition: "crossfade",
    child: Widget.Box({
      class_name: "powermenu horizontal",
      children: [
        SysButton("lock", "Lock"),
        SysButton("logout", "Log out"),
        SysButton("suspend", "Suspend"),
        SysButton("hibernate", "Hibernate"),
        SysButton("shutdown", "Shut down"),
        SysButton("reboot", "Reboot"),
      ],
    }),
  })
