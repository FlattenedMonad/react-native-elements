{ pkgs ? (
   let 
    hostPkgs = import <nixpkgs> {};
    pinnedPkgs = hostPkgs.fetchFromGitHub {
      owner = "NixOS";
      repo = "nixpkgs-channels";
      # nixos-unstable as of 2017-11-13T08:53:10-00:00
      rev = "08d245eb31a3de0ad73719372190ce84c1bf3aee";
      sha256 = "1g22f8r3l03753s67faja1r0dq0w88723kkfagskzg9xy3qs8yw8";
    };
  in
  import pinnedPkgs {}
 )
}:
let
  node=pkgs.nodejs-8_x;
  callPackage = path: overrides:
    let f = import path;
    in f ((builtins.intersectAttrs (builtins.functionArgs f) pkgs) // overrides);
  yarn = pkgs.yarn.override{nodejs=pkgs.nodejs-8_x;};
in
pkgs.stdenv.mkDerivation {
  name = "resume";
  src = builtins.filterSource
    (path: type:
      baseNameOf path != ".git" &&
      baseNameOf path != "output" &&
      baseNameOf path != "result")
    ./.;
  buildInputs = [
    yarn
    pkgs.mozjpeg
    node
  ];
  buildPhase = ''
	yarn
  '';
}
