{ pkgs, ... }:

{
  # Bootloader.
  boot.loader.efi = {
    canTouchEfiVariables = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;

    extraEntries = ''
      menuentry 'Windows Boot Manager (on /dev/nvme0n1p1)' --class windows --class os $menuentry_id_option 'osprober-efi-DC86-0EFE' {
         insmod part_gpt
         insmod fat
         search --no-floppy --fs-uuid --set=root DC86-0EFE
         chainloader /efi/Microsoft/Boot/bootmgfw.efi
      }
    '';

  };
}
