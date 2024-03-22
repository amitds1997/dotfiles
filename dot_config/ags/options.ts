import { mkOptions, opt } from "lib/options"
import { BarWidget } from "widgets/bar/Bar"

const options = mkOptions(OPTIONS, {
  launcher: {
    apps: {
      max: opt(7),
      iconSize: opt(62),
      favourites: opt([["firefox", "discord"]]),
    },
    width: opt(0),
    margin: opt(80),
  },

  notifications: {
    position: opt<Array<"top" | "bottom" | "left" | "right">>(["top", "right"]),
    width: opt(440),
  },

  osd: {
    microphone: {
      pack: {
        h: opt<"start" | "center" | "end">("center"),
        v: opt<"start" | "center" | "end">("end"),
      },
    },
    progress: {
      vertical: opt(true),
      pack: {
        h: opt<"start" | "center" | "end">("end"),
        v: opt<"start" | "center" | "end">("center"),
      },
    },
  },

  powermenu: {
    lock: opt("hyprlock"),
    logout: opt(`loginctl terminate-user ${USER_NAME}`),
    shutdown: opt("systemctl poweroff"),
    reboot: opt("systemctl reboot"),
    suspend: opt("systemctl suspend"),
    hibernate: opt("systemctl hibernate"),
    layout: opt<"line" | "box">("box"),
    labels: opt(true),
  },

  transition: opt(200),

  bar: {
    flatButtons: opt(true),
    position: opt<"top" | "bottom">("top"),
    layout: {
      start: opt<BarWidget[]>([
        // "launcher",
        // "workspaces",
        // "taskbar",
        "expander",
        // "messages",
      ]),
      center: opt<BarWidget[]>(["date"]),
      end: opt<BarWidget[]>([
        "media",
        "expander",
        // "systray",
        // "colorpicker",
        // "screenrecord",
        // "system",
        "battery",
        "powermenu",
      ]),
    },
    date: {
      format: opt("%H:%M - %A %e."),
      action: opt(() => App.toggleWindow("datemenu")),
    },
    battery: {
      percentage: opt(true),
      low: opt(20),
      bar: opt<"hidden" | "regular" | "whole">("regular"),
      charging: opt("#00D787"),
      blocks: opt(7),
      width: opt(50),
    },
    media: {
      monochrome: opt(true),
      preferred: opt("firefox"),
      direction: opt<"left" | "right">("right"),
      format: opt("{artists} - {title}"),
      length: opt(40),
    },
    powermenu: {
      monochrome: opt(true),
      action: opt(() => App.toggleWindow("powermenu")),
    },
  },

  datemenu: {
    position: opt<"left" | "center" | "right">("center"),
  },
})

globalThis["options"] = options
export default options
