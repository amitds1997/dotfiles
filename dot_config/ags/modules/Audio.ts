import { getStreamIcon } from "lib/icons"

const audio = await Service.import("audio")

export const Audio = () =>
  Widget.EventBox({
    child: Widget.Box({
      class_name: "audio-container",
      children: [
        Widget.Icon({
          class_name: "audio-icon",
          icon: audio.speaker
            .bind("icon_name")
            .as(
              (i) =>
                getStreamIcon(audio.speaker, false) ||
                i ||
                "audio-speaker-symbolic",
            ),
        }),
        Widget.Label({
          class_name: "audio-label",
          label: audio.speaker
            .bind("volume")
            .as((v) => `${Math.floor(v * 100)}`),
        }),
      ],
    }),
  })
