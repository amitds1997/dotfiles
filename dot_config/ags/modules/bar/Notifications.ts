import { icons } from "lib/icons"

const notifications = await Service.import("notifications")

const NotificationsIndicator = () =>
  Widget.Icon({
    icon: icons.notifications.noisy,
    class_name: "notification-indicator",
  })

const DNDIndicator = () =>
  Widget.Icon({
    icon: icons.notifications.silent,
    class_name: "notification-indicator",
  })

export const NotificationIndicator = () => {
  const n = NotificationsIndicator()
  const d = DNDIndicator()

  return Widget.Box({
    class_name: "notification-indicator-container",
    children: Utils.merge(
      [notifications.bind("notifications"), notifications.bind("dnd")],
      (notifs, isDND) => {
        if (isDND) {
          return [d]
        } else if (notifs.length > 0) {
          return [n]
        }
        return []
      },
    ),
  })
}
