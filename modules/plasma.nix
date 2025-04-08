### Plasma Module

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.plasma.enable = lib.mkEnableOption "Enable KDE Plasma Desktop Environment";

  config = lib.mkIf (config.plasma.enable) {

    services.xserver.enable = true;

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      autoNumlock = true;
    };

    services.desktopManager.plasma6.enable = true;

    environment.systemPackages = with pkgs; [
      kdePackages.kate
      kdePackages.kcalc
      kdePackages.plasma-browser-integration
      kitty
    ];
    # for installing all kdePackages
    # ++ kdePackages.sources
    #   |> builtins.attrNames
    #   |> builtins.map (n: kdePackages.${n})
    #   |> builtins.filter (pkg: !pkg.meta.broken);
    # nixpkgs.config.permittedInsecurePackages = [
    #   "olm-3.2.16"
    # ];

    programs.chromium.plasmaBrowserIntegrationPackage = pkgs.kdePackages.plasma-browser-integration;

  };
}
