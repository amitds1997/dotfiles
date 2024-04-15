import { icon } from "lib/utils"
import PanelWidget from "../PanelWidget"
import icons from "lib/icons"

const network = await Service.import("network")

const WiFiWidget = () =>
  Widget.Icon({
    icon: network.wifi
      .bind("icon_name")
      .as((i) => icon(i, icons.fallback.network)),
  })

const WiredWidget = () =>
  Widget.Icon({
    icon: network.wired
      .bind("icon_name")
      .as((i) => icon(i, icons.fallback.network)),
  })

export default () =>
  PanelWidget({
    class_name: "network",
    child: network
      .bind("primary")
      .as((p) => (p === "wired" ? WiredWidget() : WiFiWidget())),
    on_clicked: () => App.toggleWindow("network"),
  })
