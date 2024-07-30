export const BarItemBox = (child: any) => {
  return Widget.Button({
    class_name: `bar_item_box_visible ${
      Object.hasOwnProperty.call(child, "boxClass") ? child.boxClass : ""
    }`,
    child: child.component,
    visible: child.isVisible,
    ...child.props,
  })
}
