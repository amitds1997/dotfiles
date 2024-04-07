import {
  VolumeIndicator,
  VolumeSlider,
} from "widgets/quicksettings/widgets/Volume"
import PopupWindow from "widgets/window/PopupWindow"

// const DELAY = 2500
const audio = await Service.import("audio")

const VolumeOSD = () => {
  // const revealer = Widget.Revealer({
  //   transition: "slide_up",
  // })
  // let count = 0

  // revealer.hook(
  //   audio.speaker,
  //   () => {
  //     revealer.reveal_child = true
  //     Utils.timeout(DELAY, () => {
  //       count--

  //       if (count == 0) revealer.reveal_child = false
  //     })
  //   },
  //   "notify::volume",
  // )

  return PopupWindow({
    name: "volume-osd",
    layout: "top",
    transition: "crossfade",
    exclusivity: "exclusive",
    child: Widget.Box({
      children: [VolumeIndicator("speaker"), VolumeSlider("speaker")],
    }),
  })
}

export default () => {
  // audio.connect("speaker-changed", VolumeOSD)
}
