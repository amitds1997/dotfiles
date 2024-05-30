import icons from "lib/icons"
import screenrecorder from "services/screenrecord"
import { ToggleButton } from "./ToggleButton"
import { PopupNames } from "widgets/PopupWindow"

export const ScreenRecorder = () =>
  ToggleButton({
    toggle_action: () => {
      App.closeWindow(PopupNames.Preferences)
      if (screenrecorder.recording) screenrecorder.stop()
      else screenrecorder.start()
    },
    icon: screenrecorder
      .bind("recording")
      .as((is_recording) =>
        is_recording ? icons.recorder.stop : icons.recorder.recording,
      ),
    connection: [screenrecorder, () => screenrecorder.recording],
  })

export const Screenshoter = () =>
  Widget.Button({
    on_clicked: () => screenrecorder.screenshot(),
    child: Widget.Icon({
      icon: icons.screenshot,
    }),
  })
