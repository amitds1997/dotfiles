import icons from "./icons"
import { type Audio } from "types/service/audio"

export function audio_icon(audio: Audio, type: string) {
  const { muted, low, medium, high, overamplified } = icons.audio[type]
  const cons = [
    [101, overamplified],
    [67, high],
    [34, medium],
    [1, low],
    [0, muted],
  ] as const
  const icon = cons.find(([n]) => n <= audio[type].volume * 100)?.[1] || ""
  return audio[type].is_muted ? muted : icon
}
