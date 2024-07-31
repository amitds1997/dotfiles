import Gdk from "gi://Gdk?version=3.0"
import options from "options"
import { openMenu } from "./utils"

const audio = await Service.import("audio")

const { show_label: showLabel } = options.car.volume

export const Volume = () => {
  const icons = {
    101: "󰕾",
    66: "󰕾",
    34: "󰖀",
    1: "󰕿",
    0: "󰝟",
  }

  const getIcon = () => {
    const icon = Utils.merge(
      [audio.speaker.bind("is_muted"), audio.speaker.bind("volume")],
      (isMuted, vol) => {
        return isMuted
          ? 0
          : [101, 66, 34, 1, 0].find((threshold) => threshold <= vol * 100)
      },
    )

    return icon.as((i) => (i !== undefined ? icons[i] : icons[101]))
  }

  const volIcon = Widget.Label({
    vpack: "center",
    label: getIcon(),
    class_name: "bar-button-icon volume",
  })

  const volPct = Widget.Label({
    vpack: "center",
    label: audio.speaker.bind("volume").as((v) => `${Math.floor(v * 100)}%`),
    class_name: "bar-button-label volume",
  })

  return {
    component: Widget.Box({
      vpack: "center",
      class_name: "volume",
      children: showLabel.bind("value").as((s) => {
        return s ? [volIcon, volPct] : [volIcon]
      }),
    }),
    isVisible: true,
    boxClass: "volume",
    props: {
      on_primary_click: (clicked: any, event: Gdk.Event) => {
        openMenu(clicked, event, "audiomenu")
      },
    },
  }
}
