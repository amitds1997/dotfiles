import brightness from "services/brightness"

export default async function init() {
  try {
    globalThis["media"] = await Service.import("mpris")
    globalThis["brightness"] = brightness
    globalThis["globalMousePos"] = Variable([0, 0])
  } catch (error) {
    logError(error)
  }
}
