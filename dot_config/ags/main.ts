import "lib/session"
import "services/ConfigService"

import { forMonitors } from "lib/utils"
import { BarWindow } from "modules/Bar"

App.config({
  style: "./style.css",
  icons: "./assets/icons/",
  windows: [...forMonitors(BarWindow)],
})
