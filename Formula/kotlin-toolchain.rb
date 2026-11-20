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
    root_url "https://github.com/zeldrisho/homebrew-tap/releases/download/kotlin-toolchain-0.14.1"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4e44ed40b760cd9bd21ad93d3c62594869464d36998c0cfab0f43a66b9cc697a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "00c80b0805c0a9c92db301cb337c8d8351ba4ed319b5496761cb66bee1267ac1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bca2b38d76deeacdd3ed90ce517a1643f24e09f822456c6e47a09f85975cdaee"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3678d97c941cc45f2d3849e1b4d993ec9b984e6230a1944c6aae48386782e8f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "275c15744d259cfad1afe3bbbf5a71014a9078dbe6cb8609e402b79fed73fa55"
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
