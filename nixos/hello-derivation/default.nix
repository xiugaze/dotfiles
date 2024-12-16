{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "hello-nix";
  src = ./src;
  buildPhase = "";
  installPhase = ''
    mkdir -p $out/bin
    cp $src/hello-nix.sh $out/bin
  '';
}
