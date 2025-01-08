{config, pkgs, unstable, ...}: {

    # nixpkgs.overlays = [ rust-overlay ];
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

        # go
        go

        # rust
        rustup
        cargo
        # rust-bin.stable.latest.default

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
