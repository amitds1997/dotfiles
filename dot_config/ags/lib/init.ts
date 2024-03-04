import css from "style/style"

export async function init() {
  try {
    css()
  } catch (error) {
    logError(error)
  }
}
