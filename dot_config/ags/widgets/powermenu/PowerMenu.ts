import Gtk from "gi://Gtk?version=3.0"
import icons from "lib/icons"
import options from "options"
import powermenu, { type Action } from "services/powermenu"
import PopupWindow, { PopupNames } from "widgets/PopupWindow"

const { layout, labels } = options.powermenu

const SysButton = (action: Action, label: string) =>
  Widget.Button({
    on_clicked: () => powermenu.action(action),
    child: Widget.Box({
      vertical: true,
      class_name: "system-button",
      children: [
        Widget.Icon(icons.powermenu[action]),
        Widget.Label({
          label,
          visible: labels.bind(),
        }),
      ],
    }),
  })

export default () =>
  PopupWindow({
    name: PopupNames.PowerMenu,
    transition: "crossfade",
    child: Widget.Box<Gtk.Widget>({
      class_name: "powermenu horizontal",
      setup: (self) =>
        self.hook(layout, () => {
          self.toggleClassName("box", layout.value === "box")
          self.toggleClassName("line", layout.value === "line")
        }),
      children: layout.bind().as((layout) => {
        switch (layout) {
          case "line":
            return [
              SysButton("lock", "Lock"),
              SysButton("logout", "Log out"),
              SysButton("suspend", "Suspend"),
              SysButton("hibernate", "Hibernate"),
              SysButton("shutdown", "Shut down"),
              SysButton("reboot", "Reboot"),
            ]
          case "box":
            return [
              Widget.Box(
                { vertical: true },
                SysButton("lock", "Lock"),
                SysButton("logout", "Log out"),
                SysButton("suspend", "Suspend"),
              ),
              Widget.Box(
                { vertical: true },
                SysButton("hibernate", "Hibernate"),
                SysButton("shutdown", "Shut down"),
                SysButton("reboot", "Reboot"),
              ),
            ]
        }
      }),
    }),
  })
