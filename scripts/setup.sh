#!/usr/bin/env bash

set -eou pipefail

if command -v nix >/dev/null 2>&1; then
  echo "🔍 Nix is found"
else
  echo "🔍  Nix is not installed"
  echo "⏬ Installing Nix..."
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
  echo "✅ Nix installation completed!"
fi

set +eou
# shellcheck disable=SC1091
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
set -eou

echo "⏬ Installing Home Manager..."
nix run home-manager/release-24.11 -- init --switch
echo "✅ Home Manager completed!"

echo "🗑 Removing default configuration..."
rm -rf ~/.config/home-manager
echo "✅ Remove existing Home Manager configuration!"

echo "🔄 Syncing Home Manager..."
nix run nixpkgs#git -- clone https://github.com/AtomiCloud/home-manager.git ~/.config/home-manager
echo "✅ Synced Home Manager!"

curl -L https://raw.githubusercontent.com/AtomiCloud/home-manager/main/scripts/configure.sh | sh
