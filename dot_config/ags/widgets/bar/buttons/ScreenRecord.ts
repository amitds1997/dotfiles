import icons from "lib/icons"
import PanelButton from "../PanelButton"
import screenrecorder from "services/screenrecord"
import { singleSpaceWidget } from "lib/utils"

export default () =>
  PanelButton({
    class_name: "recorder",
    on_clicked: () => screenrecorder.stop(),
    visible: screenrecorder.bind("recording"),
    child: Widget.Box({
      children: [
        Widget.Icon(icons.recorder.recording),
        singleSpaceWidget(),
        Widget.Label({
          label: screenrecorder.bind("timer").as((time) => {
            const sec = time % 60
            const min = Math.floor(time / 60)
            return `${min}:${sec < 10 ? "0" + sec : sec}`
          }),
        }),
      ],
    }),
  })
