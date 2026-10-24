#!/usr/bin/env bash
# livelistener – Installer für Linux
#
#   bash install.sh              installieren / aktualisieren
#   bash install.sh --no-deps    ohne Systempakete (mpv, pipx, …) – nur App einrichten
#   bash install.sh --uninstall  App wieder entfernen (Einstellungen bleiben erhalten)
#
# Was passiert:
#   1. Systempakete installieren, falls nötig: mpv, pipx, pactl, pkill, Python-venv
#   2. streamlink per pipx installieren
#   3. App nach ~/.local/share/livelistener kopieren, eigene Python-Umgebung (venv)
#      anlegen und requirements.txt installieren
#   4. Startbefehl "livelistener" und Menüeintrag samt Icon anlegen
set -euo pipefail

APP="livelistener"
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}"
APP_DIR="$DATA_DIR/$APP"
BIN_DIR="$HOME/.local/bin"
DESKTOP_FILE="$DATA_DIR/applications/$APP.desktop"
ICON_FILE="$DATA_DIR/icons/hicolor/256x256/apps/$APP.png"
LAUNCHER="$BIN_DIR/$APP"

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m  %s\n' "$*" >&2; }
die()  { printf '\033[1;31mFehler:\033[0m %s\n' "$*" >&2; exit 1; }

SKIP_DEPS=0
UNINSTALL=0
for arg in "$@"; do
    case "$arg" in
        --no-deps)   SKIP_DEPS=1 ;;
        --uninstall) UNINSTALL=1 ;;
        -h|--help)   sed -n '2,13p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
        *)           die "Unbekannte Option: $arg (siehe --help)" ;;
    esac
done

# --- Deinstallation -----------------------------------------------------------
if [ "$UNINSTALL" -eq 1 ]; then
    info "Entferne $APP …"
    rm -rf "$APP_DIR"
    rm -f "$LAUNCHER" "$DESKTOP_FILE" "$ICON_FILE"
    command -v update-desktop-database >/dev/null 2>&1 \
        && update-desktop-database "$DATA_DIR/applications" >/dev/null 2>&1 || true
    echo "Fertig. Einstellungen bleiben in ~/.config/$APP erhalten (bei Bedarf manuell löschen)."
    echo "streamlink wurde nicht entfernt (falls gewünscht: pipx uninstall streamlink)."
    exit 0
fi

[ "$(uname -s)" = "Linux" ] || die "livelistener läuft nur unter Linux (benötigt pactl, pkill, mpv)."
[ "$(id -u)" -ne 0 ] || die "Bitte nicht als root ausführen – die App wird für den aktuellen Benutzer installiert."
[ -f "$SRC_DIR/$APP.py" ] || die "$APP.py nicht gefunden. Bitte install.sh im Projektordner ausführen."
[ -f "$SRC_DIR/requirements.txt" ] || die "requirements.txt nicht gefunden."

# --- 1. Systempakete ----------------------------------------------------------
install_system_packages() {
    local sudo_cmd=""
    if [ "$(id -u)" -ne 0 ]; then
        command -v sudo >/dev/null 2>&1 || die "sudo fehlt. Installiere mpv, pipx, pactl und python3-venv manuell und starte mit --no-deps."
        sudo_cmd="sudo"
    fi

    if command -v apt-get >/dev/null 2>&1; then
        info "Installiere Systempakete (apt) …"
        $sudo_cmd apt-get update
        $sudo_cmd apt-get install -y mpv pipx python3 python3-venv python3-pip pulseaudio-utils procps
    elif command -v dnf >/dev/null 2>&1; then
        info "Installiere Systempakete (dnf) …"
        $sudo_cmd dnf install -y mpv pipx python3 python3-pip pulseaudio-utils procps-ng
    elif command -v pacman >/dev/null 2>&1; then
        info "Installiere Systempakete (pacman) …"
        $sudo_cmd pacman -S --needed --noconfirm mpv python-pipx python python-pip libpulse procps-ng
    elif command -v zypper >/dev/null 2>&1; then
        info "Installiere Systempakete (zypper) …"
        $sudo_cmd zypper --non-interactive install mpv python3-pipx python3 python3-pip pulseaudio-utils procps
    else
        warn "Paketmanager nicht erkannt. Bitte manuell installieren: mpv, pipx, pactl, pkill, python3-venv"
        warn "Danach: ./install.sh --no-deps"
        exit 1
    fi
}

missing=()
for cmd in mpv pipx pactl pkill python3; do
    command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
done

if [ "$SKIP_DEPS" -eq 1 ]; then
    [ "${#missing[@]}" -eq 0 ] || die "Fehlende Programme: ${missing[*]}"
elif [ "${#missing[@]}" -gt 0 ] || ! python3 -m venv --help >/dev/null 2>&1; then
    install_system_packages
else
    info "Systempakete sind bereits vorhanden."
fi

python3 -c 'import sys; sys.exit(0 if sys.version_info >= (3, 8) else 1)' \
    || die "Python 3.8 oder neuer wird benötigt."

# --- 2. streamlink ------------------------------------------------------------
# Aktuelle streamlink-Versionen brauchen Python >= 3.10. Ist das System-Python älter
# (z. B. Ubuntu 20.04), holt uv ein eigenes Python und installiert streamlink damit.
export PATH="$BIN_DIR:$PATH"
has_streamlink() { grep -Eq '^[[:space:]]*(package[[:space:]]+)?streamlink([[:space:]]|$)' <<<"$1"; }

if python3 -c 'import sys; sys.exit(0 if sys.version_info >= (3, 10) else 1)'; then
    pipx_list="$(pipx list 2>/dev/null || true)"
    if has_streamlink "$pipx_list"; then
        info "streamlink ist bereits per pipx installiert – aktualisiere …"
        pipx upgrade streamlink || warn "Aktualisierung von streamlink fehlgeschlagen (wird beim App-Start erneut versucht)."
    else
        info "Installiere streamlink (pipx) …"
        # --force: überschreibt einen übrig gebliebenen, unvollständigen pipx-Ordner
        pipx install --force streamlink \
            || warn "streamlink konnte nicht per pipx installiert werden. Bitte manuell: pipx install --force streamlink"
    fi
    pipx ensurepath >/dev/null 2>&1 || true
else
    warn "Dein Python ist älter als 3.10 – für ein aktuelles streamlink nutze ich uv (es lädt ein eigenes Python)."
    UV="$(command -v uv || true)"
    [ -n "$UV" ] || { [ -x "$BIN_DIR/uv" ] && UV="$BIN_DIR/uv"; } || true
    if [ -z "${UV:-}" ]; then
        if command -v curl >/dev/null 2>&1; then
            info "Installiere uv …"
            curl -LsSf https://astral.sh/uv/install.sh | sh || warn "uv konnte nicht installiert werden."
            [ -x "$BIN_DIR/uv" ] && UV="$BIN_DIR/uv"
        else
            warn "curl fehlt (sudo apt install curl), uv kann nicht installiert werden."
        fi
    fi
    if [ -n "${UV:-}" ] && [ -x "$UV" ]; then
        pipx_list="$(pipx list 2>/dev/null || true)"
        if has_streamlink "$pipx_list"; then
            info "Entferne das alte streamlink aus pipx …"
            pipx uninstall streamlink || true
        fi
        info "Installiere streamlink (uv) …"
        "$UV" tool install --force --python 3.12 streamlink \
            || warn "streamlink konnte nicht per uv installiert werden. Bitte manuell: uv tool install --force --python 3.12 streamlink"
    fi
fi

# --- 3. App + virtuelle Umgebung ---------------------------------------------
info "Installiere $APP nach $APP_DIR …"
mkdir -p "$APP_DIR"
install -m 644 "$SRC_DIR/$APP.py" "$APP_DIR/$APP.py"
install -m 644 "$SRC_DIR/requirements.txt" "$APP_DIR/requirements.txt"

if [ ! -x "$APP_DIR/venv/bin/python" ]; then
    python3 -m venv "$APP_DIR/venv"
fi
"$APP_DIR/venv/bin/python" -m pip install --upgrade pip >/dev/null
"$APP_DIR/venv/bin/python" -m pip install -r "$APP_DIR/requirements.txt"

# --- 4. Startbefehl, Icon, Menüeintrag ---------------------------------------
info "Lege Startbefehl und Menüeintrag an …"
mkdir -p "$BIN_DIR" "$(dirname "$DESKTOP_FILE")" "$(dirname "$ICON_FILE")"

cat > "$LAUNCHER" <<LAUNCH
#!/usr/bin/env bash
# Erzeugt von install.sh. ~/.local/bin muss im PATH sein, damit streamlink gefunden wird.
export PATH="$BIN_DIR:\$PATH"
exec "$APP_DIR/venv/bin/python" "$APP_DIR/$APP.py" "\$@"
LAUNCH
chmod 755 "$LAUNCHER"

# Icon: aus dem Projekt übernehmen, sonst aus dem in der App eingebetteten Icon erzeugen
if [ -f "$SRC_DIR/assets/$APP.png" ]; then
    install -m 644 "$SRC_DIR/assets/$APP.png" "$ICON_FILE"
else
    "$APP_DIR/venv/bin/python" - "$APP_DIR/$APP.py" "$ICON_FILE" <<'PY'
import base64, re, sys
src = open(sys.argv[1], encoding="utf-8").read()
data = re.search(r'APP_ICON_B64 = """(.*?)"""', src, re.S).group(1)
open(sys.argv[2], "wb").write(base64.b64decode("".join(data.split())))
PY
fi

cat > "$DESKTOP_FILE" <<DESKTOP
[Desktop Entry]
Type=Application
Name=livelistener
Comment=Spielt den Ton von Livestreams ab, sobald jemand live ist
Exec=$LAUNCHER
Icon=$APP
Terminal=false
Categories=AudioVideo;Audio;Player;
StartupWMClass=$APP
DESKTOP

command -v update-desktop-database >/dev/null 2>&1 \
    && update-desktop-database "$DATA_DIR/applications" >/dev/null 2>&1 || true
command -v gtk-update-icon-cache >/dev/null 2>&1 \
    && gtk-update-icon-cache -q -t "$DATA_DIR/icons/hicolor" >/dev/null 2>&1 || true

echo
info "Fertig! Starte die App über das Anwendungsmenü oder mit:  $APP"
case ":$PATH:" in
    *":$BIN_DIR:"*) ;;
    *) warn "$BIN_DIR ist nicht in deinem PATH. Melde dich neu an, damit der Befehl '$APP' im Terminal funktioniert." ;;
esac
