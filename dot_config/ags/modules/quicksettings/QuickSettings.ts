import Gtk from "gi://Gtk?version=3.0"
import { icons } from "lib/icons"
import { QSMenu } from "./Menu"
import { NotificationList } from "./Notifications"

const notifications = await Service.import("notifications")

const QuickSettingsPage = (content: Gtk.Widget) =>
  Widget.Scrollable({
    class_name: "qs-page",
    vexpand: true,
    hexpand: true,
    hscroll: "never",
    child: content,
  })

const QSNotification = () =>
  QuickSettingsPage(
    QSMenu({
      title: "Notifications",
      icon: icons.notifications.chat,
      content: NotificationList(),
      headerChild: Widget.Box({
        class_name: "spacing-5",
        children: [
          Widget.Button({
            on_clicked: () => notifications.clear(),
            child: Widget.Box({
              children: [
                Widget.Label("Clear all"),
                Widget.Icon(icons.trash.empty),
              ],
            }),
            visible: notifications
              .bind("notifications")
              .as((n) => n.length > 0),
          }),
          Widget.Switch({})
            .hook(notifications, (sw) => {
              if (sw.active === notifications.dnd) {
                sw.active = !notifications.dnd
              }
            })
            .on("notify::active", ({ active }) => {
              if (active === notifications.dnd) {
                notifications.dnd = !active
              }
            }),
        ],
      }),
    }),
  )

export const QuickSettings = () => {
  return {
    Notifications: QSNotification(),
  }
}
