import { icons } from "lib/icons"
import { RoundedAngleEnd } from "./RoundedCorner"
import options from "options"

const { position } = options.bar
const mpris = await Service.import("mpris")

const MusicContainer = () =>
  Widget.EventBox({
    on_primary_click: () => {
      const player = mpris.getPlayer()
      if (!player) {
        return
      }
      player.playPause()
    },
    on_secondary_click: () => {
      const player = mpris.getPlayer()
      if (!player) {
        return
      }
      player.next()
    },
    child: Widget.Box({
      class_name: "bar-music-container",
      children: [
        Widget.CircularProgress({
          class_name: "music-progress",
          start_at: 0.75,
          child: Widget.Icon().hook(mpris, (icon) => {
            const player = mpris.getPlayer()
            if (!player) {
              return
            }
            let icn = icons.mpris.stopped
            if (player.play_back_status === "Playing") {
              icn = icons.mpris.playing
            } else if (player.play_back_status === "Paused") {
              icn = icons.mpris.paused
            }
            icon.icon = icn
          }),
        }).hook(mpris, (self) => {
          const player = mpris.getPlayer()
          if (!player) {
            return
          }
          self.value = player.position / player.length
        }),
        Widget.Label({
          max_width_chars: 35,
          truncate: "end",
        }).hook(mpris, (self) => {
          const player = mpris.getPlayer()
          if (!player) {
            return
          }
          self.label = player?.track_title + " - " + player?.track_artists
        }),
      ],
    }),
  })

const MusicBarContainer = () =>
  Widget.Box({
    hexpand: true,
    children: position
      .bind("value")
      .as((p) => [
        RoundedAngleEnd(`${p}left`, { class_name: "angle" }),
        MusicContainer(),
        RoundedAngleEnd(`${p}right`, { class_name: "angle" }),
      ]),
  })

export const MusicBarContainerRevealer = () => {
  return Widget.Box({
    vertical: false,
    vpack: "start",
    child: Widget.Revealer({
      child: MusicBarContainer(),
      transition: position
        .bind("value")
        .as((p) => (p === "top" ? "slide_down" : "slide_up")),
      reveal_child: Utils.watch(
        [],
        [
          [mpris, "player-changed"],
          [mpris, "player-added"],
          [mpris, "player-closed"],
        ],
        () => mpris.players,
      )
        .transform((players) =>
          players.filter((p) => p.play_back_status !== "Stopped"),
        )
        .transform((players) => players.length > 0),
    }),
  })
}
