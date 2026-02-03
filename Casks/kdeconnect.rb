cask "kdeconnect" do
  arch arm: "arm64", intel: "x86_64"

  base_url = "https://cdn.kde.org/ci-builds/network/kdeconnect-kde/master/macos-#{arch}"

  version "5856"
  sha256 arm:   "e16024e4aee728cdd5408e2333339e6eb22b2fe11b979e36d75ba1599331046b",
         intel: "a57d393bf934d325d57bebb34ebf1cf13b6213442f70edc43495e3bbaf4047a0"

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
