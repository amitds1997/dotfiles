import Gdk from "gi://Gdk?version=3.0"
import Gtk from "gi://Gtk?version=3.0"
import { globalMousePos } from "globals"

const closeAllMenus = () => {
  const menuRegex = /.*menu/
  for (const w of App.windows) {
    if (w.name && menuRegex.test(w.name)) {
      App.closeWindow(w.name)
    }
  }
}

export const openMenu = (
  clicked: Gtk.Widget,
  event: Gdk.Event,
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
  App.toggleWindow(window)
}
