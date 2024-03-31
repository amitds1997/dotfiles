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

  overview: {
    scale: opt(9),
    workspaces: opt(7),
    monochromeIcon: opt(true),
  },

  quicksettings: {
    position: opt<"left" | "center" | "right">("center"),
    width: opt(380),
    media: {
      monochromeIcon: opt(true),
      coverSize: opt(100),
    },
  },

  bar: {
    flatButtons: opt(true),
    position: opt<"top" | "bottom">("top"),
    layout: {
      start: opt<BarWidget[]>([
        // "launcher",
        "workspaces",
        // "taskbar",
        "messages",
        "expander",
      ]),
      center: opt<BarWidget[]>(["date"]),
      end: opt<BarWidget[]>([
        "expander",
        "media",
        "systray",
        "colorpicker",
        "screenrecord",
        "system",
        "battery",
        "powermenu",
      ]),
    },
    date: {
      format: opt("%H:%M - %A %e"),
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
      direction: opt<"left" | "right">("left"),
      format: opt("{artists} - {title}"),
      length: opt(40),
    },
    powermenu: {
      monochrome: opt(true),
      action: opt(() => App.toggleWindow("powermenu")),
    },
    workspaces: opt(5),
    systray: {
      ignore: opt(["spotify-client"]),
    },
    messages: {
      action: opt(() => App.toggleWindow("datemenu")),
    },
  },

  datemenu: {
    position: opt<"left" | "center" | "right">("center"),
  },
})

globalThis["options"] = options
export default options
