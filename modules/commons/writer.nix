{ lib, pkgs }:
rec {
  makeSimpleBinWriter =
    {
      compileScript,
      strip ? true,
    }:
    nameOrPath: content:
    assert lib.or (lib.types.path.check nameOrPath) (
      builtins.match "([0-9A-Za-z._])[0-9A-Za-z._-]*" nameOrPath != null
    );
    assert lib.or (lib.types.path.check content) (lib.types.str.check content);
    let
      name = lib.last (builtins.split "/" nameOrPath);
    in
    pkgs.runCommand name
      (
        (
          if (lib.types.str.check content) then
            {
              inherit content;
              passAsFile = [ "content" ];
            }
          else
            { contentPath = content; }
        )
        // lib.optionalAttrs (nameOrPath == "/bin/${name}") { meta.mainProgram = name; }
      )
      # bash
      ''
        ${compileScript}

        ${lib.optionalString strip "${pkgs.binutils}/bin/strip -s $out"}

        # Didn't test on mac, I just copied this. Good luck
        ${lib.optionalString pkgs.stdenvNoCC.hostPlatform.isDarwin "fixupPhase"}

        ${lib.optionalString (lib.types.path.check nameOrPath) # bash
          ''
            mv $out tmp-loc
            mkdir -p $out/$(dirname "${nameOrPath}")
            mv tmp-loc $out/${nameOrPath}
          ''
        }
      '';

  writeZig =
    name:
    {
      zig ? pkgs.zig,
      debug ? false,
      zigArgs ? [ ],
      strip ? true,
    }:
    makeSimpleBinWriter {
      compileScript =
        with lib; # bash
        ''
          cp "$contentPath" output.zig

          ${zig}/bin/zig build-exe                              \
            --global-cache-dir $(pwd)                           \
            ${if debug then "-O Debug" else "-O ReleaseSafe"} \
            ${escapeShellArgs zigArgs}                          \
            output.zig

          mv output "$out"
        '';
      inherit strip;
    } name;

  writeZigBin = name: writeZig "/bin/${name}";
}
