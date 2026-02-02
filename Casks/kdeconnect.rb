cask "kdeconnect" do
  arch arm: "arm64", intel: "x86_64"

  base_url = "https://cdn.kde.org/ci-builds/network/kdeconnect-kde/master/macos-#{arch}"

  version "5841"
  sha256 arm:   "3293b9010cfe18f6106b19a7e082a9e1d7ad51bf20286ab7bdaa4b57651f1fba",
         intel: "1e0be05d1567061e0456ef273d234bab8c55f115cccf987523bd1a6c7bd8f22e"

  url "#{base_url}/kdeconnect-kde-master-#{version}-macos-clang-#{arch}.dmg"
  name "KDE Connect"
  desc "Enabling communication between all your devices"
  homepage "https://kdeconnect.kde.org/"

  livecheck do
    url base_url
    regex(/href=.*?kdeconnect-kde-master-(\d+)-macos-clang-#{arch}\.dmg/i)
  end

  depends_on macos: ">= :ventura"

  app "KDE Connect.app"
  binary "#{appdir}/KDE Connect.app/Contents/MacOS/kdeconnect-cli",
         target: "kdeconnect"

  uninstall quit: "org.kde.kdeconnect"

  zap trash: [
    "~/Library/Application Support/kpeoplevcard",
    "~/Library/Caches/kdeconnect.sms",
    "~/Library/Preferences/kdeconnect",
    "~/Library/Preferences/kdeconnect_runcommand",
    "~/Library/Preferences/kdeconnect_sendnotifications",
    "~/Library/Preferences/kdeconnect_share",
    "~/Library/Preferences/org.kde.kdeconnect.plist",
  ]
end
