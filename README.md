# dotfiles

Nix Flakes と Home Manager で管理する macOS / WSL 用の dotfiles です。
Windows 本体は Nix の対象外なので、`winget` と PowerShell で管理します。

| 環境 | 設定の場所 |
|---|---|
| 共通 | `home/common.nix`, `nvim/` |
| macOS | `home/darwin.nix`, `darwin/default.nix` |
| WSL | `home/wsl.nix` |
| Windows 本体 | `windows/` |

このリポジトリは `~/dotfiles` に clone してください。Neovim の設定は `~/dotfiles/nvim` へのリンクで読み込みます。

ユーザー名は実行時の環境変数から読み取るので、適用時は `--impure` が必要です。

## 最初に編集する箇所

`flake.nix` の `let` にある次の値を、自分の環境に合わせて変更します。

- `macHost`: mac で `scutil --get LocalHostName` を実行した結果
- `macSystem`: Intel Mac なら `x86_64-darwin`

## macOS

1. [Nix](https://nixos.org/download/) と [Homebrew](https://brew.sh/) をインストールします。
2. このリポジトリを `~/dotfiles` に clone します。
3. 初回だけ次のコマンドを実行します。`my-mac` は `macHost` の値に置き換えます。

```bash
cd ~/dotfiles && sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin/master#darwin-rebuild -- switch --flake .#my-mac --impure
```

2回目以降は `flake-switch` で適用できます。

## Windows / WSL

1. 管理者権限の PowerShell で `wsl --install` を実行し、指示があれば再起動します。
2. WSL の Ubuntu で systemd が有効なことを確認し、[Nix](https://nixos.org/download/) をインストールします。
3. このリポジトリを `~/dotfiles` に clone します。
4. 初回だけ次のコマンドを実行します。

```bash
cd ~/dotfiles && nix --extra-experimental-features "nix-command flakes" run home-manager/master -- switch --flake .#wsl --impure
```

5. ログインシェルを zsh に変更します。

```bash
echo "$HOME/.nix-profile/bin/zsh" | sudo tee -a /etc/shells && chsh -s "$HOME/.nix-profile/bin/zsh"
```

2回目以降は `flake-switch` で適用できます。

Windows 本体の設定は、PowerShell で次のコマンドを実行します。

```powershell
powershell -ExecutionPolicy Bypass -File .\windows\setup.ps1
```

## 更新

```bash
nix flake update
```

更新後に `flake-switch` で適用し、`flake.lock` をコミットします。

## 秘密情報

公開リポジトリなので、トークンや秘密鍵はコミットしないでください。
