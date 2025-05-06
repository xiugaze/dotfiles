{ pkgs, ...}: {
  imports = [./global];

  home.sessionVariables = {
    TERM="xterm-256color";
  };
}
