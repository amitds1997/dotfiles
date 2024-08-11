import { NotificationReveal as Notification } from "modules/Notification"
const notifs = await Service.import("notifications")

export const NotificationList = () =>
  Widget.Box({
    vertical: true,
    hpack: "end",
    setup: (box) => {
      Utils.timeout(1000, () => {
        notifs.notifications.forEach((notif) => {
          box.attribute.onAdded(box, notif.id)
        })
      })
    },
    attribute: {
      notifications: new Map(),
      onAdded: (box: any, id: number) => {
        const notif = notifs.getNotification(id)
        if (!notif) {
          return
        }
        const replace = box.attribute.notifications.get(id)
        if (replace) {
          replace.destroy()
        }
        const notification = Notification(notif, !!replace)
        box.attribute.notifications.set(id, notification)
        box.pack_start(notification, false, false, 0)
      },
      onRemoved: (box: any, id: number) => {
        if (!box.attribute.notifications.has(id)) {
          return
        }
        box.attribute.notifications.get(id).attribute.destroyWithAnims()
        box.attribute.notifications.delete(id)
      },
    },
  })
    .hook(notifs, (box, id) => box.attribute.onAdded(box, id), "notified")
    .hook(notifs, (box, id) => box.attribute.onRemoved(box, id), "closed")
