{ inputs, ... }: 
[
  # https://github.com/NixOS/nixpkgs/issues/429888
  (final: prev: {
     linux-manual = prev.linux-manual.overrideAttrs (old: {
       nativeBuildInputs = [
         prev.perl
         prev.python3
       ];
       postPatch = ''
         chmod +x scripts/kernel-doc.py scripts/split-man.pl
         patchShebangs --build \
           scripts/kernel-doc.py \
           scripts/split-man.pl
         '';
     });
   })
]
