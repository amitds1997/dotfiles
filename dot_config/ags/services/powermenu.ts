import options from "options"

export type Action =
  | "suspend"
  | "reboot"
  | "logout"
  | "shutdown"
  | "lock"
  | "hibernate"

const { suspend, reboot, logout, shutdown, lock, hibernate } = options.powermenu

class PowerMenu extends Service {
  static {
    Service.register(
      this,
      {},
      {
        title: ["string"],
        cmd: ["string"],
      },
    )
  }

  #title = ""
  #cmd = ""

  get title() {
    return this.#title
  }

  get cmd() {
    return this.#cmd
  }

  action(action: Action) {
    ;[this.#cmd, this.#title] = {
      suspend: [suspend.value, "Suspend"],
      reboot: [reboot.value, "Reboot"],
      logout: [logout.value, "Log out"],
      shutdown: [shutdown.value, "Shutdown"],
      lock: [lock.value, "Lock"],
      hibernate: [hibernate.value, "Hibernate"],
    }[action]

    this.notify("cmd")
    this.notify("title")
    this.emit("changed")
    App.closeWindow("powermenu")
    App.openWindow("verification")
  }

  readonly shutdown = () => {
    this.action("shutdown")
  }
}

const powermenu = new PowerMenu()
Object.assign(globalThis, { powermenu })
export default powermenu
