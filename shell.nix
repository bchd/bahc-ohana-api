# change the pkgs import to a tag when there is a 22.XX version
# at the moment we need a specific SHA to be able to use m1 chromedriver
{
  lib ? import <lib> {},
  pkgs ? import (fetchTarball https://github.com/NixOS/nixpkgs/archive/a40082270194f2068e6cfb4d26d53d511fc8c34b.zip) {}
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
    pkgs.openssl
    pkgs.curl
    pkgs.git
    pkgs.shared-mime-info

    pkgs.postgresql_14

    pkgs.ruby_2_7
    pkgs.bundler
    pkgs.nodejs-16_x
    pkgs.yarn
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
export FREEDESKTOP_MIME_TYPES_PATH="${pkgs.shared_mime_info}/share/mime/packages/freedesktop.org.xml";

# Disable this for sassc to compile properly
# See https://github.com/sass/sassc-ruby/issues/148#issuecomment-644450274
bundle config build.sassc --disable-lto
  '';
}
