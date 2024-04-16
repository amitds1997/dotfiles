import options from "options"
import { Media } from "widgets/preferences/widgets/Media"
import PopupWindow from "widgets/PopupWindow"
import { DND } from "./widgets/DND"
import { ScreenRecorder, Screenshoter } from "./widgets/ScreenRecWidgets"
import { DarkModeToggle } from "./widgets/DarkMode"
import { Brightness } from "./widgets/Brightness"

const { bar, preferences } = options
const media = (await Service.import("mpris")).bind("players")
const layout = Utils.derive(
  [bar.position, preferences.position],
  (bar, p) => `${bar}-${p}` as const,
)

const PreferenceBox = () =>
  Widget.Box({
    vertical: true,
    hexpand: true,
    class_name: "preferences vertical",
    css: preferences.width.bind().as((w) => `min-width: ${w}px;`),
    children: [
      Widget.Box({
        vertical: false,
        hexpand: true,
        children: [DND(), Screenshoter(), ScreenRecorder(), DarkModeToggle()],
      }),
      Brightness(),
      Widget.Box({
        visible: media.as((l) => l.length > 0),
        child: Media(),
      }),
    ],
  })

const Preferences = () =>
  PopupWindow({
    name: "preferences",
    exclusivity: "exclusive",
    transition: bar.position
      .bind()
      .as((p) => (p === "top" ? "slide_down" : "slide_up")),
    layout: layout.value,
    child: PreferenceBox(),
  })

export function setUpPreferences() {
  App.addWindow(Preferences())
  layout.connect("changed", () => {
    App.removeWindow("preferences")
    App.addWindow(Preferences())
  })
}
