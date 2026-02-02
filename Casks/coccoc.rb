cask "coccoc" do
  version :latest
  sha256 :no_check

  url "https://files1.coccoc.com/browser/mac/coccoc.dmg"
  name "Cốc Cốc"
  desc "Vietnamese Chromium-based web browser"
  homepage "https://coccoc.com/"

  app "CocCoc.app"

  uninstall launchctl: "com.coccoc.CocCoc"

  zap trash: [
    "~/Library/Application Support/Coccoc",
    "~/Library/Caches/Coccoc",
    "~/Library/Caches/com.coccoc.Coccoc",
    "~/Library/Preferences/com.coccoc.Coccoc.plist",
    "~/Library/Saved Application State/com.coccoc.Coccoc.savedState",
  ]
end
