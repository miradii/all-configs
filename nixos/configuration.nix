# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:



{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  
  # importing systme packages -- these are the base of things i need on a core setup
  environment.systemPackages = import ./packages.nix pkgs;
  
    home-manager.users.murtuz = import ./home.nix;
  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
   

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
   boot.loader.grub.device = "/dev/sdb"; # or "nodev" for efi only
  #FileSystems
  fileSystems."/data" =
  { device = "/dev/disk/by-label/data";
    fsType = "ext4";
  };
  fileSystems."/ntfsD" =
  { device = "/dev/disk/by-uuid/58C7001FC6FFFB58";
    fsType = "ntfs";
    options = [ "nofail" ];
  };
  fileSystems."/ntfsC" =
  { device = "/dev/disk/by-uuid/F46C9B256C9AE222";
    fsType = "ntfs";
    options = [ "nofail" ];
  };
  fileSystems."/elements" = 
  {
    device = "/dev/dis/by-uuid/F474B7AA74B76DCC";
    fsType = "ntfs";
    options = ["nofail"];
  };
  fileSystems."/sp" = 
  {
    device = "/dev/dis/by-uuid/3610EE6F10EE3611";
    fsType = "ntfs";
    options = ["nofail"];
  };

  networking.networkmanager.enable = true;
  networking.hostName = "nixos"; # Define your hostname.
 # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
   time.timeZone = "Asia/Tehran";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp2s0.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
   i18n.defaultLocale = "en_US.UTF-8";
   console = {
     font = "Lat2-Terminus16";
     useXkbConfig = true;
   };
  # Virtual Box 
   nixpkgs.config.allowUnfree = true;
  # virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.host.enableExtensionPack = true;
   virtualisation.docker.enable = true;

  # Enable tor service
    services.tor.enable = true;

    services.tor.client.enable = true;
    services.privoxy.enable = true;
    services.privoxy.enableTor = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEMS=="usb", SUBSYSTEM=="block", ENV{ID_FS_USAGE}=="filesystem", RUN{program}+="${pkgs.systemd}/bin/systemd-mount --no-block --automount=yes --collect $devnode /media"       
    '';

  # Adding windowmanagers
   services.xserver.windowManager = {
   i3.enable = true;
   i3.package = pkgs.i3-gaps; 
   i3.extraPackages = with pkgs; [
     dmenu
     feh
     i3status
     i3lock
     i3blocks
 ];
   awesome.enable = true;
   awesome.luaModules = with pkgs.luaPackages; [
        luarocks # is the package manager for Lua modules
        luadbi-mysql # Database abstraction layer
      ];

 };
  

  # Configure keymap in X11
   services.xserver = {
     layout = "us,ir";
     xkbVariant = ",pes_keypad";
     xkbOptions = "grp:alt_shift_toggle";
   };



   # Enable CUPS to print documents.
   #services.printing.enable = true;
   #services.printing.drivers = [pkgs.hplipWithPlugin];

  # Enable sound.
   sound.enable = true;
   hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
   services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.murtuz =  {
     isNormalUser = true;
     extraGroups = [ "wheel" "networkmanager" "docker"]; # Enable ‘sudo’ for the user.
   };

# fonts 
fonts.fonts = with pkgs; [
 (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  noto-fonts
  noto-fonts-cjk
  noto-fonts-emoji
  liberation_ttf
  fira-code
  fira-code-symbols
  mplus-outline-fonts.githubRelease
  dina-font
  proggyfonts
];

programs.zsh.enable = true;

users.users.murtuz.shell = pkgs.zsh;
users.defaultUserShell = pkgs.zsh;



  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
   services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

