#!/bin/zsh
set -e

echo "[*] Starting config setup..."

if ! command -v brew >/dev/null 2>&1; then
	echo "[*] Installing Homebrew..."

	NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	if [[ "$OSTYPE" == "linux-gnu"* ]]; then
		echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>~/.zprofile
		eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
	elif [[ "$OSTYPE" == "darwin"* ]]; then
		echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
		eval "$(/opt/homebrew/bin/brew shellenv)"
	fi
else
	echo "[✓] Homebrew is already installed."
	if [[ "$OSTYPE" == "linux-gnu"* ]]; then
		eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
	elif [[ "$OSTYPE" == "darwin"* ]]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	fi
fi

if [[ -f "$HOME/config/Brewfile" ]]; then
	echo "[*] Installing packages from Brewfile..."
	brew bundle --file="$HOME/config/Brewfile"
else
	echo "[!] No Brewfile found at $HOME/config/Brewfile"
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

echo "[✓] config setup complete."
