{ user, ... }:
{
  system.stateVersion = 6;
  system.primaryUser = user.name;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.zsh.enable = true;

  users.users.${user.name}.home = "/Users/${user.name}";

  system.defaults = {
    dock.autohide = true;
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
    };
  };

  # Homebrew itself is not installed by nix-darwin; see README.md.
  homebrew = {
    enable = true;
    onActivation.cleanup = "none";
    casks = [
      "visual-studio-code"
    ];
  };
}
