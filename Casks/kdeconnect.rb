cask "kdeconnect" do
  arch arm: "arm64", intel: "x86_64"

  base_url = "https://cdn.kde.org/ci-builds/network/kdeconnect-kde/master/macos-#{arch}"

  version "5860"
  sha256 arm:   "8cd748792f16ae90ecc5a18f68ec5c3df8aaba55a246ccdc6c0b9ad7f17c9ae3",
         intel: "2dd0896cec29e65f55bbea127f8813a67a4eb0a0d523b73c1d9076d031ebfd1e"

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
