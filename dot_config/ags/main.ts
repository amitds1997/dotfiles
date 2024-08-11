import "lib/session"
import "services/ConfigService"

import { forMonitors } from "lib/utils"
import { BarWindow } from "modules/Bar"
import { AppLauncher } from "modules/AppLauncher"
import { SettingsLauncher } from "modules/SettingsLauncher"
import { PopupNotifications } from "modules/PopupNotification"

App.config({
  style: "./style.css",
  icons: "./assets/icons/",
  windows: [
    ...forMonitors(BarWindow),
    await AppLauncher(),
    await SettingsLauncher(),
    PopupNotifications(),
  ],
  closeWindowDelay: {
    launcher: 500,
    quicksettings: 500,
    popupNotifications: 200,
  },
})
