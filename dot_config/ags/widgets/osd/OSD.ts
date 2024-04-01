import icons from "lib/icons"
import options from "options"
import Progress from "./Progress"
import { icon } from "lib/utils"

const DELAY = 2500
const audio = await Service.import("audio")
const { microphone, progress } = options.osd

function OnScreenProgress(vertical: boolean) {
  const indicator = Widget.Icon({
    size: 42,
    vpack: "start",
  })

  const progress = Progress({
    vertical,
    width: vertical ? 42 : 300,
    height: vertical ? 300 : 42,
    child: indicator,
  })

  const revealer = Widget.Revealer({
    transition: "slide_left",
    child: progress,
  })

  let count = 0
  function show(value: number, icon: string) {
    console.log("Received volume: ", value)
    revealer.reveal_child = true
    indicator.icon = icon
    progress.setValue(value)
    count++

    Utils.timeout(DELAY, () => {
      count--

      if (count == 0) revealer.reveal_child = false
    })
  }

  return revealer.hook(
    audio.speaker,
    () =>
      show(
        audio.speaker.volume,
        icon(audio.speaker.icon_name || "", icons.audio.type.speaker),
      ),
    "notify::volume",
  )
}

function MicrophoneMute() {
  const icon = Widget.Icon({
    class_name: "microphone",
  })

  const revealer = Widget.Revealer({
    transition: "slide_up",
    child: icon,
  })

  let count = 0
  console.log(audio.microphone)
  let mute = audio.microphone.stream?.is_muted ?? false

  return revealer.hook(audio.microphone, () =>
    Utils.idle(() => {
      if (mute != audio.microphone.stream?.is_muted) {
        mute = audio.microphone.stream!.is_muted
        icon.icon = icons.audio.microphone[mute ? "muted" : "high"]
        revealer.reveal_child = true
        count++

        Utils.timeout(DELAY, () => {
          count--
          if (count === 0) revealer.reveal_child = false
        })
      }
    }),
  )
}

export default (monitor: number) =>
  Widget.Window({
    monitor,
    name: `osd${monitor}`,
    class_name: "osd",
    layer: "overlay",
    click_through: true,
    anchor: ["right", "left", "top", "bottom"],
    child: Widget.Box({
      css: "padding: 2px;",
      expand: true,
      child: Widget.Overlay({
        child: Widget.Box({ expand: false }),
        overlays: [
          Widget.Box({
            hpack: progress.pack.h.bind(),
            vpack: progress.pack.v.bind(),
            child: progress.vertical.bind().as(OnScreenProgress),
          }),
          Widget.Box({
            hpack: microphone.pack.h.bind(),
            vpack: microphone.pack.v.bind(),
            child: MicrophoneMute(),
          }),
        ],
      }),
    }),
  })
