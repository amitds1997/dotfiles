import "lib/session";
import PowerMenu from "widgets/powermenu/PowerMenu";
import Verification from "widgets/powermenu/Verification";

App.config({
  windows: () => [PowerMenu(), Verification()],
});
