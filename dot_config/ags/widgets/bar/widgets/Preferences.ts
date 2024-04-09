import icons from "lib/icons"
import PanelWidget from "../PanelWidget"

export default () =>
  PanelWidget({
    window_class: "preferences",
    on_clicked: () => App.toggleWindow("preferences"),
    child: Widget.Icon(icons.preferences),
  })
