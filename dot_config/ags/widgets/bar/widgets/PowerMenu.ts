import options from "options"
import PanelWidget from "../PanelWidget"
import icons from "lib/icons"

const { action } = options.bar.powermenu

export default () =>
  PanelWidget({
    window_class: "powermenu",
    on_clicked: action.bind(),
    child: Widget.Icon(icons.powermenu.shutdown),
  })
