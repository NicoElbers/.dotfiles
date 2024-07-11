{ lib, pkgs, ... }:
let 
  writers = import ./commons/writer.nix { inherit lib pkgs; };
in
{
  zello = writers.writeZigBin "zello" { } /*zig*/ ''
    const std = @import("std");

    pub fn main() void {
      std.debug.print("Hello world from zig!", .{});
    }
  '';
}
