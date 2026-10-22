#!/usr/bin/env bash
# Installiert den Live Stream Listener für den aktuellen Benutzer (Linux).
# Aufruf:  bash install.sh
set -e

SRC="$(cd "$(dirname "$0")" && pwd)"
APP_DIR="$HOME/.local/share/live-stream-listener"
VENV="$APP_DIR/venv"
BIN="$HOME/.local/bin"

echo "==> Systempakete (mpv, pipx, Python-venv, pactl) …"
if command -v apt >/dev/null 2>&1; then
    sudo apt update
    sudo apt install -y mpv pipx python3-venv python3-pip pulseaudio-utils \
        libxcb-cursor0 libxcb-xinerama0
elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -S --needed --noconfirm mpv python-pipx python libpulse
elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y mpv pipx python3 pulseaudio-utils
else
    echo "Paketmanager nicht erkannt. Bitte mpv, pipx, python3-venv und pactl selbst installieren."
fi

echo "==> streamlink (aktuelle Version über pipx) …"
pipx install streamlink || pipx upgrade streamlink || true
pipx ensurepath || true

echo "==> Programm einrichten …"
mkdir -p "$APP_DIR" "$BIN" "$HOME/.local/share/applications"
python3 -m venv "$VENV"
"$VENV/bin/pip" install --upgrade pip
"$VENV/bin/pip" install -r "$SRC/requirements.txt"
cp "$SRC/live-stream-listener.py" "$APP_DIR/"

cat > "$BIN/live-stream-listener" << LAUNCHER
#!/usr/bin/env bash
export PATH="\$HOME/.local/bin:\$PATH"
exec "$VENV/bin/python" "$APP_DIR/live-stream-listener.py" "\$@"
LAUNCHER
chmod +x "$BIN/live-stream-listener"

cat > "$HOME/.local/share/applications/live-stream-listener.desktop" << DESKTOP
[Desktop Entry]
Type=Application
Name=Live Stream Listener
Comment=Spielt nur den Ton von Livestreams ab
Exec=$BIN/live-stream-listener
Icon=audio-headphones
Categories=AudioVideo;Audio;
DESKTOP

echo
echo "Fertig. Starten über das Anwendungsmenü ('Live Stream Listener')"
echo "oder im Terminal mit:  live-stream-listener"
echo "Falls der Befehl nicht gefunden wird: Terminal neu öffnen."
