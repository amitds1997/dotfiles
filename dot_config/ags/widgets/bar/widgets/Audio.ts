import { stream_icon } from "lib/icon_utils"
import { icon } from "lib/utils"
import PanelWidget from "../PanelWidget"
import icons from "lib/icons"

const audio = await Service.import("audio")

export default () =>
  PanelWidget({
    window_class: "audio",
    hexpand: false,
    child: Widget.Icon({
      icon: audio.speaker
        .bind("icon_name")
        .as((i) =>
          icon(i || "", stream_icon(audio.speaker, icons.audio.speaker)),
        ),
    }),
    on_clicked: () => App.toggleWindow("audio"),
  })
