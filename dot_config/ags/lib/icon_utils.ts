import icons from "./icons"
import { type Stream } from "types/service/audio"

type AudioIcon = typeof icons.audio.speaker

export function stream_icon(stream: Stream, audio_icon_group: AudioIcon) {
  const { muted, low, medium, high, overamplified } = audio_icon_group
  const cons = [
    [101, overamplified],
    [67, high],
    [34, medium],
    [1, low],
    [0, muted],
  ] as const
  const icon = cons.find(([n]) => n <= stream.volume * 100)?.[1] || ""
  return stream.is_muted ? muted : icon
}
