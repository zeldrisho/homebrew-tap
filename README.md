# Zeldris Tap

## Installation

```sh
brew install zeldrisho/tap/<formula>
brew install --cask zeldrisho/tap/<cask>
```

Or run `brew tap zeldrisho/tap` first, then install using just the formula or cask name.

Or, in a `brew bundle` `Brewfile`:

```ruby
tap "zeldrisho/tap"
brew "<formula>"
cask "<cask>"
```

## Formulae

| Formula | Description |
| ------- | ----------- |
| [jadx-headless-mcp](Formula/jadx-headless-mcp.rb) | Headless MCP server for Android APK static analysis |
| [kotlin-toolchain](Formula/kotlin-toolchain.rb) | Build tool for Kotlin applications |
| [lightpanda](Formula/lightpanda.rb) | Headless browser designed for web automation |
| [openbullet](Formula/openbullet.rb) | Cross-platform web automation suite |
| [smali](Formula/smali.rb) | Assembler and disassembler for the Android DEX format |
| [smapi](Formula/smapi.rb) | Modding framework and API for Stardew Valley |

## Casks

| Cask | Description |
| ---- | ----------- |
| [alacritty](Casks/alacritty.rb) | GPU-accelerated terminal emulator |
| [maciconchanger](Casks/maciconchanger.rb) | Customise app and folder icons |

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).

## License

[MIT](LICENSE)
