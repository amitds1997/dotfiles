import Gtk from "gi://Gtk?version=3.0"

export type RoundLocation =
  | "topleft"
  | "topright"
  | "bottomleft"
  | "bottomright"

export const RoundedCorner = (loc: RoundLocation, props: any) =>
  Widget.DrawingArea({
    ...props,
    hpack: loc.includes("left") ? "start" : "end",
    vpack: loc.includes("top") ? "start" : "end",
    setup: (widget) => {
      // Ensure a minimum size so that the window at least opens up
      const r = 2
      widget.set_size_request(r, r)
      widget.on("draw", (w, cr) => {
        const r = w
          .get_style_context()
          .get_property("font-size", Gtk.StateFlags.NORMAL)
        w.set_size_request(r, r)

        switch (loc) {
          case "topleft":
            cr.arc(r, r, r, Math.PI, (3 * Math.PI) / 2)
            cr.lineTo(0, 0)
            break
          case "topright":
            cr.arc(0, r, r, (3 * Math.PI) / 2, 2 * Math.PI)
            cr.lineTo(r, 0)
            break
          case "bottomleft":
            cr.arc(r, 0, r, Math.PI / 2, Math.PI)
            cr.lineTo(0, r)
            break
          case "bottomright":
            cr.arc(0, 0, r, 0, Math.PI / 2)
            cr.lineTo(r, r)
            break
        }

        cr.closePath()
        cr.clip()
        Gtk.render_background(w.get_style_context(), cr, 0, 0, r, r)
      })
    },
  })

export const RoundedAngleEnd = (place: RoundLocation | any, props: any) =>
  Widget.DrawingArea({
    ...props,
    setup: (widget) => {
      const ratio = 1.5
      const r = widget.get_allocated_height()
      widget.set_size_request(ratio * r, r)
      widget.on("draw", (w, cr) => {
        const ctx = w.get_style_context()
        const border_color = ctx.get_property("color", Gtk.StateFlags.NORMAL)
        const border_width = ctx.get_border(Gtk.StateFlags.NORMAL).bottom
        const r = w.get_allocated_height()
        w.set_size_request(ratio * r, r)
        switch (place) {
          case "topleft":
            cr.moveTo(0, 0)
            cr.curveTo((ratio * r) / 2, 0, (ratio * r) / 2, r, ratio * r, r)
            cr.lineTo(ratio * r, 0)
            cr.closePath()
            cr.clip()
            Gtk.render_background(ctx, cr, 0, 0, r * ratio, r)
            cr.moveTo(0, 0)
            cr.curveTo((ratio * r) / 2, 0, (ratio * r) / 2, r, ratio * r, r)
            cr.setLineWidth(border_width * 2)
            cr.setSourceRGBA(
              border_color.red,
              border_color.green,
              border_color.blue,
              border_color.alpha,
            )
            cr.stroke()
            break

          case "topright":
            cr.moveTo(ratio * r, 0)
            cr.curveTo((ratio * r) / 2, 0, (ratio * r) / 2, r, 0, r)
            cr.lineTo(0, 0)
            cr.closePath()
            cr.clip()
            Gtk.render_background(ctx, cr, 0, 0, r * ratio, r)
            cr.moveTo(ratio * r, 0)
            cr.curveTo((ratio * r) / 2, 0, (ratio * r) / 2, r, 0, r)
            cr.setLineWidth(border_width * 2)
            cr.setSourceRGBA(
              border_color.red,
              border_color.green,
              border_color.blue,
              border_color.alpha,
            )
            cr.stroke()
            break

          case "bottomleft":
            cr.moveTo(0, r)
            cr.curveTo((ratio * r) / 2, r, (ratio * r) / 2, 0, ratio * r, 0)
            cr.lineTo(ratio * r, r)
            cr.closePath()
            cr.clip()
            Gtk.render_background(ctx, cr, 0, 0, r * ratio, r)
            cr.moveTo(0, r)
            cr.curveTo((ratio * r) / 2, r, (ratio * r) / 2, 0, ratio * r, 0)
            cr.setLineWidth(border_width * 2)
            cr.setSourceRGBA(
              border_color.red,
              border_color.green,
              border_color.blue,
              border_color.alpha,
            )
            cr.stroke()
            break

          case "bottomright":
            cr.moveTo(ratio * r, r)
            cr.curveTo((ratio * r) / 2, r, (ratio * r) / 2, 0, 0, 0)
            cr.lineTo(0, r)
            cr.closePath()
            cr.clip()
            Gtk.render_background(ctx, cr, 0, 0, r * ratio, r)
            cr.moveTo(ratio * r, r)
            cr.curveTo((ratio * r) / 2, r, (ratio * r) / 2, 0, 0, 0)
            cr.setLineWidth(border_width * 2)
            cr.setSourceRGBA(
              border_color.red,
              border_color.green,
              border_color.blue,
              border_color.alpha,
            )
            cr.stroke()
            break
        }
      })
    },
  })

export const CornerTopLeft = (monitor: number) =>
  Widget.Window({
    monitor,
    name: `cornertl-${monitor}`,
    layer: "top",
    anchor: ["top", "left"],
    exclusivity: "normal",
    visible: true,
    child: RoundedCorner("topleft", { class_name: "corner" }),
  })

export const CornerTopRight = (monitor: number) =>
  Widget.Window({
    monitor,
    name: `cornertr-${monitor}`,
    layer: "top",
    anchor: ["top", "right"],
    exclusivity: "normal",
    visible: true,
    child: RoundedCorner("topright", { class_name: "corner" }),
  })

export const CornerBottomLeft = (monitor: number) =>
  Widget.Window({
    monitor,
    name: `cornerbl-${monitor}`,
    layer: "top",
    anchor: ["bottom", "left"],
    exclusivity: "normal",
    visible: true,
    child: RoundedCorner("bottomleft", { class_name: "corner" }),
  })

export const CornerBottomRight = (monitor: number) =>
  Widget.Window({
    monitor,
    name: `cornerbr-${monitor}`,
    layer: "top",
    anchor: ["bottom", "right"],
    exclusivity: "normal",
    visible: true,
    child: RoundedCorner("bottomright", { class_name: "corner" }),
  })
