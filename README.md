# NixOS

## Easy install

Run the command
   
    bash <(curl -fsSL https://gitlab.com/jotix/nixos-config/-/raw/main/scripts/nixos-install.sh)
	
## Preparation

### Disk layout

Make the necesary disk preparations:

In a disk with GPT partition type, create the following partitions:

| LABEL      | FS TYPE | FLAG | SUBVOLUME | MOUNTPOINT |
|------------|---------|------|-----------|------------|
| nixos      | btrfs   |      | @         | /          |
|            |         |      | @nix      | /nix       |
| nixos-efi  | fat32   | esp  | -         | -          |
| jtx-data   | btrfs   |      | @home     | /home      | 

### Disk subvolumes & mount points 

	### create the subvolumes
    sudo mount --mkdir LABEL=nixos /temp/nixos
    sudo btrfs subvolume create /temp/nixos/@
    sudo btrfs subvolume create /temp/nixos/@nix
    sudo mount --mkdir LABEL=jtx-data /temp/jtx-data
    [[ ! -d /temp/jtx-data/home ]] && sudo btrfs subvolume create /temp/jtx-data/@home
    
    ### mount all in the right place
    sudo mount LABEL=nixos /mnt -osubvol=/@
    sudo mount --mkdir LABEL=nixos /mnt/nix -osubvol=/@nix
    sudo mount --mkdir LABEL=nixos-efi /mnt/boot
    sudo mount --mkdir LABEL=jtx-data /mnt/home -osubvol=/@home

## Installation

    sudo nixos-install --flake gitlab:jotix/nixos-config/#[HOSTNAME]

## Post Intall tasks

chroot in the new system

    sudo nixos-enter 

Set users passwords and home folder

    passwd jotix
    passwd filofem
    ### in case of existing home directory
    chown -R jotix /home/jotix
    chown -R filofem /home/filofem

Unmount & reboot

    sudo umount -R /mnt
    reboot

# Module Template

    ### NAME Module

    { config, lib, pkgs, ... }:

    {
      options.OPTION.enable = lib.mkEnableOption "Enable OPTION";

      config = lib.mkIf(config.OPTION.enable) {

      };
    }

# virtiofs

Error starting domain: operation failed: Unable to find a satisfying virtiofsd

add virtiofsd into your systemPackages and add following into virt-manager filesystem xml:

    <binary path="/run/current-system/sw/bin/virtiofsd"/>

# Plasma packages

paquetes que recopile tratando de hacer funcionar
las cuentas online (google drive)
pero nada funciona hasta ahora

    [
      libsForQt5.plasma-browser-integration
      libsForQt5.kaccounts-integration
      libsForQt5.kaccounts-providers
      libsForQt5.kio-gdrive
      libsForQt5.signond
      libsForQt5.qoauth
      libsForQt5.accounts-qt
      libsForQt5.mauikit-accounts
    ] ++ (with lib; filter isDerivation (attrValues pkgs.plasma5Packages.kdeGear)); ## for install all kde apps

# Uninstalling home-manager

    nix run home-manager/release-24.05 -- uninstall

# Network Printers

Edit the Device URI in /etc/cups/printers.conf

    ...
    DeviceURI ...........
    ...

Restart cups

    sudo systemctl restart cups

Impresora Brother HL-1212W connection

    ipp://192.168.0.7/ipp/port1

Impresora HPRT TP806L

    socket://192.168.0.2

# YouTube uBlock shorts filter

    ! Title: Hide YouTube Shorts
    ! Description: Hide all traces of YouTube shorts videos on YouTube
    ! Version: 1.8.0
    ! Last modified: 2023-01-08 20:02
    ! Expires: 2 weeks (update frequency)
    ! Homepage: https://github.com/gijsdev/ublock-hide-yt-shorts
    ! License: https://github.com/gijsdev/ublock-hide-yt-shorts/blob/master/LICENSE.md

    ! Hide all videos containing the phrase "#shorts"
    youtube.com##ytd-grid-video-renderer:has(#video-title:has-text(#shorts))
    youtube.com##ytd-grid-video-renderer:has(#video-title:has-text(#Shorts))
    youtube.com##ytd-grid-video-renderer:has(#video-title:has-text(#short))
    youtube.com##ytd-grid-video-renderer:has(#video-title:has-text(#Short))

    ! Hide all videos with the shorts indicator on the thumbnail
    youtube.com##ytd-grid-video-renderer:has([overlay-style="SHORTS"])
    youtube.com##ytd-rich-item-renderer:has([overlay-style="SHORTS"])
    youtube.com##ytd-video-renderer:has([overlay-style="SHORTS"])
    youtube.com##ytd-item-section-renderer.ytd-section-list-renderer[page-subtype="subscriptions"]:has(ytd-video-renderer:has([overlay-style="SHORTS"]))

    ! Hide shorts button in sidebar
    youtube.com##ytd-guide-entry-renderer:has-text(Shorts)
    youtube.com##ytd-mini-guide-entry-renderer:has-text(Shorts)

    ! Hide shorts section on homepage
    youtube.com##ytd-rich-section-renderer:has(#rich-shelf-header:has-text(Shorts))
    youtube.com##ytd-reel-shelf-renderer:has(.ytd-reel-shelf-renderer:has-text(Shorts))

    ! Hide shorts tab on channel pages
    ! Old style
    youtube.com##tp-yt-paper-tab:has(.tp-yt-paper-tab:has-text(Shorts))
    ! New style (2023-10)
    youtube.com##yt-tab-shape:has-text(/^Shorts$/)

    ! Hide shorts in video descriptions
    youtube.com##ytd-reel-shelf-renderer.ytd-structured-description-content-renderer:has-text("Shorts remixing this video")

    ! Remove empty spaces in grid
    youtube.com##ytd-rich-grid-row,#contents.ytd-rich-grid-row:style(display: contents !important)


    !!! MOBILE !!!

    ! Hide all videos in home feed containing the phrase "#shorts"
    m.youtube.com##ytm-rich-item-renderer:has(#video-title:has-text(#shorts))
    m.youtube.com##ytm-rich-item-renderer:has(#video-title:has-text(#Shorts))
    m.youtube.com##ytm-rich-item-renderer:has(#video-title:has-text(#short))
    m.youtube.com##ytm-rich-item-renderer:has(#video-title:has-text(#Short))

    ! Hide all videos in subscription feed containing the phrase "#shorts"
    m.youtube.com##ytm-item-section-renderer:has(#video-title:has-text(#shorts))
    m.youtube.com##ytm-item-section-renderer:has(#video-title:has-text(#Shorts))
    m.youtube.com##ytm-item-section-renderer:has(#video-title:has-text(#short))
    m.youtube.com##ytm-item-section-renderer:has(#video-title:has-text(#Short))

    ! Hide shorts button in the bottom navigation bar
    m.youtube.com##ytm-pivot-bar-item-renderer:has(.pivot-shorts)

    ! Hide all videos with the shorts indicator on the thumbnail
    m.youtube.com##ytm-video-with-context-renderer:has([data-style="SHORTS"])

    ! Hide shorts sections
    m.youtube.com##ytm-rich-section-renderer:has(ytm-reel-shelf-renderer:has(.reel-shelf-title-wrapper:has-text(Shorts)))
    m.youtube.com##ytm-reel-shelf-renderer.item:has(.reel-shelf-title-wrapper:has-text(Shorts))

    ! Hide shorts tab on channel pages
    m.youtube.com##.single-column-browse-results-tabs>a:has-text(Shorts)

# Launch a virtual monitor with kwin_wayland

    export $(dbus-launch); kwin_wayland -s "wayland-1" --xwayland plasmashell

# dd iso file in USB device

    dd bs=4M if=path/to/archlinux-version-x86_64.iso of=/dev/disk/by-id/usb-My_flash_drive conv=fsync oflag=direct status=progress

# creating 7z encypted file

    s7z a \
       -t7z -m0=lzma2 -mx=9 -mfb=64 \
       -md=32m -ms=on -mhe=on -p'eat_my_shorts' \
       archive.7z dir1

# IP camera as webcam

    sudo modprobe v4l2loopbak-dkms
