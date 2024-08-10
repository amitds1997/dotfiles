import { getIcon } from "lib/icons"
import { Application } from "types/service/applications"

export const AppIcon = (app: Application) =>
  Widget.Icon({
    class_name: "app-icon",
    icon: getIcon(app.icon_name),
  })
