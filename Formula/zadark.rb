class Zadark < Formula
  desc "Enable Dark Mode for Zalo"
  homepage "https://zadark.com/"
  url "https://github.com/quaric/zadark/archive/refs/tags/26.1.tar.gz"
  sha256 "8465c97494dd460a95529ad065077da2b8c1431f77d8a00adc4fc5733802effa"
  license "MPL-2.0"
  head "https://github.com/quaric/zadark.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "node@16" => :build
  depends_on "yarn" => :build
  depends_on :macos

  def install
    # Install Node.js dependencies
    system "yarn", "install", "--frozen-lockfile"

    # Build the PC version (compiles JS, CSS, etc.)
    system "yarn", "build"

    # Determine target architecture for pkg
    target = if Hardware::CPU.arm?
      "node16-macos-arm64"
    else
      "node16-macos-x64"
    end

    # Package the macOS binary using pkg
    cd "build/pc" do
      system "npx", "pkg", ".",
             "--config", "../../pkg.config.json",
             "--targets", target,
             "--output", "zadark"
    end

    bin.install "build/pc/zadark"
  end

  def caveats
    <<~EOS
      ZaDark has been installed!

      Usage:
        zadark install     - Install ZaDark for Zalo PC
        zadark uninstall   - Uninstall ZaDark from Zalo PC
        zadark --version   - Show ZaDark version

      For more information:
        https://zadark.com/pc/macos

      Note: Make sure Zalo PC is installed at /Applications/Zalo.app
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zadark --version")
  end
end
