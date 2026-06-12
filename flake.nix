{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    nixvim = {
      url = "github:nix-community/nixvim?ref=nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, nixvim, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (pkgs: {
        default = nixvim.legacyPackages.${pkgs.system}.makeNixvimWithModule {
          extraSpecialArgs = {
            enableObsidian = false;
          };
          module = ./neovim.nix;
        };
      });
    };
}
