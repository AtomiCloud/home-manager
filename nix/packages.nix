{ pkgs, atomi, pkgs-2411 }:
let

  all = {
    atomipkgs = (
      with atomi;
      {
        inherit
          pls;
      }
    );
    nix-2411 = (
      with pkgs-2411;
      {
        inherit
          gomplate
          coreutils
          gnugrep
          bash
          jq

          git
          infisical

          treefmt
          shellcheck
          ;
      }
    );
  };
in
with all;
nix-2411 //
atomipkgs
