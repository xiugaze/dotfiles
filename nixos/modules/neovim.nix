{config, pkgs, ...}: {

    environment.systemPackages = with pkgs; [
    # needed for neovim
        unstable.neovim
        unstable.tree-sitter
        unstable.nodejs_22
        unstable.lua
        unstable.luarocks
        imagemagick
        luajitPackages.magick

        lua-language-server
        ghostscript

        # ocaml
        ocaml
        dune_3
        opam
        ocamlPackages.ocamlformat
        ocamlPackages.utop

        # python
        basedpyright
        ruff

        # web
        superhtml

        # java
        jdt-language-server

        # go
        go
        gopls

        # latex
        texlab

        # cpp
        clang-tools

        # nix
        nil
        nixfmt-rfc-style

        unstable.zig
        unstable.zls
    ] ++ (with pkgs.llvmPackages_latest; [
        lldb
        libcxx
        libllvm
        clang
      ]);
}
