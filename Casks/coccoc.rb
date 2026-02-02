cask "coccoc" do
  version :latest

  url "https://files1.coccoc.com/browser/mac/coccoc.dmg"
  sha256 :no_check
  name "Cốc Cốc"
  desc "Vietnamese Chromium-based web browser"
  homepage "https://coccoc.com/"

  livecheck do
    url :url
    strategy :extract_plist
  end

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
