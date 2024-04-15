import brightness from "services/brightness"
import Audio from "widgets/audio/Audio"
import Bluetooth from "widgets/bluetooth/Bluetooth"
import Network from "widgets/network/Network"

export default async function init() {
  try {
    globalThis["media"] = await Service.import("mpris")
    globalThis["brightness"] = brightness
    App.addWindow(Bluetooth())
    App.addWindow(Network())
    App.addWindow(Audio())
  } catch (error) {
    logError(error)
  }
}
