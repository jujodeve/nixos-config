{
  description = "jotix NixOS configurations";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }@inputs:

    {

      nixosConfigurations = {
        jtx-nixos = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          system = "x86_64-linux";
          modules = [
            { networking.hostName = "jtx-nixos"; }
            ./config.nix
          ];
        };

        ffm-nixos = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          system = "x86_64-linux";
          modules = [
            { networking.hostName = "ffm-nixos"; }
            ./config.nix
          ];
        };

        virt-nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            { networking.hostName = "virt-nixos"; }
            ./config.nix
          ];
        };
      };
    };

}
