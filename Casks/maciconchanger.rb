cask "maciconchanger" do
  version "1.5.2"
  sha256 "c463147ad7b0626584e0ccf8ccf351469e4cd24b2ed1cc6e3de6b0eaa3b7fa1d"

  url "https://github.com/zeldrisho/macIconChanger/releases/download/v#{version}/IconChanger.dmg"
  name "IconChanger"
  desc "Customise app and folder icons"
  homepage "https://github.com/zeldrisho/macIconChanger"

  depends_on macos: :ventura

  app "IconChanger.app"

  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/IconChanger.app"]
  end

  zap trash: [
    "~/.iconchanger",
    "~/Library/Application Support/com.zhuhaoyu.IconChanger",
    "~/Library/Caches/com.zhuhaoyu.IconChanger",
    "~/Library/Preferences/com.zhuhaoyu.IconChanger.plist",
  ]
end
