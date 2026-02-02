class Smapi < Formula
  desc "Modding framework for Stardew Valley"
  homepage "https://smapi.io/"
  url "https://github.com/Pathoschild/SMAPI/releases/download/4.5.1/SMAPI-4.5.1-installer.zip"
  sha256 "ee3dc8f771858da8610c9e6b1322d934b0e981804a2d656fcb237989dbe8f7b7"
  license "GPL-3.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "dotnet@6"

  def install
    platform_folder = OS.mac? ? "macOS" : "linux"

    cd "internal/#{platform_folder}" do
      system "unzip", "-q", "install.dat"
      
      libexec.install Dir["bundle/smapi-internal/*"]
      bin.install "bundle/unix-launcher.sh" => "smapi"
      chmod 0755, bin/"smapi"
      (libexec/"Mods").install Dir["bundle/Mods/*"]
    end

    (bin/"StardewModdingAPI").write_env_script(
      libexec/"StardewModdingAPI",
      DOTNET_ROOT: Formula["dotnet@6"].opt_libexec
    )
  end

  test do
    assert_predicate libexec/"StardewModdingAPI", :exist?
    assert_predicate libexec/"StardewModdingAPI.dll", :exist?
  end
end
