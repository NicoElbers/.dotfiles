{pkgs, ...}:
let 
  nixCats = builtins.getFlake (toString ./config);
in
{
  imports = [
    nixCats.nixosModules.default
  ];

  config = {
    environment = {
      systemPackages = [
        nixCats.packages.${pkgs.system}.nixCats
      ];
      variables = {
        EDITOR = "nv";
      };
    };

  };

  # inherit nixpkgs system dependencyOverlays extra_pkg_config;
}
