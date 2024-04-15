import Gtk from "types/@girs/gtk-3.0/gtk-3.0"
import { IconProps } from "types/widgets/icon"
import { LabelProps } from "types/widgets/label"
import { opened } from "widgets/quicksettings/ToggleButton"

type MenuProps = {
  name: string
  icon: IconProps["icon"]
  title: LabelProps["label"]
  content: Gtk.Widget[]
}
export const Menu = ({ name, icon, title, content }: MenuProps) =>
  Widget.Revealer({
    transition: "slide_down",
    reveal_child: opened.bind().as((v) => v === name),
    child: Widget.Box({
      class_names: ["menu", name],
      vertical: true,
      children: [
        Widget.Box({
          class_name: "title-box",
          children: [
            Widget.Icon({
              class_name: "icon",
              icon,
            }),
            Widget.Label({
              class_name: "title",
              truncate: "end",
              label: title,
            }),
          ],
        }),
        Widget.Separator(),
        Widget.Box({
          vertical: true,
          class_name: "content vertical",
          children: content,
        }),
      ],
    }),
  })
