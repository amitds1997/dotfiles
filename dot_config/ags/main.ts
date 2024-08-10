import "lib/session"
import "services/ConfigService"

import { forMonitors } from "lib/utils"
import { BarWindow } from "modules/Bar"
import { Launcher } from "modules/launcher/Launcher"

App.config({
  style: "./style.css",
  icons: "./assets/icons/",
  windows: [...forMonitors(BarWindow), await Launcher()],
})
