import { mkOptions, opt } from "lib/options"
import { BarWidget } from "widgets/bar/Bar"

const options = mkOptions(OPTIONS, {
  theme: {
    dark: {
      primary: {
        bg: opt("#51a4e7"),
        fg: opt("#141414"),
      },
      error: {
        bg: opt("#e55f86"),
        fg: opt("#141414"),
      },
      bg: opt("#171717"),
      fg: opt("#eeeeee"),
      widget: opt("#eeeeee"),
      border: opt("#eeeeee"),
    },
    light: {
      primary: {
        bg: opt("#426ede"),
        fg: opt("#eeeeee"),
      },
      error: {
        bg: opt("#b13558"),
        fg: opt("#eeeeee"),
      },
      bg: opt("#fffffa"),
      fg: opt("#080808"),
      widget: opt("#080808"),
      border: opt("#080808"),
    },
    blur: opt(0),
    scheme: opt<"dark" | "light">("dark"),
    widget: { opacity: opt(94) },
    border: {
      width: opt(1),
      opacity: opt(96),
    },
    shadows: opt(true),
    padding: opt(7),
    spacing: opt(12),
    radius: opt(11),
  },
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

  hyprland: {
    gaps: opt(2.4),
    inactiveBorder: opt("#3333ff"),
    gapsWhenOnly: opt(false),
  },

  font: {
    size: opt(13),
    name: opt("Rec Mono Casual"),
  },
})

globalThis["options"] = options
export default options
