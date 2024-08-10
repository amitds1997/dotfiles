import { icons } from "lib/icons"

const notifs = await Service.import("notifications")

const NotificationsIndicator = () =>
  Widget.Icon({
    icon: icons.notifications.noisy,
    class_name: "notification-indicator",
    visible: notifs.bind("notifications").as((nots) => {
      return nots.length > 0
    }),
    setup: (self) => {
      self.visible = notifs.notifications.length > 0
    },
  })

const DNDIndicator = () =>
  Widget.Icon({
    icon: icons.notifications.silent,
    class_name: "notification-indicator",
    visible: notifs.bind("dnd"),
  })

export const NotificationIndicator = () =>
  Widget.Box({
    class_name: "notification-indicator-container",
    children: [NotificationsIndicator(), DNDIndicator()],
  })
