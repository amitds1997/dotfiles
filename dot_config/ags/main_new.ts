import "lib/session"
import "scss/style"

import { forMonitors } from "lib/utils"
import { Bar } from "modules/Bar"

App.config({
  windows: [...forMonitors(Bar)],
  closeWindowDelay: {
    sideright: 350,
    launcher: 350,
    bar0: 350,
  },
})
