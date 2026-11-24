cask "pot" do
  version "3.0.7"
  sha256 "b3561a92ab5bf338291c25b42bf2eb30bf4b013be379d78ffb275edbb899b0a9"

  url "https://github.com/pot-app/pot-desktop/releases/download/#{version}/pot_#{version}_aarch64.dmg"
  name "Pot"
  desc "Software for text translation and recognition"
  homepage "https://pot-app.com/"

  depends_on arch: :arm64
  depends_on :macos

  app "pot.app"
  binary "#{appdir}/pot.app/Contents/MacOS/pot"

  zap trash: [
    "~/Library/Application Support/com.pot-app.desktop",
    "~/Library/Caches/com.pot-app.desktop",
  ]
end
