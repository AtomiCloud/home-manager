{ config, pkgs, pkgs-2411, atomi, atomi-upstream, profile, ... }:

atomi-upstream.mutate {
  inherit profile;
  nixpkgs = pkgs;
  outputs = import ./home-template.nix
    {
      inherit config pkgs atomi profile pkgs-2411;
    };
} 
