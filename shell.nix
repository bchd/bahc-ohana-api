{
  lib ? import <lib> {},
  pkgs ? import (fetchTarball https://github.com/NixOS/nixpkgs/archive/25.11.zip) {}
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
    pkgs.nodejs_22
    pkgs.yarn
  ];

  inputs = basePackages
    ++ [ pkgs.bashInteractive ]
    ++ pkgs.lib.optionals pkgs.stdenv.isLinux [ ];

in pkgs.mkShell {
  buildInputs = inputs;

  shellHook = ''
export FREEDESKTOP_MIME_TYPES_PATH="${pkgs.shared-mime-info}/share/mime/packages/freedesktop.org.xml";

# Disable this for sassc to compile properly
# See https://github.com/sass/sassc-ruby/issues/148#issuecomment-644450274
bundle config set build.sassc --disable-lto

# Point psych's native build at nix-provided libyaml so YAML works at runtime.
bundle config set build.psych --with-libyaml-dir=${pkgs.libyaml}
  '';

}
