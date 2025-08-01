{ inputs, ... }: 
[
  # https://github.com/NixOS/nixpkgs/issues/429888
  (final: prev: {
    linux-manual = prev.linux-manual.overrideAttrs (old: {
      installCheckPhase = ''
        echo "Skipping kmalloc(9) check for kernel 6.16"
      '';
    });
  })
]
