import icons from "lib/icons"
import PanelWidget from "../PanelWidget"
import options from "options"

const audio = await Service.import("audio")
const { blacklist } = options.microphone

export default () =>
  PanelWidget({
    window_class: "microphone-indicator",
    visible: audio
      .bind("recorders")
      .as(
        (rs) =>
          rs.filter((r) => !blacklist.value.includes(r["application-id"]))
            .length > 0,
      ),
    child: Widget.Icon(icons.audio.microphone.high),
  })
