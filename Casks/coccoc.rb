cask "coccoc" do
  version "143.0.7499.182"
  sha256 "81a571e1401ee94dc3004abc19b683c64836b29eb3e997c4b39fae75d5f26445"

  url "https://files1.coccoc.com/browser/mac/coccoc.dmg"
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
