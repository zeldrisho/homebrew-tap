class KotlinToolchain < Formula
  desc "Build tool for Kotlin applications"
  homepage "https://kotlin-toolchain.org/"
  url "https://packages.jetbrains.team/maven/p/amper/amper/org/jetbrains/kotlin/kotlin-cli/0.14.0/kotlin-cli-0.14.0-dist.tgz"
  sha256 "69112cebc1fdb14c92a213244182d0834896e71b3d9411b8e8c18540da2884a6"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/JetBrains/kotlin-toolchain.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/zeldrisho/homebrew-tap/releases/download/kotlin-toolchain-0.13.0"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f7387b6797a9c949a775a41d7258c30cccfc0116dfe4dded83637dc4b6ec3882"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "200c35742029e0cb800d9f37ebb738e2edd9ec38584edd8c56c19fed34eeffea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ec93c0ab25a2270b40bb4acc950e0c9d3ad5f064a76ee57e0fcbf8d332885188"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "14ee4bb3d0e8256ebeb4b87e489ba950114ef6f4ef2fabb6e99b37fb24c2755c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ac21af192e62f29343207f9c0dda138d71b462324f8595158146b9f8f65afaa7"
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
