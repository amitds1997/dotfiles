import icons from "lib/icons"
import { zsh } from "lib/utils"

const COLORS_CACHE = Utils.CACHE_DIR + "/ags/colorpicker.json"
const MAX_NUM_COLORS = 10

class ColorPicker extends Service {
  static {
    Service.register(
      this,
      {},
      {
        colors: ["jsobject"],
      },
    )
  }

  #notifID = 0
  #colors = JSON.parse(Utils.readFile(COLORS_CACHE) || "[]") as string[]

  get colors() {
    return [...this.#colors]
  }

  set colors(colors) {
    this.#colors = colors
    this.changed("colors")
  }

  async wlCopy(color: string) {
    zsh(`wl-copy ${color}`)
  }

  readonly pick = async () => {
    const color = await zsh("hyprpicker")
    if (!color) {
      return
    }

    Utils.ensureDirectory(COLORS_CACHE.split("/").slice(0, -1).join("/"))
    const colorList = this.colors
    if (!colorList.includes(color)) {
      colorList.push(color)
      if (colorList.length > MAX_NUM_COLORS) {
        colorList.push()
      }

      this.colors = colorList
      Utils.writeFile(JSON.stringify(colorList, null, 2), COLORS_CACHE)
    }

    this.#notifID = await Utils.notify({
      id: this.#notifID,
      iconName: icons.ui.colorpicker,
      body: `Selected color is ${color}`,
      summary: "Color Picker",
    })
  }
}

export default new ColorPicker()
