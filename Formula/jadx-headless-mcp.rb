class JadxHeadlessMcp < Formula
  desc "Headless MCP server for Android APK static analysis"
  homepage "https://github.com/1013503897/jadx-headless-mcp"
  url "https://github.com/1013503897/jadx-headless-mcp/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "8a97fcd615b5ec99b9b3a6b459f68599df0baad8283cf094c1db0302ea9acf05"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/zeldrisho/homebrew-tap/releases/download/jadx-headless-mcp-0.8.0"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7e5acb06a3ab9bfc8a5b225254414e25381433f2ffe65b90fa93e4393e43bd44"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8bfc82bc4c8e56499a1a8dcc3a39efa0bd8812a9878da9cc3728c95e031cb5da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9e25a991a14465de1ba5ad9c5edce88cfb9e66a81d12260496a686bd62a8bd03"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5b2d23b64a47eba6fc9c17007bfd1dd6bbdba4b0a037d21105d4253c63bf547b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "902fa54ad3ed988d9a92e02bfaf73152b573ca1178ef5ededcc0a8c139340d93"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  allow_network_access! :build

  def install
    inreplace "build.gradle.kts", "    jvmToolchain(17)", <<~KOTLIN
      compilerOptions { jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17) }
      java { targetCompatibility = JavaVersion.VERSION_17 }
    KOTLIN
    system "gradle", "shadowJar", "--no-daemon"
    libexec.install "build/libs/jadx-headless-mcp-#{version}-all.jar"
    bin.write_jar_script libexec/"jadx-headless-mcp-#{version}-all.jar", "jadx-headless-mcp"
  end

  test do
    IO.popen(bin/"jadx-headless-mcp", "r+") do |mcp|
      mcp.puts({
        jsonrpc: "2.0", id: 1, method: "initialize",
        params:  {
          protocolVersion: "2025-03-26", capabilities: {}, clientInfo: { name: "homebrew", version: "1.0" }
        }
      }.to_json)
      assert_match "jadx-headless-mcp", mcp.gets
      mcp.puts '{"jsonrpc":"2.0","method":"notifications/initialized"}'
      mcp.puts '{"jsonrpc":"2.0","id":2,"method":"tools/list"}'
      assert_match '"name":"load_apk"', mcp.gets
    ensure
      Process.kill "TERM", mcp.pid
    end
  end
end
