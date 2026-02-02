class Zadark < Formula
  desc "Utilities for Zalo"
  homepage "https://zadark.com"
  url "https://github.com/quaric/zadark/archive/refs/tags/26.1.tar.gz"
  sha256 "8465c97494dd460a95529ad065077da2b8c1431f77d8a00adc4fc5733802effa"
  license "MPL-2.0"
  head "https://github.com/quaric/zadark.git", branch: "main"

  depends_on "node@22" => :build
  depends_on "yarn" => :build

  def install
    system "yarn", "install", "--frozen-lockfile"
    system "yarn", "build"

    cd "build/pc" do
      system "yarn", "install", "--frozen-lockfile", "--production"
    end

    target = if OS.mac?
      Hardware::CPU.arm? ? "node22-macos-arm64" : "node22-macos-x64"
    else
      Hardware::CPU.arm? ? "node22-linux-arm64" : "node22-linux-x64"
    end
    system "npx", "@yao-pkg/pkg", "build/pc/index.js", "-t", target, "-o", "zadark", "-c", "pkg.config.json"

    chmod 0755, "zadark"
    bin.install "zadark"
  end

  test do
    output = shell_output("#{bin}/zadark -v").strip
    assert_match(/^ZaDark \d+\.\d+\.\d+ \(.*\)$/, output,
                 "Version output should match format 'ZaDark X.Y.Z (arch)'")
    
    assert_match "Khong tim thay Zalo PC",
                 shell_output("#{bin}/zadark install /nonexistent/path 2>&1", 1)
  end
end
