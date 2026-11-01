{
  description = "taro-kig's dotfiles for macOS and WSL";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-darwin,
      ...
    }:
    let
      # The login name comes from the environment so it stays out of this
      # public repository. Reading it requires --impure.
      loginName =
        let
          sudoUser = builtins.getEnv "SUDO_USER";
          envUser = if sudoUser != "" then sudoUser else builtins.getEnv "USER";
        in
        if envUser != "" then envUser else throw "Run with --impure so USER can be read.";

      user = {
        name = loginName;
        gitName = "taro-kig";
        gitEmail = "taro-kig@users.noreply.github.com";
      };

      # Change these to match your machines.
      macHost = "my-mac"; # output of `scutil --get LocalHostName`
      macSystem = "aarch64-darwin"; # use "x86_64-darwin" on Intel Macs
      wslSystem = "x86_64-linux";
    in
    {
      darwinConfigurations.${macHost} = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit user; };
        modules = [
          ./darwin
          { nixpkgs.hostPlatform = macSystem; }
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit user; };
              users.${user.name} = import ./home/darwin.nix;
            };
          }
        ];
      };

      homeConfigurations.wsl = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${wslSystem};
        extraSpecialArgs = { inherit user; };
        modules = [ ./home/wsl.nix ];
      };
    };
}
