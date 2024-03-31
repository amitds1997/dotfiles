export default async function init() {
  try {
    globalThis["media"] = await Service.import("mpris")
  } catch (error) {
    logError(error)
  }
}
