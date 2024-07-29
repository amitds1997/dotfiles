import Gtk from "gi://Gtk?version=3.0"
import icons from "lib/icons"
import { get_icon, get_stream_icon } from "lib/utils"
import options from "options"
import { Stream } from "types/service/audio"
import { setUpBarWindow } from "widgets/BarWindow"
import { PopupNames } from "widgets/PopupWindow"

const { preferences } = options
const audio = await Service.import("audio")

type SourceSinkType = "microphones" | "speakers"
type MixerType = SourceSinkType | "apps"
type MixerItemType = {
  name: string
  icon: string
  class_name: string
  mixer_type: MixerType
}
type MixerIconType = typeof icons.audio.microphone

const StreamVolumeIcon = (stream: Stream, fallback_icon: MixerIconType) =>
  Widget.Button({
    on_clicked: () => {
      stream.is_muted = !stream.is_muted
    },
    tooltipText: stream
      .bind("is_muted")
      .as((is_muted) => (is_muted ? "Unmute audio" : "Mute audio")),
    child: Widget.Icon().hook(stream, (self) => {
      self.icon = get_icon(
        stream.icon_name || "",
        get_stream_icon(stream, fallback_icon),
      )
    }),
  })

const StreamVolumeSlider = (stream: Stream) =>
  Widget.Slider({
    hexpand: true,
    draw_value: false,
    on_change: ({ value, dragging }) => dragging && (stream.volume = value),
    value: stream.bind("volume"),
  })

const StreamVolumeLabel = (stream: Stream) =>
  Widget.Label({
    hpack: "end",
    label: stream.bind("volume").as((vol) => `${Math.floor(vol * 100)}%`),
  })

const StreamDescription = (stream: Stream) =>
  Widget.Label({
    hpack: "start",
    xalign: 0,
    truncate: "end",
    label: stream.bind("description").as((d) => d || "No description"),
  })

const StreamVolume = (stream: Stream, fallback_icon: MixerIconType) =>
  Widget.Box({
    hexpand: true,
    vertical: false,
    class_name: "stream-volume",
    children: [
      StreamVolumeIcon(stream, fallback_icon),
      StreamVolumeSlider(stream),
      StreamVolumeLabel(stream),
    ],
  })

const SourceSinkSelectorItem = (
  stream: Stream,
  selector_type: SourceSinkType,
) => {
  const audio_type = selector_type === "speakers" ? "speaker" : "microphone"

  return Widget.Box({
    hexpand: true,
    children: [
      StreamVolumeIcon(stream, icons.audio[audio_type]),
      Widget.Box({
        hexpand: true,
        vertical: true,
        children: [
          Widget.Box({
            hexpand: true,
            children: [
              StreamDescription(stream),
              Widget.ToggleButton({
                hexpand: true,
                hpack: "end",
                child: Widget.Icon({
                  icon: icons.ui.tick,
                }),
                setup: (self) => {
                  self.hook(
                    audio,
                    (self) => {
                      self.active = audio[audio_type].id === stream.id
                    },
                    `${audio_type}-changed`,
                  )
                },
                on_toggled: (self) => {
                  if (self.active) {
                    audio[audio_type] = stream
                  }
                },
              }),
            ],
          }),
          Widget.Box({
            hexpand: true,
            children: [StreamVolumeSlider(stream), StreamVolumeLabel(stream)],
          }),
        ],
      }),
    ],
  })
}

const AppMixerItem = (stream: Stream) => {
  return Widget.Box({
    hexpand: true,
    children: [
      StreamVolumeIcon(stream, icons.audio.speaker),
      Widget.Box({
        hexpand: true,
        vertical: true,
        children: [
          Widget.Box({
            hexpand: true,
            children: [StreamDescription(stream), StreamVolumeLabel(stream)],
          }),
          StreamVolumeSlider(stream),
        ],
      }),
    ],
  })
}

type AudioSelectorProps = {
  name: string
  icon_name: string
  class_name: string
  content: Gtk.Widget[]
}

const AudioSelector = ({
  name,
  icon_name,
  class_name,
  content,
}: AudioSelectorProps) => {
  const opened = Variable(false)

  const arrow_icon = Widget.Icon({
    icon: icons.ui.arrow.right,
  })

  return Widget.Box({
    class_names: ["audio-selector", class_name],
    vertical: true,
    children: [
      Widget.Box({
        vertical: false,
        child: Widget.Button({
          on_clicked: () => {
            opened.setValue(!opened.value)

            let deg = opened.value ? 0 : 90
            const step = opened.value ? 10 : -10
            for (let i = 0; i < 9; ++i) {
              Utils.timeout(15 * i, () => {
                deg += step
                arrow_icon.setCss(`-gtk-icon-transform: rotate(${deg}deg);`)
              })
            }
          },
          child: Widget.Box({
            children: [
              Widget.Icon({
                icon: icon_name,
              }),
              Widget.Label({
                truncate: "end",
                hexpand: true,
                label: name,
              }),
              arrow_icon,
            ],
          }),
        }),
      }),
      Widget.Revealer({
        transition: "slide_down",
        reveal_child: opened.bind().as((v) => v),
        child: Widget.Box({
          class_names: ["audio-selector-menu", name],
          vertical: true,
          children: content,
        }),
      }),
    ],
  })
}
const AudioMixerItem = ({
  name,
  icon,
  class_name,
  mixer_type,
}: MixerItemType) => {
  return AudioSelector({
    name: name,
    icon_name: icon,
    class_name: class_name,
    content: [
      Widget.Separator({
        visible: audio.bind(mixer_type).as((p) => p.length > 0),
      }),
      Widget.Box({
        vertical: true,
        class_name: "content vertical",
        children: audio.bind(mixer_type).as((p) => {
          return p.map((mi) => {
            if (mixer_type === "apps") {
              return AppMixerItem(mi)
            } else {
              return SourceSinkSelectorItem(mi, mixer_type)
            }
          })
        }),
      }),
    ],
  })
}

const AudioBox = () =>
  Widget.Box({
    vertical: true,
    hexpand: true,
    class_name: "audio-preferences vertical",
    css: preferences.width.bind().as((w) => `min-width: ${w}px;`),
    children: [
      StreamVolume(audio.speaker, icons.audio.speaker),
      StreamVolume(audio.microphone, icons.audio.microphone),
      AudioMixerItem({
        name: "App mixer",
        icon: icons.audio.mixer,
        class_name: "app-mixer",
        mixer_type: "apps",
      }),
      AudioMixerItem({
        name: "Sink selector",
        icon: icons.audio.mixer,
        class_name: "sink-selector",
        mixer_type: "speakers",
      }),
      AudioMixerItem({
        name: "Source selector",
        icon: icons.audio.mixer,
        class_name: "source-selector",
        mixer_type: "microphones",
      }),
    ],
  })

export function setUpAudioMenu() {
  setUpBarWindow({
    name: PopupNames.Audio,
    child: AudioBox(),
  })
}
