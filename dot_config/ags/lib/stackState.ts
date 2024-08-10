import { Variable as Var } from "resource:///com/github/Aylur/ags/variable.js"

export class StackState<T> extends Var<T> {
  static {
    Service.register(this)
  }

  items: T[] = []

  constructor(value: T) {
    super(value)
  }

  setIndex(idx: number) {
    this.value = this.items[Math.max(0, Math.min(idx, this.items.length - 1))]
  }

  next() {
    const index = this.items.indexOf(this.value) + 1
    this.value = this.items[index % this.items.length]
  }

  prev() {
    const index = this.items.indexOf(this.value) - 1 + this.items.length
    this.value = this.items[index % this.items.length]
  }
}
