import { icons } from "lib/icons"

const notifications = await Service.import("notifications")

export const NotificationIndicator = () => {
  return Widget.Box({
    class_name: "notification-indicator-container",
    child: Widget.Icon({
      setup: (self) => {
        Utils.merge(
          [notifications.bind("notifications"), notifications.bind("dnd")],
          (notifs, isDND) => {
            if (notifs.length <= 0 && !isDND) {
              self.visible = false
              return
            }
            self.visible = true
            if (isDND) {
              self.icon = icons.notifications.silent
            } else if (notifs.length > 0) {
              self.icon = icons.notifications.chat
            }
          },
        )
      },
    }),
  })
}
