import * as AppLauncher from "./AppLauncher"
import icons from "lib/icons"
import options from "options"
import PopupWindow, { Padding, PopupNames } from "widgets/PopupWindow"

const { width, margin } = options.launcher

function Launcher() {
  const favApps = AppLauncher.Favourites()
  const appLauncher = AppLauncher.Launcher()

  const entry = Widget.Entry({
    hexpand: true,
    primary_icon_name: icons.ui.search,
    on_accept: () => {
      appLauncher.launchFirst()
      App.toggleWindow(PopupNames.Launcher)
      entry.text = ""
    },
    on_change: ({ text }) => {
      text ||= ""
      favApps.reveal_child = text === ""

      appLauncher.filter(text)
    },
  })

  function focus() {
    entry.text = "Search"
    entry.set_position(-1)
    entry.select_region(0, -1)
    entry.grab_focus()
    favApps.reveal_child = true
  }

  const layout = Widget.Box({
    css: width.bind().as((v) => `min-width: ${v}pt;`),
    class_name: "launcher",
    vertical: true,
    vpack: "start",
    setup: (self) =>
      self.hook(App, (_, win, visible) => {
        if (win !== PopupNames.Launcher) {return}

        entry.text = ""
        if (visible) {focus()}
      }),
    children: [Widget.Box([entry]), favApps, appLauncher],
  })

  return Widget.Box(
    { vertical: true, css: "padding: 1px" },
    Padding("applauncher", {
      css: margin.bind().as((v) => `min-height: ${v}pt;`),
      vexpand: false,
    }),
    layout,
  )
}

export default () =>
  PopupWindow({
    name: PopupNames.Launcher,
    layout: "top",
    child: Launcher(),
  })
