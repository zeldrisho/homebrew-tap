class Smali < Formula
  desc "Assembler and disassembler for the Android DEX format"
  homepage "https://github.com/google/smali"
  url "https://github.com/google/smali/archive/refs/tags/3.0.10.tar.gz"
  sha256 "faaa812184f90eebf7ce3026f13371f544a254652f690b2dfbe2fdb21e8b5d29"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/zeldrisho/homebrew-tap/releases/download/smali-3.0.10"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "72d1d1ff56f50833204e62661ab0ad3ce9aa4a6ce3329786f969f5a55cc8db0f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "312cf8e6791e3ee462ea002123f1c899c2b6adb661862bc31b222bb821149556"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "acd909933d068de49c7806d901de1a4b8fe24cdc05bc507b724d5905b483282a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2d815cbe0b8943c798c850753dd630d374b7e3d99f4c8d4b6a1c61c38cd85c64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "198f52c2f0db0d2d95aa726a69cb1803ac7f09578e1e44810871a0573e10608a"
  end

  depends_on "gradle@8" => :build
  depends_on "openjdk"

  allow_network_access! :build

  def install
    system "gradle", "--no-daemon", "smali:fatJar", "baksmali:fatJar"

    libexec.install buildpath.glob("{smali,baksmali}/build/libs/*-fat.jar")
    bin.write_jar_script libexec/"smali-#{version}-fat.jar", "smali"
    bin.write_jar_script libexec/"baksmali-#{version}-fat.jar", "baksmali"
  end

  test do
    (testpath/"Hello.smali").write <<~EOS
      .class public LHello;
      .super Ljava/lang/Object;

      .method public static main([Ljava/lang/String;)V
          .registers 1
          return-void
      .end method
    EOS

    system bin/"smali", "assemble", "-o", testpath/"classes.dex", testpath/"Hello.smali"
    assert_path_exists testpath/"classes.dex"
    assert_operator (testpath/"classes.dex").size, :>, 0
    shell_output("#{bin}/baksmali disassemble -o #{testpath}/out #{testpath}/classes.dex")
    assert_path_exists testpath/"out/Hello.smali"
    assert_match "main([Ljava/lang/String;)V", (testpath/"out/Hello.smali").read
  end
end
