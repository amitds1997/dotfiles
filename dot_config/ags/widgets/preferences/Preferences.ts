import options from "options"
import { Media } from "widgets/preferences/widgets/Media"
import { DND } from "./widgets/DND"
import { ScreenRecorder, Screenshoter } from "./widgets/ScreenRecWidgets"
import { DarkModeToggle } from "./widgets/DarkMode"
import { Brightness } from "./widgets/Brightness"
import { setUpBarWindow } from "widgets/BarWindow"

const { preferences } = options
const media = (await Service.import("mpris")).bind("players")

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

export function setUpPreferencesMenu() {
  setUpBarWindow({
    name: "preferences",
    child: PreferenceBox(),
  })
}
