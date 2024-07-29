import { debounce, zsh } from "lib/utils"

const hyprland = await Service.import("hyprland")

interface MonitorProps {
  percent?: number
  is_laptop_display: boolean
  max_brightness?: number
  last_known_percent?: number
}

class Brightness extends Service {
  static {
    Service.register(
      this,
      {},
      {
        monitors: ["jsobject", "r"],
      },
    )
  }

  private _monitors: Map<number, MonitorProps> = new Map()

  get monitors() {
    return this._monitors
  }

  private async setInitialBrightness(monitorID?: number) {
    if (monitorID === undefined) {
      monitorID = hyprland.active.monitor.id
    }
    const monitorInfo = this._monitors.get(monitorID)!

    const is_laptop_display = monitorInfo.is_laptop_display
    if (monitorInfo.max_brightness === undefined) {
      const max_brightness_cmd = is_laptop_display
        ? "brightnessctl max"
        : `bash -c "ddcutil -t -d ${monitorID} getvcp 10 | awk '{print $5}'"`
      monitorInfo.max_brightness = Number(Utils.exec(max_brightness_cmd))
    }
    const max_brightness = monitorInfo.max_brightness
    const brightness_cmd = is_laptop_display
      ? "brightnessctl get"
      : `bash -c "ddcutil -t -d ${monitorID} getvcp 10 | awk '{print $4}'"`

    monitorInfo.percent = Number(Utils.exec(brightness_cmd)) / max_brightness
    monitorInfo.last_known_percent = monitorInfo.percent
  }

  private getMonitorID(monitorID?: number): number {
    if (monitorID === undefined) {
      monitorID = hyprland.active.monitor.id
    }
    return monitorID
  }

  toggleBrightness(monitorID?: number) {
    monitorID = this.getMonitorID(monitorID)
    const monitorInfo = this._monitors.get(monitorID)!

    if (monitorInfo.percent === 0) {
      this.brightness(monitorInfo.last_known_percent!, monitorID)
    } else {
      monitorInfo.last_known_percent = monitorInfo.percent
      this.brightness(0, monitorID)
    }
  }

  brightness = debounce(
    (val: number, id: number) => this._brightness(val, id),
    500,
  )

  private async _brightness(percent: number, monitorID?: number) {
    monitorID = this.getMonitorID(monitorID)
    percent = Math.floor(percent * 100)
    const monitorInfo = this._monitors.get(monitorID)!

    const brightness_cmd = monitorInfo.is_laptop_display
      ? `brightnessctl set ${percent}% -q`
      : `ddcutil -d ${monitorID} setvcp 10 ${percent} --noverify`

    if (monitorInfo.percent !== percent) {
      zsh(brightness_cmd).then(() => {
        monitorInfo.percent = percent / 100
        this.changed("monitors")
      })
    }
  }

  constructor() {
    super()

    hyprland.monitors.forEach((m) => {
      this._monitors.set(m.id, {
        is_laptop_display: m.name.startsWith("eDP"),
      })
      this.setInitialBrightness(m.id)
    })
  }
}

export default new Brightness()
