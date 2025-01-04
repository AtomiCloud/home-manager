#!/usr/bin/env nix
#! nix shell nixpkgs#coreutil nixpkgs#bash --command bash
# shellcheck shell=bash

profile_user="$USER"
profile_arch="$(uname -m)"
[ "$profile_arch" == 'arm64' ] && profile_arch="aarch64"
profile_kernel="$(uname -s | tr '[:upper:]' '[:lower:]')"

echo "❓ Enter your Github Email: "
read -r profile_email
echo "❓ Enter your Github Username: "
read -r profile_username

profile=$(
  cat <<EOF
[
  {
    user = "${profile_user}";
    email = "${profile_email}";
    gituser = "${profile_username}";
    apps = true;
    arch = "${profile_arch}";
    kernel = "${profile_kernel}";
  }
]
EOF
)

echo "⬆️ Updating profile..."
echo "$profile" >~/.config/home-manager/profiles.nix
echo "✅ Profile Updated"

echo "🔥 Initialize Home Manager..."
nix run home-manager/release-24.11 -- switch
# shellcheck disable=SC1090
source ~/.zshrc
echo "✅ Home Manager Switched!"

echo "🗑️ Removing Git from home-manager"
rm -rf ~/.config/home-manager/.git
echo "✅ Git removed"

echo "🆕 Initializing new git"
git init ~/.config/home-manager
echo "✅ Git initialized"
