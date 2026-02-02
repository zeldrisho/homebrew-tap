class Bun < Formula
  desc "Fast JavaScript runtime, bundler, transpiler and package manager"
  homepage "https://bun.sh/"
  version "1.3.8"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/bun-v?(\d+(?:\.\d+)+)["' >]}i)
  end

  if OS.mac?
    if Hardware::CPU.arm? || Hardware::CPU.in_rosetta2?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-darwin-aarch64.zip"
      sha256 "672a0a9a7b744d085a1d2219ca907e3e26f5579fca9e783a9510a4f98a36212f"
    elsif Hardware::CPU.avx2?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-darwin-x64.zip"
      sha256 "4a0ecd703b37d66abaf51e5bc24fd1249e8dc392c17ee6235710cf51a0988b85"
    else
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-darwin-x64-baseline.zip"
      sha256 "9812e5f6c7f818ef9c491e05a77481ab2e7a4a1580b378526e1611c102fe7ca3"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-aarch64.zip"
      sha256 "4e9deb6814a7ec7f68725ddd97d0d7b4065bcda9a850f69d497567e995a7fa33"
    elsif Hardware::CPU.avx2?
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-x64.zip"
      sha256 "0322b17f0722da76a64298aad498225aedcbf6df1008a1dee45e16ecb226a3f1"
    else
      url "https://github.com/oven-sh/bun/releases/download/bun-v#{version}/bun-linux-x64-baseline.zip"
      sha256 "bbe4632ac03d7495177d542ecefa8f21f9849273106525f6bb13172ec8e4ab2c"
    end
  end

  def install
    bin.install "bun"
    ENV["BUN_INSTALL"] = bin.to_s
    generate_completions_from_executable(bin/"bun", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bun -v")
  end
end
