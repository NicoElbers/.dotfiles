{pkgs, lib, makeWrapper, buildGoModule, fetchFromGitHub, callPackage,}:

buildGoModule {
  pname = "gorun";
  version = "master";

  src = fetchFromGitHub {
    owner = "erning";
    repo = "gorun";
    rev = "02445e31634ff49849d1afa7401c34448e3ff64b";
    hash = "sha256-2Z5kz6w8k7Pa2U5/p3BZZC7rM6lRvbYnIVnYrcoCEyU=";
  };

  # gorun needs to know about the go compiler
  allowGoReference = true;

  postInstall = ''
    wrapProgram $out/bin/gorun \
      --prefix PATH : "${lib.makeBinPath [ pkgs.go ]}"
  '';

  vendorHash = null;

  nativeBuildInputs = [ makeWrapper ];
}
