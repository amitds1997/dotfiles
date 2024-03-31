import "lib/session"
import "style/style"
import { forMonitors } from "lib/utils"
import Bar from "widgets/bar/Bar"
import { setupDateMenu } from "widgets/datemenu/DateMenu"
import Launcher from "widgets/launcher/Launcher"
import NotificationPopups from "widgets/notifications/NotificationPopups"
// import OSD from "widgets/osd/OSD"
import Overview from "widgets/overview/Overview"
import PowerMenu from "widgets/powermenu/PowerMenu"
import Verification from "widgets/powermenu/Verification"
import { setupQuickSettings } from "widgets/quicksettings/QuickSettings"

App.config({
  onConfigParsed: () => {
    setupQuickSettings(), setupDateMenu()
  },
  windows: () => [
    ...forMonitors(Bar),
    ...forMonitors(NotificationPopups),
    // ...forMonitors(OSD),
    Launcher(),
    PowerMenu(),
    Overview(),
    Verification(),
  ],
})
