import Gtk from "gi://Gtk?version=3.0"
import { stream_icon } from "lib/icon_utils"
import icons from "lib/icons"
import { icon } from "lib/utils"
import options from "options"
import { Stream } from "types/service/audio"
import PopupWindow from "widgets/PopupWindow"

const { bar, preferences } = options
const layout = Utils.derive(
  [bar.position, preferences.position],
  (bar, p) => `${bar}-${p}` as const,
)
const audio = await Service.import("audio")

type AudioSourceSinkType = "microphones" | "speakers"
type AudioArrType = AudioSourceSinkType | "apps"
type AudioItemsType = {
  name: string
  item_creator_icon: string
  class_name: string
  bind_item: AudioArrType
}
type AudioIcon = typeof icons.audio.microphone

const StreamVolumeIcon = (stream: Stream, fallback_icon: AudioIcon) =>
  Widget.Button({
    on_clicked: () => {
      stream.is_muted = !stream.is_muted
    },
    child: Widget.Icon({
      tooltipText: stream
        .bind("is_muted")
        .as((is_muted) => (is_muted ? "Unmute audio" : "Mute audio")),
      setup: (self) => {
        self.hook(
          stream,
          (self) => {
            self.icon = icon(
              stream.icon_name || "",
              stream_icon(stream, fallback_icon),
            )
          },
          "changed",
        )
      },
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

const StreamVolume = (stream: Stream, fallback_icon: AudioIcon) =>
  Widget.Box({
    hexpand: true,
    vertical: false,
    class_name: "volume",
    children: [
      StreamVolumeIcon(stream, fallback_icon),
      StreamVolumeSlider(stream),
      StreamVolumeLabel(stream),
    ],
  })

const SelectorItem = (stream: Stream, bind_item_type: AudioSourceSinkType) => {
  const audio_type = bind_item_type === "speakers" ? "speaker" : "microphone"

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
              Widget.Label({
                hpack: "start",
                xalign: 0,
                truncate: "end",
                max_width_chars: 28,
                label: stream
                  .bind("description")
                  .as((d) => d || "No description"),
              }),
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
            children: [
              Widget.Slider({
                hexpand: true,
                draw_value: false,
                value: stream.bind("volume"),
                on_change: ({ value }) => (stream.volume = value),
              }),
              Widget.Label({
                hpack: "end",
                label: stream
                  .bind("volume")
                  .as((vol) => `${Math.floor(vol * 100)}%`),
              }),
            ],
          }),
        ],
      }),
    ],
  })
}

const MixerItem = (stream: Stream, bind_item_type: AudioArrType) => {
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
            children: [
              Widget.Label({
                hexpand: true,
                hpack: "start",
                xalign: 0,
                truncate: "end",
                label: stream
                  .bind("description")
                  .as((d) => d || "No description"),
              }),
              Widget.Label({
                hpack: "end",
                label: stream
                  .bind("volume")
                  .as((vol) => `${Math.floor(vol * 100)}%`),
              }),
            ],
          }),
          Widget.Slider({
            hexpand: true,
            draw_value: false,
            value: stream.bind("volume"),
            on_change: ({ value }) => (stream.volume = value),
          }),
        ],
      }),
    ],
  })
}

type HandlerProps = {
  name: string
  icon_name: string
  class_name: string
  content: Gtk.Widget[]
}

const Handler = ({ name, icon_name, class_name, content }: HandlerProps) => {
  const opened = Variable(false)

  const arrow_icon = Widget.Icon({
    icon: icons.ui.arrow.right,
  })

  return Widget.Box({
    class_names: ["handler-menu", class_name],
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
          class_names: ["handler-menu", name],
          vertical: true,
          children: content,
        }),
      }),
    ],
  })
}
const ItemCreator = ({
  name,
  item_creator_icon,
  class_name,
  bind_item,
}: AudioItemsType) => {
  return Handler({
    name: name,
    icon_name: item_creator_icon,
    class_name: class_name,
    content: [
      Widget.Separator({
        visible: audio.bind(bind_item).as((p) => p.length > 0),
      }),
      Widget.Box({
        vertical: true,
        class_name: "content vertical",
        children: audio.bind(bind_item).as((p) => {
          return p.map((mi) => {
            if (bind_item === "apps") {
              return MixerItem(mi, bind_item)
            } else {
              return SelectorItem(mi, bind_item)
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
      ItemCreator({
        name: "App mixer",
        item_creator_icon: icons.audio.mixer,
        class_name: "app-mixer",
        bind_item: "apps",
      }),
      ItemCreator({
        name: "Sink selector",
        item_creator_icon: icons.audio.mixer,
        class_name: "sink-selector",
        bind_item: "speakers",
      }),
      ItemCreator({
        name: "Source selector",
        item_creator_icon: icons.audio.mixer,
        class_name: "source-selector",
        bind_item: "microphones",
      }),
    ],
  })

export default () =>
  PopupWindow({
    name: "audio",
    exclusivity: "exclusive",
    transition: bar.position
      .bind()
      .as((p) => (p === "top" ? "slide_down" : "slide_up")),
    layout: layout.value,
    child: AudioBox(),
  })
