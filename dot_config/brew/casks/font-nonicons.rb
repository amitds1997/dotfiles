cask "font-nonicons" do
  version :latest
  sha256 :no_check

  url "https://raw.githubusercontent.com/yamatsum/nonicons/refs/heads/master/dist/nonicons.ttf"
  name "Nonicons"
  desc "Icon font inspired by Octicons"
  homepage "https://github.com/yamatsum/nonicons"

  font "nonicons.ttf"
end
