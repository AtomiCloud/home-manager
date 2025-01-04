#!/usr/bin/env bash

set -eou pipefail

echo "⏬ Installing Nix..."
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
echo "✅ Nix installation completed!"

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
