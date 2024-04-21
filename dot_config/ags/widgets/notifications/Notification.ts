import GLib from "gi://GLib?version=2.0"
import icons from "lib/icons"
import { get_icon } from "lib/utils"
import { type Notification } from "types/service/notifications"

const time = (time: number, format = "%H:%M") =>
  GLib.DateTime.new_from_unix_local(time).format(format)

const NotificationIcon = ({ app_entry, app_icon, image }: Notification) => {
  if (image) {
    return Widget.Box({
      vpack: "start",
      hexpand: false,
      class_name: "icon img",
      css: `
          background-image: url("${image}");
          background-size: cover;
          background-repeat: no-repeat;
          background-position: center;
          min-width: 78px;
          min-height: 78px;
      `,
    })
  }

  return Widget.Box({
    vpack: "start",
    hexpand: false,
    class_name: "icon",
    css: `
        min-height: 78px;
        min-width: 78px;
    `,
    child: Widget.Icon({
      icon: get_icon(
        app_icon,
        get_icon(app_entry || "", icons.fallback.notification),
      ),
      size: 58,
      hpack: "center",
      hexpand: true,
      vpack: "center",
      vexpand: true,
    }),
  })
}

export default (notification: Notification) => {
  const content = Widget.Box({
    class_name: "content",
    children: [
      NotificationIcon(notification),
      Widget.Box({
        hexpand: true,
        vexpand: true,
        vertical: true,
        children: [
          Widget.Box({
            children: [
              Widget.Label({
                class_name: "title",
                xalign: 0,
                justification: "left",
                hexpand: true,
                max_width_chars: 24,
                truncate: "end",
                wrap: true,
                label: notification.summary.trim(),
                use_markup: true,
              }),
              Widget.Label({
                class_name: "time",
                vpack: "start",
                label: time(notification.time),
              }),
              Widget.Button({
                class_name: "close-button",
                vpack: "start",
                child: Widget.Icon("window-close-symbolic"),
                on_clicked: notification.close,
              }),
            ],
          }),
          Widget.Label({
            class_name: "description",
            hexpand: true,
            use_markup: true,
            xalign: 0,
            justification: "left",
            label: notification.body.trim(),
            max_width_chars: 24,
            wrap: true,
          }),
        ],
      }),
    ],
  })

  const actionsBox =
    notification.actions.length > 0
      ? Widget.Revealer({
          transition: "slide_down",
          child: Widget.EventBox({
            child: Widget.Box({
              class_name: "actions horizontal",
              children: notification.actions.map((action) =>
                Widget.Button({
                  class_name: "actions-button",
                  on_clicked: () => notification.invoke(action.id),
                  hexpand: true,
                  child: Widget.Label(action.label),
                }),
              ),
            }),
          }),
        })
      : null

  const eventBox = Widget.EventBox({
    vexpand: false,
    on_primary_click: notification.dismiss,
    on_hover() {
      if (actionsBox) actionsBox.reveal_child = true
    },
    on_hover_lost() {
      if (actionsBox) actionsBox.reveal_child = false

      notification.dismiss()
    },
    child: Widget.Box({
      vertical: true,
      children: actionsBox ? [content, actionsBox] : [content],
    }),
  })

  return Widget.Box({
    class_name: `notification ${notification.urgency}`,
    child: eventBox,
  })
}
