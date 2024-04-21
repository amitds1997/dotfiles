import icons from "lib/icons"
import PanelWidget from "../PanelWidget"
import { PopupNames } from "widgets/PopupWindow"

export default () =>
  PanelWidget({
    window_class: "preferences",
    on_clicked: () => App.toggleWindow(PopupNames.Preferences),
    child: Widget.Icon(icons.preferences),
  })
