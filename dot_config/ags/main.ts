import "lib/session"
import { init } from "lib/init"
import { forMonitors } from "lib/utils"
import NotificationPopup from "widgets/notifications/NotificationPopup"

App.config({
  onConfigParsed: () => {
    init()
  },
  windows: [...forMonitors(NotificationPopup)],
})
