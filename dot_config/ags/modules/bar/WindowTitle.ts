const hyprland = await Service.import("hyprland")

export const WindowTitle = () =>
  Widget.EventBox({
    class_name: "title-container",
    child: Widget.Box({
      vertical: true,
      class_name: "title-box",
      children: [
        Widget.Label({
          hpack: "end",
          class_name: "title-class",
          truncate: "end",
          max_width_chars: 22,
          label: hyprland.active.client
            .bind("class")
            .transform((cls) => (cls.length === 0 ? "Desktop" : cls)),
        }),
        Widget.Label({
          hpack: "end",
          class_name: "title-title",
          truncate: "end",
          max_width_chars: 22,
          label: hyprland.active.client
            .bind("title")
            .transform((title) => (title.length === 0 ? "Desktop" : title)),
        }),
      ],
    }),
  })
