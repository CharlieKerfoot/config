#!/bin/bash

if ! command -v brew >/dev/null 2>&1; then
	echo "[*] Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
	echo "[✓] Homebrew is already installed."
fi

echo "Installing packages from Brewfile..."
brew bundle --file="$HOME/config/Brewfile"

if [[ "$SHELL" != *zsh ]]; then
  echo "[*] Changing default shell to zsh..."
  ZSH_PATH="$(command -v zsh)"

  if ! grep -q "$ZSH_PATH" /etc/shells; then
    echo "[*] Adding $ZSH_PATH to /etc/shells..."
    echo "$ZSH_PATH" | sudo tee -a /etc/shells
  fi

  chsh -s "$ZSH_PATH"
  echo "[✓] Default shell changed to zsh. You may need to log out and back in."
else
  echo "[✓] Default shell is already zsh."
fi
