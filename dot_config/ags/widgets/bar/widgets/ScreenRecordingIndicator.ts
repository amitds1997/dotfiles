import icons from "lib/icons"
import PanelWidget from "../PanelWidget"
import screenrecorder from "services/screenrecord"

export default () =>
  PanelWidget({
    window_class: "screen-recorder",
    on_clicked: () => screenrecorder.stop(),
    visible: screenrecorder.bind("recording"),
    child: Widget.Box({
      children: [
        Widget.Icon(icons.recorder.recording),
        Widget.Label({
          hpack: "end",
          label: screenrecorder.bind("timer").as((time) => {
            const sec = time % 60
            const min = Math.floor(time / 60)
            return `${min}:${sec < 10 ? "0" + sec : sec}`
          }),
        }),
      ],
    }),
  })
