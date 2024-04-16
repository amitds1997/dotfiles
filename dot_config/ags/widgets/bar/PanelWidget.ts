import { ButtonProps } from "types/widgets/button"

type PanelWidgetProps = ButtonProps & {
  window_class?: string
}

export default ({
  window_class: child_class_name = "",
  child,
  setup,
  ...rest
}: PanelWidgetProps) =>
  Widget.Button({
    child: Widget.Box({ class_name: child_class_name, child: child }),
    setup: (self) => {
      let open = false

      self.toggleClassName("panel-widget")
      self.hook(App, (_, win, visible) => {
        if (win !== child_class_name) return

        // TODO: Do we need to do this? Ideally, windows should automatically handle their visibility; but this might be a good fallback to have. Will revisit this once the rest of the work is done
        if (open && !visible) {
          open = false
          self.toggleClassName("active", false)
        }

        if (visible) {
          open = true
          self.toggleClassName("active")
        }
      })

      if (setup) setup(self)
    },
    ...rest,
  })
