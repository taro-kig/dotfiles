{ user, ... }:
{
  imports = [ ./common.nix ];

  home.username = user.name;
  home.homeDirectory = "/home/${user.name}";

  targets.genericLinux.enable = true;

  programs.zsh.shellAliases = {
    flake-switch = "home-manager switch --flake ~/dotfiles#wsl --impure";
    open = "explorer.exe";
    pbcopy = "clip.exe";
  };
}
