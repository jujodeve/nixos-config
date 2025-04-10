# default configuration

{
  config,
  lib,
  pkgs,
  ...
}:

let
  hostname = config.networking.hostName;
in

  {
    imports = [
      ./modules/default.nix
      ./hardware-config.nix
    ];

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
      "pipe-operators"
    ];

    nixpkgs.config.allowUnfree = true;

    system.stateVersion = "24.11";

  ### boot loader #############################################################
  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        # useOSProber = true;
      };
    };
  };

  ### graphics drivers ########################################################
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

  ### keyboard layout ##########################################################
  services.xserver.xkb = {
    layout = "us";
    variant = "altgr-intl";
  };

  ### networking ###############################################################
  networking = {
    networkmanager = {
      enable = true;
      dns = "none";
    };
    nameservers = [
      "8.8.8.8"
      "8.8.4.4"
    ];
  };

  ### locale #################################################################
  time.timeZone = "America/Argentina/Buenos_Aires";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "es_AR.UTF-8/UTF-8"
  ];

  i18n.extraLocaleSettings = {
    LANG = "en_US.UTF-8";
    LANGUAGE = "en_US.UTF-8";
    LC_ALL = "es_AR.UTF-8";
  };

  ### users ####################################################################
  users.users.jotix = {
    isNormalUser = true;
    description = "jotix";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
    ];
  };

  users.users.filofem = lib.mkIf (hostname == "ffm-nixos") {
    isNormalUser = true;
    description = "FILOfem";
    extraGroups = [
      "networkmanager"
    ];
  };

  ### shell aliases ############################################################
  environment.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake .#";
    rebuild-boot = "sudo nixos-rebuild boot --flake .#";
    cdc = "cd ~/workspace/nixos-config";
    gitroot = "cd $(git rev-parse --show-toplevel)";
    gr = "gitroot";
    google_drive_upload = "rclone copy ~/Documents jujodeve:";
    gdu = "google_drive_upload";
    zed = "zeditor";
  };

  ### servicess ################################################################

  ### pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.udev = {
    enable = true;
    extraRules = "SUBSYSTEM==\"usb\", ENV{ID_VENDOR_ID}==\"0483\", ENV{ID_MODEL_ID}==\"070b\", MODE=\"0666\"\n";
  };

  # services.flatpak.enable = true;

  ### packages #################################################################
  environment.systemPackages = with pkgs; [
    exfat
    exfatprogs
    ntfs3g
    usbutils
    pciutils
    gnumake
    cmake
    gcc
    nixd
    nixfmt-rfc-style
    zip
    unzip
    p7zip
    killall
    wget
    fastfetch
    wlr-randr
    mpv
    htop
    fuse
    wl-clipboard
    xclip
    virtiofsd
    gparted
    qmk
    qmk-udev-rules
    vial
    spotify
    gimp
    rclone
    libreoffice
    inkscape
    python3
    ventoy-full
    transmission_3
    transmission_3-qt
    ghostscript
    google-chrome
    firefox
    dwt1-shell-color-scripts
    emacs
    eza
    bat
    powerline-go
    lazygit
    zed-editor
  ];

  fonts.packages = with pkgs; [
    jetbrains-mono
    fira-code
    nerd-fonts.fira-code
    ubuntu_font_family
  ];

  ### programs #################################################################
  programs = {
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      #pinentryPackage = pkgs.pinentry-curses;
    };
    fuse.userAllowOther = true;
    dconf.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    git.enable = true;

  };

}
