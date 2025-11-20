{ config, pkgs, lib, inputs, ... }:

with lib;

let
  cfg = config.nvim;  # Shorthand for the module's options
in
{
  options = {
    nvim = {
      enable = mkEnableOption "Neovim and language support";

      lang = {
        ocaml = mkEnableOption "OCaml packages";
        python = mkEnableOption "python";
      };
    };
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      EDITOR = "nvim";
    };

    home.packages = with pkgs; [
      # Always include these base packages when nvim.enable = true
      unstable.neovim
      unstable.tree-sitter
      unstable.lua
      unstable.luarocks
      lua-language-server
      ghostscript
    ] ++ optionals cfg.lang.python (with pkgs; [
        basedpyright
        ruff
    ]) ++ optionals cfg.lang.ocaml (with pkgs; [
      ocaml
      dune_3
      opam
      ocamlPackages.ocamlformat
      ocamlPackages.utop
    ]);
  };
}
            #
            # # ocaml
            #
            # # python
            #
            # # web
            # superhtml
            #
            # # java
            # jdt-language-server
            #
            # # go
            # go
            # gopls
            #
            # # latex
            # texlab
            #
            # # cpp
            # clang-tools
            #
            # # nix
            # nil
            # nixfmt-rfc-style
            #
            # unstable.zig
            # unstable.zls
