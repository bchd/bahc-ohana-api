{
  lib ? import <lib> {},
  pkgs ? import (fetchTarball https://github.com/NixOS/nixpkgs/archive/ed62dec024ef83ed2f37a73f2fab6c9760767383.zip) {}
}:

let

  # define packages to install with special handling for OSX
  basePackages = [
    pkgs.gnumake
    pkgs.gcc
    pkgs.readline
    pkgs.zlib
    pkgs.libxml2
    pkgs.libiconv
    pkgs.libyaml
    pkgs.openssl
    pkgs.curl
    pkgs.git
    pkgs.shared-mime-info

    pkgs.postgresql_15

    pkgs.ruby_3_4
    pkgs.bundler
    pkgs.nodejs_18
    (pkgs.yarn.override { nodejs = pkgs.nodejs_18; })
  ];

  inputs = basePackages
    ++ [ pkgs.bashInteractive ]
    ++ pkgs.lib.optionals pkgs.stdenv.isLinux [ ]
    ++ pkgs.lib.optionals pkgs.stdenv.isDarwin (with pkgs.darwin.apple_sdk.frameworks; [
        CoreFoundation
        CoreServices
      ]);

in pkgs.mkShell {
  buildInputs = inputs;

  shellHook = ''
export FREEDESKTOP_MIME_TYPES_PATH="${pkgs.shared-mime-info}/share/mime/packages/freedesktop.org.xml";

# Disable this for sassc to compile properly
# See https://github.com/sass/sassc-ruby/issues/148#issuecomment-644450274
bundle config build.sassc --disable-lto
  '';

}
