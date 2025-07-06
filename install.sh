#!/bin/zsh
set -e

echo "[*] Starting dotfiles setup..."

if ! command -v brew >/dev/null 2>&1; then
  echo "[*] Installing Homebrew..."

  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo 'eval "$($HOME/.linuxbrew/bin/brew shellenv)"' >>~/.zprofile
    eval "$($HOME/.linuxbrew/bin/brew shellenv)"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  echo "[✓] Homebrew is already installed."
fi

if [[ -f "$HOME/dotfiles/Brewfile" ]]; then
  echo "[*] Installing packages from Brewfile..."
  brew bundle --file="$HOME/dotfiles/Brewfile"
else
  echo "[!] No Brewfile found at $HOME/dotfiles/Brewfile"
fi

if [[ "$SHELL" != *zsh ]]; then
  ZSH_PATH="$(command -v zsh)"
  echo "[*] Changing default shell to: $ZSH_PATH"

  if ! grep -q "$ZSH_PATH" /etc/shells; then
    echo "[*] Adding $ZSH_PATH to /etc/shells..."
    echo "$ZSH_PATH" | sudo tee -a /etc/shells
  fi

  chsh -s "$ZSH_PATH" || echo "[!] chsh failed. You may need to run: sudo chsh -s $ZSH_PATH $USER"
else
  echo "[✓] Default shell is already zsh."
fi

echo "[✓] Dotfiles setup complete."
