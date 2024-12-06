{config, pkgs, ...}: 
let
    unstable = import <nixos-unstable> { config.allowUnfree = true; };
in {
    environment.systemPackages = with pkgs; [
    # needed for neovim
        unstable.neovim
        unstable.tree-sitter
        unstable.nodejs_22
        unstable.lua
        unstable.luarocks

        # ocaml
        ocaml
        dune_3
        opam
        ocamlPackages.ocamlformat
        ocamlPackages.utop

        # rust
        rustup

        # cpp
        clang-tools

        # nix
        nil
    ] ++ (with pkgs.llvmPackages_latest; [
            lldb
            libcxx
            libllvm
            clang
	  ]);
}
