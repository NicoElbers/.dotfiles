# TODO: Work with a pure github reference instead of a path
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
}
