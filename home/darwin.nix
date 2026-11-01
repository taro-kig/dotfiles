{ ... }:
{
  imports = [ ./common.nix ];

  programs.zsh.shellAliases = {
    flake-switch = "sudo darwin-rebuild switch --flake ~/dotfiles --impure";
  };
}
