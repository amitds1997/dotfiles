import Gdk30 from "gi://Gdk?version=3.0"
import Gtk30 from "gi://Gtk?version=3.0"
import { globalMousePos } from "globals"

const closeAllMenus = () => {
  App.windows
    .filter((w) => {
      if (w.name) {
        return /.*menu/.test(w.name)
      }
      return false
    })
    .map((w) => w.name)
    .forEach((w) => {
      if (w) {
        App.closeWindow(w)
      }
    })
}

export const openMenu = (
  clicked: Gtk30.Widget,
  event: Gdk30.Event,
  window: string,
) => {
  const middleOfButton = Math.floor(clicked.get_allocated_width() / 2)
  const xAxisOfButtonClick = clicked.get_pointer()[0]
  const middleOffset = middleOfButton - xAxisOfButtonClick

  const clickPos = event.get_root_coords()
  const adjustedXCoord = clickPos[1] + middleOffset
  const coords = [adjustedXCoord, clickPos[2]]

  globalMousePos.value = coords

  closeAllMenus()
  App.ToggleWindow(window)
}
