import GLib from "gi://GLib?version=2.0"
import icons from "lib/icons"
import { zsh } from "lib/utils"
import { clock } from "lib/variables"

class Recorder extends Service {
  static {
    Service.register(
      this,
      {},
      {
        timer: ["int"],
        recording: ["boolean"],
      },
    )
  }

  #recordingsDir = Utils.HOME + "/Videos/ScreenRecordings"
  #screenshotDir = Utils.HOME + "/Pictures/Screenshots"
  #recordingFilePath = ""
  #interval = 0

  recording = false
  timer = 0

  async start() {
    if (this.recording) return

    Utils.ensureDirectory(this.#recordingsDir)
    this.#recordingFilePath = `${this.#recordingsDir}/${clock.value.format("%Y-%m-%d_%H-%M-%S")}.mp4`
    zsh(`wf-recorder -g "${await zsh("slurp")}" -f ${this.#recordingFilePath}`)

    this.recording = true
    this.changed("recording")

    this.timer = 0
    this.#interval = Utils.interval(1000, () => {
      this.changed("timer")
      this.timer++
    })
  }

  async stop() {
    if (!this.recording) return

    await zsh("pkill --signal=INT wf-recorder || true")
    this.recording = false
    this.changed("recording")
    GLib.source_remove(this.#interval)

    Utils.notify({
      iconName: icons.fallback.video,
      summary: "Screen recording",
      body: this.#recordingFilePath,
      actions: {
        "Show in Files": () => zsh(`xdg-open ${this.#recordingsDir}`),
        View: () => zsh(`xdg-open ${this.#recordingFilePath}`),
      },
    })
  }

  async screenshot(full = false) {
    const filePath = `${this.#screenshotDir}/${clock.value.format("%Y-%m-%d_%H-%M-%S")}.png`
    Utils.ensureDirectory(this.#screenshotDir)

    if (full) {
      await zsh(`grim ${filePath}`)
    } else {
      const size = await zsh("slurp")
      if (!size) return

      await zsh(`grim -g "${size}" ${filePath}`)
    }

    Utils.notify({
      image: filePath,
      summary: "Screenshot captured!",
      body: filePath,
      actions: {
        "Show in Files": () => zsh(`xdg-open ${this.#screenshotDir}`),
        View: () => zsh(`xdg-open ${filePath}`),
        Edit: () => zsh(`swappy -f ${filePath}`),
      },
    })
  }
}

const recorder = new Recorder()
Object.assign(globalThis, { recorder })
export default recorder
