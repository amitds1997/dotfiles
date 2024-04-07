import icons from "lib/icons"
import { SimpleToggleButton } from "../ToggleButton"
import { audio_icon } from "lib/icon_utils"
import { icon } from "lib/utils"

const audio = await Service.import("audio")
const microphone = audio.microphone

const label = () => {
  const isMuted = microphone.is_muted || microphone.stream?.is_muted

  if (isMuted === undefined) {
    return "Not available"
  }

  return isMuted ? "Muted" : "Unmuted"
}

export const MicMute = () =>
  SimpleToggleButton({
    icon: microphone
      .bind("icon_name")
      .as((i) => icon(i || "", audio_icon(audio, "microphone"))),
    label: Utils.watch(label(), microphone, label),
    toggle: () => {
      microphone.is_muted = !microphone.is_muted
    },
    connection: [
      microphone,
      () => !(microphone.is_muted || microphone.stream?.is_muted || true),
    ],
  })
