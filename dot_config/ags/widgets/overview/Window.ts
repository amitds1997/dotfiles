import Gdk from "gi://Gdk"
import Gtk from "gi://Gtk?version=3.0"
import icons from "lib/icons"
import { createSurfaceFromWidget, get_icon } from "lib/utils"
import options from "options"
import { type Client } from "types/service/hyprland"
import { PopupNames } from "widgets/PopupWindow"

const apps = await Service.import("applications")
const hyprland = await Service.import("hyprland")
const dispatch = (args: string) => hyprland.messageAsync(`dispatch ${args}`)

export default ({ address, size: [w, h], class: c, title }: Client) =>
  Widget.Button({
    class_name: "client",
    attribute: { address },
    tooltip_text: `${title}`,
    child: Widget.Icon({
      css: options.overview.scale.bind().as(
        (v) => `
          min-width: ${(v / 100) * w}px;
          min-height: ${(v / 100) * h}px;
          `,
      ),
      icon: get_icon(
        apps.list.find((app) => app.match(c))?.icon_name + "-symbolic",
        icons.fallback.executable,
      ),
    }),
    on_secondary_click: () => dispatch(`closewindow address:${address}`),
    on_clicked: () => {
      dispatch(`focuswindow address:${address}`)
      App.closeWindow(PopupNames.Overview)
    },
    setup: (btn) =>
      btn
        .on("drag-data-get", (_w, _c, data) =>
          data.set_text(address, address.length),
        )
        .on("drag-begin", (_, context) => {
          Gtk.drag_set_icon_surface(context, createSurfaceFromWidget(btn))
          btn.toggleClassName("hidden", true)
        })
        .on("drag-end", () => btn.toggleClassName("hidden", false))
        .drag_source_set(
          Gdk.ModifierType.BUTTON1_MASK,
          [Gtk.TargetEntry.new("text/plain", Gtk.TargetFlags.SAME_APP, 0)],
          Gdk.DragAction.COPY,
        ),
  })
