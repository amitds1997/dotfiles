import "lib/session"
import "style/style"
import { forMonitors } from "lib/utils"
import Bar from "widgets/bar/Bar"
import { setupDateMenu } from "widgets/datemenu/DateMenu"
import Launcher from "widgets/launcher/Launcher"
import NotificationPopups from "widgets/notifications/NotificationPopups"
import Overview from "widgets/overview/Overview"
import PowerMenu from "widgets/powermenu/PowerMenu"
import Verification from "widgets/powermenu/Verification"
import { setupQuickSettings } from "widgets/quicksettings/QuickSettings"
import init from "lib/init"
import { setUpPreferences } from "widgets/preferences/Preferences"

App.config({
  onConfigParsed: () => {
    setupQuickSettings(), setupDateMenu(), init(), setUpPreferences()
  },
  windows: () => [
    ...forMonitors(Bar),
    ...forMonitors(NotificationPopups),
    Launcher(),
    PowerMenu(),
    Overview(),
    Verification(),
  ],
})
