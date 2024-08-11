import { WindowNames } from "./Bar"
import { NotificationReveal as Notification } from "./Notification"
const notifications = await Service.import("notifications")

const Popups = () =>
  Widget.Box({
    vertical: true,
    hexpand: true,
    hpack: "end",
    attribute: {
      map: new Map(),
      dismiss: (box: any, id: number) => {
        if (!box.attribute.map.has(id)) {
          return
        }
        const notif = box.attribute.map.get(id)
        notif.attribute.count--
        if (notif.attribute.count <= 0) {
          box.attribute.map.delete(id)
          notif.attribute.destroyWithAnims()
        }
      },
      notify: (box: any, id: number) => {
        const notif = notifications.getNotification(id)
        if (notifications.dnd || !notif) {
          return
        }
        const replace = box.attribute.map.get(id)
        if (!replace) {
          const notification = Notification(notif)
          box.attribute.map.set(id, notification)
          notification.attribute.count = 1
          box.pack_start(notification, false, false, 0)
        } else {
          const notification = Notification(notif, true)
          notification.attribute.count = replace.attribute.count + 1
          box.remove(replace)
          replace.destroy()
          box.pack_start(notification, false, false, 0)
          box.attribute.map.set(id, notification)
        }
      },
    },
  })
    .hook(
      notifications,
      (box: any, id: number) => box.attribute.notify(box, id),
      "notified",
    )
    .hook(
      notifications,
      (box: any, id: number) => box.attribute.dismiss(box, id),
      "dismissed",
    )
    .hook(
      notifications,
      (box: any, id: number) => box.attribute.dismiss(box, id),
      "closed",
    )

const PopupList = () =>
  Widget.Box({
    class_name: "notifications-popup-list",
    css: "padding: 1px 0px 1px 1px",
    children: [Popups()],
  })

export const PopupNotifications = () =>
  Widget.Window({
    layer: "overlay",
    name: WindowNames.PopupNotifications,
    anchor: ["top", "right"],
    child: PopupList(),
    visible: false,
  }).hook(
    notifications,
    () => {
      if (notifications.popups.length > 0) {
        App.openWindow(WindowNames.PopupNotifications)
      } else {
        App.closeWindow(WindowNames.PopupNotifications)
      }
    },
    "notify::popups",
  )
