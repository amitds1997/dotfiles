import "lib/session"
import { forMonitors } from "lib/utils"
import Bar from "widgets/bar/Bar"
import { setupDateMenu } from "widgets/datemenu/DateMenu"
import Launcher from "widgets/launcher/Launcher"
import NotificationPopups from "widgets/notifications/NotificationPopups"
import OSD from "widgets/osd/OSD"
import PowerMenu from "widgets/powermenu/PowerMenu"
import Verification from "widgets/powermenu/Verification"

App.config({
  onConfigParsed: () => {
    setupDateMenu()
  },
  windows: () => [
    ...forMonitors(Bar),
    ...forMonitors(NotificationPopups),
    // ...forMonitors(OSD),
    Launcher(),
    PowerMenu(),
    Verification(),
  ],
})
