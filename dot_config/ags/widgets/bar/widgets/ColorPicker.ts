import Gdk30 from "gi://Gdk?version=3.0"
import colorpicker from "services/colorpicker"
import PanelWidget from "../PanelWidget"

const css = (color: string) => `
* {
  background-color: ${color};
  color: transparent;
}
*:hover {
  color: white;
  text-shadow: 2px 2px 3px rgba(0,0,0,.8);
}
`

export default () => {
  const menu = Widget.Menu({
    class_name: "colorpicker",
    children: colorpicker.bind("colors").as((c) =>
      c.map((color) =>
        Widget.MenuItem({
          child: Widget.Label(color),
          css: css(color),
          on_activate: () => colorpicker.wlCopy(color),
        }),
      ),
    ),
  })

  return PanelWidget({
    class_name: "color-picker",
    child: Widget.Icon("color-select-symbolic"),
    tooltip_text: colorpicker.bind("colors").as((v) => `${v.length} colors`),
    on_clicked: colorpicker.pick,
    on_secondary_click: (self) => {
      if (colorpicker.colors.length === 0) {
        return
      }

      menu.popup_at_widget(self, Gdk30.Gravity.SOUTH, Gdk30.Gravity.NORTH, null)
    },
  })
}
