import { Binding } from "lib/utils"
import * as AppLauncher from "./AppLauncher"
import icons from "lib/icons"
import options from "options"
import PopupWindow, { Padding } from "widgets/window/PopupWindow"

const { width, margin } = options.launcher

function Launcher() {
  const favs = AppLauncher.Favourites()
  const appLauncher = AppLauncher.Launcher()

  function HelpButton(cmd: string, desc: string | Binding<string>) {
    return Widget.Box(
      { vertical: true },
      Widget.Separator(),
      Widget.Button(
        {
          class_name: "help",
          on_clicked: () => {
            entry.grab_focus()
            entry.text = `:${cmd} `
            entry.set_position(-1)
          },
        },
        Widget.Box([
          Widget.Label({
            class_name: "name",
            label: `:${cmd}`,
          }),
          Widget.Label({
            hexpand: true,
            hpack: "end",
            class_name: "description",
            label: desc,
          }),
        ]),
      ),
    )
  }

  const help = Widget.Revealer({
    child: Widget.Box(
      { vertical: true },
      HelpButton("sh", "run a binary"),
      Widget.Box(),
    ),
  })

  const entry = Widget.Entry({
    hexpand: true,
    primary_icon_name: icons.ui.search,
    on_accept: () => {
      appLauncher.launchFirst()
      App.toggleWindow("launcher")
      entry.text = ""
    },
    on_change: ({ text }) => {
      text ||= ""
      favs.reveal_child = text === ""
      help.reveal_child = text.split(" ").length === 1 && text?.startsWith(":")

      appLauncher.filter(text)
    },
  })

  function focus() {
    entry.text = "Search"
    entry.set_position(-1)
    entry.select_region(0, -1)
    entry.grab_focus()
    favs.reveal_child = true
  }

  const layout = Widget.Box({
    css: width.bind().as((v) => `min-width: ${v}pt;`),
    class_name: "launcher",
    vertical: true,
    vpack: "start",
    setup: (self) =>
      self.hook(App, (_, win, visible) => {
        if (win !== "launcher") return

        entry.text = ""
        if (visible) focus()
      }),
    children: [Widget.Box([entry]), favs, help, appLauncher],
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
    name: "launcher",
    layout: "top",
    child: Launcher(),
  })
