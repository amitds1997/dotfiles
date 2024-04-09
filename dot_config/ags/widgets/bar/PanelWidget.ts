import { ButtonProps } from "types/widgets/button"

type PanelWidgetProps = ButtonProps & {
  window_class?: string
}

export default ({
  window_class = "",
  child,
  setup,
  ...rest
}: PanelWidgetProps) =>
  Widget.Button({
    class_name: "panel-widget",
    child: Widget.Box({ child }),
    setup: (self) => {
      let open = false

      self.toggleClassName(window_class)

      self.hook(App, (_, win, visible) => {
        if (win !== window_class) return

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
