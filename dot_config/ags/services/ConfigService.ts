import Gio from "gi://Gio"
import GLib from "gi://GLib"

class ConfigService extends Service {
  private _wm: string = ""

  static {
    Service.register(
      this,
      {
        "css-changed": [],
      },
      {
        wm: ["string", "r"],
      },
    )
  }

  get wm(): string {
    return this._wm
  }

  constructor() {
    super()

    this._wm = GLib.getenv("XDG_CURRENT_DESKTOP") || ""
    this.applyScss()

    Utils.monitorFile(`${App.configDir}/scss`, (_, eventType) => {
      if (eventType === Gio.FileMonitorEvent.CHANGES_DONE_HINT) {
        this.applyScss()
      }
    })
  }

  applyScss(): void {
    try {
      // Compile scss
      Utils.exec(
        `sass ${App.configDir}/scss/main.scss ${App.configDir}/style.css`,
      )
      // console.log("SASS CSS compiled")

      // Apply compiled css
      App.resetCss()
      App.applyCss(`${App.configDir}/style.css`)
      // console.log("SASS CSS applied")
      this.emit("css-changed")
    } catch (e) {
      console.log("Error while updating CSS", e)
    }
  }
}

export default new ConfigService()
