import options from "options"
import { clock } from "lib/variables"
import PanelWidget from "../PanelWidget"

const { format, action } = options.bar.date
const time = Utils.derive([clock, format], (c, f) => c.format(f) || "")

export default () =>
  PanelWidget({
    window_class: "datemenu",
    on_clicked: action.bind(),
    child: Widget.Label({
      justification: "center",
      label: time.bind(),
    }),
  })
