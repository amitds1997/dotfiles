import "lib/session"
import "style/style"
import { forMonitors } from "lib/utils"
import Bar from "widgets/bar/Bar"
import { setUpDateMenu } from "widgets/datemenu/DateMenu"
import Launcher from "widgets/launcher/Launcher"
import NotificationPopups from "widgets/notifications/NotificationPopups"
import Overview from "widgets/overview/Overview"
import PowerMenu from "widgets/powermenu/PowerMenu"
import Verification from "widgets/powermenu/Verification"
import init from "lib/init"
import { setUpPreferencesMenu } from "widgets/preferences/Preferences"
import { setUpBluetoothMenu } from "widgets/bluetooth/Bluetooth"
import { setUpNetworkMenu } from "widgets/network/Network"
import { setUpAudioMenu } from "widgets/audio/Audio"

App.config({
  onConfigParsed: () => {
    setUpDateMenu()
    setUpBluetoothMenu()
    setUpNetworkMenu()
    setUpAudioMenu()
    init()
    setUpPreferencesMenu()
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
