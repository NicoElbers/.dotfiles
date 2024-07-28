{
  zig = {
    path = ./zig;
    description = "Zig compiler master environment";
  };
  rust = {
    path = ./rust;
    description = "Rust compiler unstable environment";
  };
  c = {
    path = ./c;
    description = "A Nix-flake-based C/C++ development environment";
  };
  c-zig = {
    path = ./c-zig;
    description = "A Nix-flake-based C/C++ development environment, with zig as build system";
  };
}
