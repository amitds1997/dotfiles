import { StackState } from "lib/stackState"
import { SearchBox } from "./launcher/Search"
import { Categories } from "./launcher/Categories"
import { WindowNames } from "modules/Bar"
import { SideDrawer } from "modules/SideDrawer"

const LauncherState = new StackState("Search")

export const AppLauncher = async () => {
  const children = {
    Search: SearchBox(LauncherState),
    ...Categories(),
  }
  return SideDrawer(children, WindowNames.Launcher, "left", LauncherState)
}
