class Smapi < Formula
  desc "Modding framework and API for Stardew Valley"
  homepage "https://smapi.io/"
  url "https://github.com/Pathoschild/SMAPI/archive/refs/tags/4.5.2.tar.gz"
  sha256 "3deeba11bbc81392bc6fd925e221c64ca7bff764d1f931bea5a3d3acde41aa9d"
  license "LGPL-3.0-only"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/zeldrisho/homebrew-tap/releases/download/smapi-4.5.2_1"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "51c48143bc0415f42a8dbfa1d89e27c147016a249283920d000d47fce5e02299"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2637bc409251d30a1e7d1935b2420e60eb4b3c1c6a6681601c59bc9bd7a3feca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e156d65637b41b49b14ec28bd94b496c7b9a2ca607376ac9959ac0c02e938827"
    sha256 cellar: :any,                 arm64_linux:       "11a1da5392ff8c9ae310e1e5fa3ba7c9272176cc4adf6a077704d740d6edba76"
    sha256 cellar: :any,                 x86_64_linux:      "7ca17f9baed522116f1ff74836580acc1ae2b778da59f988f3af370dd1982740"
  end

  depends_on "dotnet"
  uses_from_macos "zip" => :build

  resource "reference-assemblies" do
    url "https://github.com/StardewModders/mod-reference-assemblies/archive/0141355fecb8536715ecff22f99374b5e632cbed.tar.gz"
    sha256 "1db0e09df776e3a59f5cabf2200f47bd10ec535ad18e9fd05f06d0cecc618c43"
  end

  allow_network_access! :build

  def runtime
    return "linux-#{Hardware::CPU.arm? ? "arm64" : "x64"}" if OS.linux?

    Hardware::CPU.arm? ? "osx-arm64" : "osx-x64"
  end

  def publish_args
    %W[
      --configuration Release
      --framework net6.0
      --runtime #{runtime}
      --no-self-contained
      -p:CopyToGameFolder=false
      -p:GamePath=#{buildpath}/reference-assemblies
      -p:OS=#{OS.mac? ? "OSX" : "Unix"}
      -p:PlatformTarget=#{Hardware::CPU.arm? ? "ARM64" : "x64"}
      -p:PublishTrimmed=false
      -p:RollForward=LatestMajor
    ]
  end

  def install
    resource("reference-assemblies").stage(buildpath/"reference-assemblies")

    system "dotnet", "publish", "src/SMAPI", *publish_args
    system "dotnet", "publish", "src/SMAPI.Installer", *publish_args
    %w[ConsoleCommands SaveBackup].each do |mod_name|
      system "dotnet", "publish", "src/SMAPI.Mods.#{mod_name}", *publish_args
    end

    smapi_output = buildpath/"src/SMAPI/bin/Release/#{runtime}/publish"
    installer_output = buildpath/"src/SMAPI.Installer/bin/Release/#{runtime}/publish"
    bundle = buildpath/"install-bundle"
    internal = bundle/"smapi-internal"
    internal.mkpath

    %w[StardewModdingAPI StardewModdingAPI.dll StardewModdingAPI.xml steam_appid.txt].each do |file|
      bundle.install smapi_output/file if (smapi_output/file).exist?
    end
    bundle.install "src/SMAPI.Installer/assets/unix-launcher.sh"
    bundle.install "src/SMAPI.Installer/assets/runtimeconfig.json" => "StardewModdingAPI.runtimeconfig.json"

    internal_files = Dir["#{smapi_output}/*.dll", "#{smapi_output}/*.xml"].reject do |file|
      file.end_with?("StardewModdingAPI.dll", "StardewModdingAPI.xml")
    end
    internal_files.each do |file|
      internal.install file
    end
    internal.install smapi_output/"i18n" if (smapi_output/"i18n").directory?

    %w[ConsoleCommands SaveBackup].each do |mod_name|
      mod_output = buildpath/"src/SMAPI.Mods.#{mod_name}/bin/Release/#{runtime}/publish"
      mod_bundle = bundle/"Mods/#{mod_name}"
      mod_bundle.mkpath
      mod_bundle.install mod_output/"#{mod_name}.dll"
      mod_bundle.install mod_output/"manifest.json"
      mod_bundle.install mod_output/"i18n" if (mod_output/"i18n").directory?
    end

    %w[blacklist.json config.json metadata.json].each do |name|
      file = smapi_output/"SMAPI.#{name}"
      internal.install file => name if file.exist?
    end

    cd bundle do
      system "zip", "-qr", buildpath/"install.dat", "."
    end

    libexec.install Dir["#{installer_output}/*"]
    libexec.install buildpath/"install.dat"
    (bin/"smapi").write_env_script "dotnet", libexec/"SMAPI.Installer.dll",
                                   DOTNET_ROOT: formula_opt_libexec("dotnet")
  end

  test do
    game = testpath/"game"
    game.mkpath
    (game/"Stardew Valley.deps.json").write "{}"
    (game/"StardewValley").write ""
    (game/"StardewValley.dll").write ""

    output = shell_output("#{bin}/smapi --install --game-path '#{game}' --no-prompt")
    assert_match "Extracting install files...", output
    assert_match "Failed finding your game path", output

    assert_path_exists libexec/"install.dat"
    archive = shell_output("unzip -Z1 '#{libexec}/install.dat'")
    assert_match "StardewModdingAPI\n", archive
    assert_match "unix-launcher.sh\n", archive
    assert_match "#!/usr/bin/env bash", shell_output("unzip -p '#{libexec}/install.dat' unix-launcher.sh")
    assert_path_exists libexec/"SMAPI.Installer.dll"
  end
end
