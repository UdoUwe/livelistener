<h1 align="center">U.D.O livelistener</h1>

Der U.D.O listener für alle Udo Fans. Sobald Udo live geht wird die Audio aus seinem Steam abgespielt. Und der Mund von Udo bewegt sich. Alles cuckcoding, davorsetzen und zuschauen. Anständige Beschreibung unten. 

<p align="center">
<img width="424" height="768" alt="UdoDemo" src="https://github.com/user-attachments/assets/b625f2a2-2905-423d-9eed-35e6a406b57b" />



<h1 align="center">livelistener</h1>

<p align="center">
  Überwacht deine Lieblings-Streamer und spielt <b>nur den Ton</b> ab, sobald jemand live ist.<br>
  Kick · Twitch · YouTube · TikTok
</p>


---

## Funktionen

- **Mehrere Plattformen:** Kick, Twitch, YouTube und TikTok in einer Liste
- **Automatische Wiedergabe:** Alle 30 Sekunden wird geprüft, wer live ist. Läuft ein Streamer, wird nur der Ton abgespielt (kein Video, wenig Last). Sind mehrere live, startet der oberste in der Liste
- **Sortieren per Drag & Drop:** Die Reihenfolge der Liste legt die Priorität fest
- **Animiertes GIF** im Fenster, das sich bewegt, sobald der Ton einen einstellbaren Pegel überschreitet. Eigenes GIF wählbar (max. 1024×1024 Pixel)
- **Steuerung** direkt unter dem GIF: Lautstärke, Pause/Play, Stumm, Stream im Browser öffnen, Optionen
- **Audio-Ausgabe** frei wählbar (PipeWire/PulseAudio)
- **Dark Mode**
- **Automatisches streamlink-Update** bei jedem Start im Hintergrund (wenn über pipx installiert)
- **Tray-Icon:** Die App läuft im Hintergrund weiter, `Strg+Q` beendet sie

## Voraussetzungen

- Linux mit PipeWire oder PulseAudio
- Python 3.8 oder neuer
- [mpv](https://mpv.io/) (Wiedergabe)
- [streamlink](https://streamlink.github.io/) (Stream-Erkennung)
- PyQt5 (Oberfläche)
- `pactl` und `pkill` (meist vorinstalliert)

Der Installer erledigt das alles automatisch.

## Installation

```bash
git clone https://github.com/UdoUwe/livelistener
cd livelistener
./install.sh
```

Der Installer unterstützt `apt` (Debian, Ubuntu, Mint), `dnf` (Fedora), `pacman` (Arch) und `zypper` (openSUSE). Er

1. installiert fehlende Systempakete (dafür wird `sudo` gefragt),
2. installiert `streamlink` per `pipx`,
3. richtet die App samt eigener Python-Umgebung unter `~/.local/share/livelistener` ein,
4. legt den Startbefehl `livelistener` und einen Eintrag im Anwendungsmenü an.

Optionen:

| Befehl | Wirkung |
| --- | --- |
| `./install.sh --no-deps` | keine Systempakete installieren (wenn du mpv, pipx usw. schon hast) |
| `./install.sh --uninstall` | App wieder entfernen (Einstellungen bleiben erhalten) |

Nach der Installation startest du livelistener über das Anwendungsmenü oder mit `livelistener`.

### Manuell starten (ohne Installer)

```bash
python3 -m venv .venv
.venv/bin/pip install -r requirements.txt
pipx install streamlink          # und mpv über den Paketmanager installieren
.venv/bin/python livelistener.py
```

## Benutzung

1. Fahre mit der Maus über das Fenster und klicke auf das Zahnrad, um die **Optionen** zu öffnen.
2. Füge einen Streamer hinzu und klicke auf **Folgen**:

   | Plattform | Eingabe |
   | --- | --- |
   | Kick | Link oder nur der Name, z. B. `name` |
   | Twitch | Link oder `twitch:name` |
   | YouTube | Link oder `@handle` |
   | TikTok | Link oder `tiktok:@name` |

3. Lass **Automatisch abspielen** aktiviert. Sobald ein Streamer aus deiner Liste live ist, startet der Ton.
4. Doppelklick auf einen Eintrag spielt ihn sofort ab.

Der Knopf **Pause/Play** pausiert den laufenden Stream, ein zweiter Klick spielt ihn wieder ab. Die automatische Wiedergabe bleibt an, startet den pausierten Streamer aber erst wieder, wenn er zwischendurch offline war.

## Einstellungen

Alle Einstellungen werden automatisch in `~/.config/livelistener/config.json` gespeichert. Ein eigenes GIF wird dort als `custom.gif` kopiert, das Original darf also gelöscht werden.

## Fehlerbehebung

- **Kein Tray-Icon unter GNOME:** GNOME zeigt Tray-Icons nur mit der Erweiterung *AppIndicator and KStatusNotifierItem Support*.
- **„streamlink nicht gefunden“ / kein Ton:** Prüfe im Terminal `streamlink --version` und `mpv --version`. Bei streamlink muss `~/.local/bin` im `PATH` sein (`pipx ensurepath`, danach neu anmelden).
- **Kein Streamer wird als live erkannt:** Teste im Terminal `streamlink --stream-url https://kick.com/NAME audio_only,worst`. streamlink wird bei jedem Start der App automatisch aktualisiert (nur bei Installation über pipx). Du kannst es auch manuell mit `pipx upgrade streamlink` aktualisieren.
- **Falsches Audiogerät:** Wähle in den Optionen unter *Audio-Ausgabe* das gewünschte Gerät.

