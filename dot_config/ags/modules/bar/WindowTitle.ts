import { ActiveClient } from "types/service/hyprland"

const hyprland = await Service.import("hyprland")

const filterTitle = (windowTitle: ActiveClient) => {
  const windowTitleMap = [
    ["kitty", "󰄛", "Kitty Terminal"],
    ["firefox", "󰈹", "Firefox"],
    ["discord", "", "Discord"],
    ["org.kde.dolphin", "", "Dolphin"],
    ["plex", "󰚺", "Plex"],
    ["steam", "", "Steam"],
    ["spotify", "󰓇", "Spotify"],
    ["obsidian", "󱓧", "Obsidian"],
    ["^$", "󰇄", "Desktop"],
    [
      "(.+)",
      "󰣆",
      `${windowTitle.class.charAt(0).toUpperCase() + windowTitle.class.slice(1)}`,
    ],
  ]

  const foundMatch = windowTitleMap.find((wt) => {
    RegExp(wt[0]).test(windowTitle.class.toLowerCase())
  })

  return {
    icon: foundMatch
      ? foundMatch[1]
      : windowTitleMap[windowTitleMap.length - 1][1],
    label: foundMatch
      ? foundMatch[2]
      : windowTitleMap[windowTitleMap.length - 1][2],
  }
}

export const ClientTitle = () => {
  return {
    component: Widget.Box({
      children: [
        Widget.Label({
          class_name: "bar-button-icon windowtitle",
          label: hyprland.active.bind("client").as((v) => filterTitle(v).icon),
        }),
      ],
    }),
    isVisible: true,
    boxClass: "windowtitle",
  }
}
