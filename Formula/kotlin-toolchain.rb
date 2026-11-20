class KotlinToolchain < Formula
  desc "Build tool for Kotlin applications"
  homepage "https://kotlin-toolchain.org/"
  url "https://packages.jetbrains.team/maven/p/amper/amper/org/jetbrains/kotlin/kotlin-cli/0.14.1/kotlin-cli-0.14.1-dist.tgz"
  sha256 "39fb5f7e0bd5148a02f5519e88d78752fb04e719ddb086258ff57e94d83c0fcb"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/JetBrains/kotlin-toolchain.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/zeldrisho/homebrew-tap/releases/download/kotlin-toolchain-0.14.0"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f74a349118efde67da29d88d824e037d30fc13b832d2bc7a24ccc9b0a5f41468"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "563deec9ced72bb9e272d11fc7509f0a45f2bc95d67d580329d4449258a6e61f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aef757c0b613044280ba18eb6ce1275d290e124bcc8ebcc5996b598af95420dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e775b39481bee555f306b831db8e309a750d083136c48dc057c99bc703edfea5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4372716a02bcc7a287cb940274fc632fdf9a82a6a7abea22fa55188c06cba1d0"
  end

  depends_on "openjdk"

  conflicts_with "kotlin", because: "both install a `kotlin` executable"

  deny_network_access!

  def install
    rm Dir["bin/*.exe"]
    chmod 0755, "bin/launcher.sh"
    libexec.install Dir["*"]
    (libexec/".flag").write stable.checksum.to_s
    (bin/"kotlin").write_env_script libexec/"bin/launcher.sh",
      KOTLIN_CLI_JAVA_HOME: formula_opt_prefix("openjdk")
    generate_completions_from_executable(bin/"kotlin", "generate-completion")
  end

  test do
    system bin/"kotlin", "init", "--from-template=jvm-cli", "--no-git"
    assert_path_exists testpath/"kotlin"
    assert_path_exists testpath/"kotlin.bat"
    assert_match stable.checksum.to_s, (testpath/"kotlin").read
    output = shell_output("#{bin}/kotlin show modules 2>&1")
    assert_match testpath.basename.to_s, output
  end
end
