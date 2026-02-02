class PassCli < Formula
  desc "Proton Pass CLI - Command-line interface for Proton Pass"
  homepage "https://proton.me/pass"
  version "1.4.1"
  license "GPL-3.0"

  on_macos do
    on_intel do
      url "https://proton.me/download/pass-cli/#{version}/pass-cli-macos-x86_64"
      sha256 "ceffa547d14af8ea5acf0963f11ef0d60ee0bd37fd7ed34a4c70ef86d82ad035"
    end

    on_arm do
      url "https://proton.me/download/pass-cli/#{version}/pass-cli-macos-aarch64"
      sha256 "7019050f490d8289c045eca39a6abf3fd480f6bcc3fa7807831241b4ec13d7f1"
    end
  end

  on_linux do
    on_intel do
      url "https://proton.me/download/pass-cli/#{version}/pass-cli-linux-x86_64"
      sha256 "0c642cdf84186ce5084995b71029c0fbb7795428232beab8d8741937fdb7264b"
    end

    on_arm do
      url "https://proton.me/download/pass-cli/#{version}/pass-cli-linux-aarch64"
      sha256 "28f4ab25b0ea215c95e87d4d57c2499fe809aca6e9545104ec08995973aa83ad"
    end
  end

  def install
    bin.install Dir["pass-cli-*"].first => "pass-cli"
  end

  test do
    output = shell_output("#{bin}/pass-cli --version")
    assert_match(/Proton Pass CLI #{version}/, output)
  end
end
