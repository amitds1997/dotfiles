import brightness from "services/brightness"

export default async function init() {
  try {
    globalThis["media"] = await Service.import("mpris")
    globalThis["brightness"] = brightness
  } catch (error) {
    logError(error)
  }
}
