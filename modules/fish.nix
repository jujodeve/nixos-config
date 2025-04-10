### fish Module

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.fish.enable = lib.mkEnableOption "Enable Fish shell";

  config = lib.mkIf (config.fish.enable) {

    users.defaultUserShell = pkgs.fish;

    programs.fish.enable = true;

  };
}
