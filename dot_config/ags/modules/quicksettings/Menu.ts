export const QSMenu = ({ title, icon, content, headerChild = Widget.Box() }) =>
  Widget.Box({
    children: [
      Widget.Box({
        class_name: "qs-menu",
        vertical: true,
        children: [
          Widget.Box({
            class_name: "qs-title",
            children: [
              Widget.Icon(icon),
              Widget.Label(title),
              Widget.Box({ hexpand: true }),
              headerChild,
            ],
          }),
          Widget.Separator({}),
          Widget.Box({
            class_name: "qs-content",
            children: [content],
          }),
        ],
      }),
    ],
  })
