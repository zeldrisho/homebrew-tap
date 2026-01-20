class Zadark < Formula
  desc "Enable Dark Mode for Zalo"
  homepage "https://zadark.com"
  url "https://github.com/quaric/zadark.git",
      tag:      "v26.1",
      revision: "HEAD"
  version "26.1"
  license "MPL-2.0"
  head "https://github.com/quaric/zadark.git", branch: "main"

  depends_on "node" => :build
  depends_on "yarn" => :build
  depends_on :macos

  # Pre-built binary resources (faster than building from source)
  resource "binary_arm64" do
    url "https://storage.zadark.com/zadark26.1-macos-arm64.zip"
    sha256 "05ba765bcd83522b03792b4069f2b311b50950d58c73f87e935f50174d6150f4"
  end

  resource "binary_x64" do
    url "https://storage.zadark.com/zadark26.1-macos-x64.zip"
    sha256 "887d3de2ac30681cae58bb6d8f5a3ee397c701bd93e839ab7ae9f550b0f24d36"
  end

  def install
    # Install pre-built binary (default, faster)
    if build.without?("build-from-source") && !build.head?
      if Hardware::CPU.arm?
        resource("binary_arm64").stage do
          bin.install "zadark#{version}-macos-arm64" => "zadark"
        end
      else
        resource("binary_x64").stage do
          bin.install "zadark#{version}-macos-x64" => "zadark"
        end
      end
    else
      # Build from source
      system "yarn", "install", "--frozen-lockfile"
      system "yarn", "build"

      cd "build/pc" do
        system "yarn", "install", "--frozen-lockfile", "--production"
      end

      # Use pkg to create executable
      system "yarn", "global", "add", "pkg"
      if Hardware::CPU.arm?
        system "pkg", "build/pc", "-t", "node-macos-arm64", "-o", "zadark", "-c", "pkg.config.json"
      else
        system "pkg", "build/pc", "-t", "node-macos-x64", "-o", "zadark", "-c", "pkg.config.json"
      end

      bin.install "zadark"
    end
  end

  def caveats
    <<~EOS
      ZaDark has been installed successfully!

      Usage:
        1. Close Zalo PC completely
        2. Run command: zadark
        3. Follow on-screen instructions

      Documentation: https://zadark.com/pc/macos
      Support: https://zadark.com/contact
    EOS
  end

  test do
    assert_predicate bin/"zadark", :exist?
    assert_predicate bin/"zadark", :executable?
  end
end
