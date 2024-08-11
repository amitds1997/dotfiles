import GLib from "gi://GLib?version=2.0"
import Pango from "gi://Pango?version=1.0"
import { getIcon, icons } from "lib/icons"
import { Notification } from "types/service/notifications"

const NotificationIcon = (notification: Notification) => {
  if (notification.image) {
    return Widget.Box({
      vexpand: false,
      hexpand: false,
      vpack: "center",
      class_name: "notification-icon",
      css: `
      background-image: url('${notification.image}');
      background-size: auto 100%;
      background-repeat: no-repeat;
      background-position: center;
      `,
    })
  }
  const icon = getIcon(notification.app_icon, icons.notifications.chat)
  return Widget.Icon({
    class_name: "notification-icon",
    icon: icon,
  })
}

const Notif = (notif: Notification) =>
  Widget.Box({
    class_name: "notification",
    vertical: true,
    children: [
      Widget.EventBox({
        on_primary_click: (box) => {
          // @ts-expect-error This will always be there
          const label = box.child.children[1].children[1]
          if (label.lines < 0) {
            label.lines = 3
            label.truncate = "end"
          } else {
            label.lines = -1
            label.truncate = "none"
          }
        },
        child: Widget.Box({
          children: [
            NotificationIcon(notif),
            Widget.Box({
              vertical: true,
              children: [
                Widget.Box({
                  children: [
                    Widget.Label({
                      class_name: "notification-title",
                      label: notif.summary,
                      justification: "left",
                      max_width_chars: 24,
                      truncate: "end",
                      wrap: true,
                      xalign: 0,
                      hexpand: true,
                    }),
                    Widget.Label({
                      class_name: "notification-time",
                      label: GLib.DateTime.new_from_unix_local(
                        notif.time,
                      ).format("%H:%M"),
                    }),
                    Widget.Button({
                      class_name: "notification-close",
                      child: Widget.Icon(icons.notifications.close),
                      on_clicked: () => {
                        notif.close()
                      },
                    }),
                  ],
                }),
                Widget.Label({
                  class_name: "notification-body",
                  justification: "left",
                  max_width_chars: 24,
                  lines: 3,
                  truncate: "end",
                  wrap_mode: Pango.WrapMode.WORD_CHAR,
                  wrap: true,
                  xalign: 0,
                  label: notif.body.replace(/(\r\n|\n|\r)/gm, " "),
                }),
                notif.hints.value
                  ? Widget.ProgressBar({
                      class_name: "notification-progress",
                      value: Number(notif.hints.value.unpack()) / 100,
                    })
                  : Widget.Box(),
              ],
            }),
          ],
        }),
      }),
      Widget.Box({
        children: notif.actions.map((action) =>
          Widget.Button({
            child: Widget.Label(action.label),
            on_clicked: () => notif.invoke(action.id),
            class_name: "notification-action-button",
            hexpand: true,
          }),
        ),
      }),
    ],
  })

export const NotificationReveal = (
  notification: Notification,
  visible = false,
) => {
  const secondRevealer = Widget.Revealer({
    child: Notif(notification),
    reveal_child: visible,
    transition: "slide_left",
    transition_duration: 200,
    setup: (revealer) => {
      Utils.timeout(1, () => {
        revealer.reveal_child = true
      })
    },
  })

  const firstRevealer = Widget.Revealer({
    child: secondRevealer,
    reveal_child: true,
    transition: "slide_down",
    transition_duration: 200,
  })

  const box = Widget.Box({
    hexpand: true,
    hpack: "end",
    attribute: {
      destroyWithAnims: () => {},
      count: 0,
    },
    children: [firstRevealer],
  })
  box.attribute.destroyWithAnims = () => {
    secondRevealer.reveal_child = false
    Utils.timeout(200, () => {
      firstRevealer.reveal_child = false
      Utils.timeout(200, () => {
        box.destroy()
      })
    })
  }

  return box
}
