{ ... }:

{
  # Bootloader.
  boot.loader.efi = {
    canTouchEfiVariables = true;
  };

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;

    extraEntries = ''
        menuentry 'Arch Linux' --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-c2cb89b8-c6a7-44f2-ba26-98be335a5a10' {
          load_video
            set gfxpayload=keep
            insmod gzio
            insmod part_gpt
            insmod ext2
            search --no-floppy --fs-uuid --set=root c2cb89b8-c6a7-44f2-ba26-98be335a5a10
            echo	'Loading Linux linux-zen ...'
            linux	/boot/vmlinuz-linux-zen root=UUID=c2cb89b8-c6a7-44f2-ba26-98be335a5a10 rw  loglevel=3
            echo	'Loading initial ramdisk ...'
            initrd	/boot/initramfs-linux-zen.img
        }
      submenu 'Advanced options for Arch Linux' $menuentry_id_option 'gnulinux-advanced-c2cb89b8-c6a7-44f2-ba26-98be335a5a10' {
        menuentry 'Arch Linux, with Linux linux-zen' --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-linux-zen-advanced-c2cb89b8-c6a7-44f2-ba26-98be335a5a10' {
          load_video
            set gfxpayload=keep
            insmod gzio
            insmod part_gpt
            insmod ext2
            search --no-floppy --fs-uuid --set=root c2cb89b8-c6a7-44f2-ba26-98be335a5a10
            echo	'Loading Linux linux-zen ...'
            linux	/boot/vmlinuz-linux-zen root=UUID=c2cb89b8-c6a7-44f2-ba26-98be335a5a10 rw  loglevel=3
            echo	'Loading initial ramdisk ...'
            initrd	/boot/initramfs-linux-zen.img
        }
        menuentry 'Arch Linux, with Linux linux-zen (fallback initramfs)' --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-linux-zen-fallback-c2cb89b8-c6a7-44f2-ba26-98be335a5a10' {
          load_video
            set gfxpayload=keep
            insmod gzio
            insmod part_gpt
            insmod ext2
            search --no-floppy --fs-uuid --set=root c2cb89b8-c6a7-44f2-ba26-98be335a5a10
            echo	'Loading Linux linux-zen ...'
            linux	/boot/vmlinuz-linux-zen root=UUID=c2cb89b8-c6a7-44f2-ba26-98be335a5a10 rw  loglevel=3
            echo	'Loading initial ramdisk ...'
            initrd	/boot/initramfs-linux-zen-fallback.img
        }
        menuentry 'Arch Linux, with Linux linux' --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-linux-advanced-c2cb89b8-c6a7-44f2-ba26-98be335a5a10' {
          load_video
            set gfxpayload=keep
            insmod gzio
            insmod part_gpt
            insmod ext2
            search --no-floppy --fs-uuid --set=root c2cb89b8-c6a7-44f2-ba26-98be335a5a10
            echo	'Loading Linux linux ...'
            linux	/boot/vmlinuz-linux root=UUID=c2cb89b8-c6a7-44f2-ba26-98be335a5a10 rw  loglevel=3
            echo	'Loading initial ramdisk ...'
            initrd	/boot/initramfs-linux.img
        }
        menuentry 'Arch Linux, with Linux linux (fallback initramfs)' --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-linux-fallback-c2cb89b8-c6a7-44f2-ba26-98be335a5a10' {
          load_video
            set gfxpayload=keep
            insmod gzio
            insmod part_gpt
            insmod ext2
            search --no-floppy --fs-uuid --set=root c2cb89b8-c6a7-44f2-ba26-98be335a5a10
            echo	'Loading Linux linux ...'
            linux	/boot/vmlinuz-linux root=UUID=c2cb89b8-c6a7-44f2-ba26-98be335a5a10 rw  loglevel=3
            echo	'Loading initial ramdisk ...'
            initrd	/boot/initramfs-linux-fallback.img
        }
      }
      menuentry 'Windows Boot Manager (on /dev/nvme0n1p1)' --class windows --class os $menuentry_id_option 'osprober-efi-DC86-0EFE' {
         insmod part_gpt
         insmod fat
         search --no-floppy --fs-uuid --set=root DC86-0EFE
         chainloader /efi/Microsoft/Boot/bootmgfw.efi
      }
    '';

  };
}
