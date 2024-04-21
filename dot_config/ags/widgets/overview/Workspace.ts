import Gdk from "gi://Gdk"
import Gtk from "gi://Gtk?version=3.0"
import options from "options"
import Window from "./Window"
import { PopupNames } from "widgets/PopupWindow"

const hyprland = await Service.import("hyprland")

const scale = (size: number) => (options.overview.scale.value / 100) * size
const dispatch = (args: string) => hyprland.messageAsync(`dispatch ${args}`)
const getWorkspaceDimensions = (workspaceID: number) => {
  const default_dimensions = { h: 1080, w: 1920 }
  const ws = hyprland.getWorkspace(workspaceID)
  if (!ws) return default_dimensions

  const monitor = hyprland.getMonitor(ws.monitorID)
  return monitor ? { h: monitor.height, w: monitor.width } : default_dimensions
}

export default (id: number) => {
  const fixed = Widget.Fixed()

  function update() {
    fixed.get_children().forEach((ch) => ch.destroy())

    hyprland.clients
      .filter(({ workspace }) => workspace.id === id)
      .forEach((c) => {
        const x = c.at[0] - (hyprland.getMonitor(c.monitor)?.x || 0)
        const y = c.at[1] - (hyprland.getMonitor(c.monitor)?.y || 0)
        c.mapped && fixed.put(Window(c), scale(x), scale(y))
      })

    fixed.show_all()
  }

  return Widget.Box({
    attribute: { id },
    tooltip_text: `${id}`,
    class_name: "workspace",
    vpack: "center",
    css: options.overview.scale.bind().as(
      (v) => `
        min-width: ${(v / 100) * getWorkspaceDimensions(id).w}px;
        min-height: ${(v / 100) * getWorkspaceDimensions(id).h}px;
        `,
    ),
    setup: (box) =>
      box
        .hook(hyprland, () => {
          box.toggleClassName("active", hyprland.active.workspace.id === id)
          update()
        })
        .hook(options.overview.scale, update, "notify::clients"),
    child: Widget.EventBox({
      expand: true,
      on_primary_click: () => {
        App.closeWindow(PopupNames.Overview)
        dispatch(`workspace ${id}`)
      },
      setup: (eventBox) => {
        eventBox.drag_dest_set(
          Gtk.DestDefaults.ALL,
          [Gtk.TargetEntry.new("text/plain", Gtk.TargetFlags.SAME_APP, 0)],
          Gdk.DragAction.COPY,
        )
        eventBox.connect("drag-data-received", (_w, _c, _x, _y, data) => {
          const address = new TextDecoder().decode(data.get_data())
          dispatch(`movetoworkspacesilent ${id},address:${address}`)
        })
      },
      child: fixed,
    }),
  })
}
