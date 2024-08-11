import { StackState } from "lib/stackState"
import { WindowNames } from "./Bar"
import { QuickSettings } from "./quicksettings/QuickSettings"
import { SideDrawer } from "./SideDrawer"

const QSState = new StackState("Notifications")

export const SettingsLauncher = async () => {
  const children = {
    ...QuickSettings(),
  }

  return SideDrawer(children, WindowNames.QuickSettings, "right", QSState)
}
