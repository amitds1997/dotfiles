import brightness from "services/brightness"
import Bluetooth from "widgets/bluetooth/Bluetooth"

export default async function init() {
  try {
    globalThis["media"] = await Service.import("mpris")
    globalThis["brightness"] = brightness
    App.addWindow(Bluetooth())
  } catch (error) {
    logError(error)
  }
}
