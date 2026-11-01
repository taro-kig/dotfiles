{ pkgs, user, ... }:
{
  imports = [ ./common.nix ];

  home.username = user.name;
  home.homeDirectory = "/home/${user.name}";

  targets.genericLinux.enable = true;

  # tmux copies through pbcopy; clip.exe needs UTF-16 to keep Japanese intact.
  home.packages = [
    (pkgs.writeShellScriptBin "pbcopy" "iconv -f UTF-8 -t UTF-16LE | /mnt/c/Windows/System32/clip.exe")
  ];

  programs.zsh.shellAliases = {
    flake-switch = "home-manager switch --flake ~/dotfiles#wsl --impure";
    open = "explorer.exe";
  };
}
