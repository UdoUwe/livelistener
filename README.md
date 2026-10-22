Für alle wahren Udo U. Fans. DIe App gibt den Ton von Udo's livestream wieder wenn er live ist, und Udo's ungewaschener Mund bewegt sich.
Es können auch andere Stream's von twitch, Kick, YT, TikTok wiedergegeben werden.
Das Gif kann auch getauscht werden, wenn euch Udo nicht gefällt.
Unter Optionen kann man Streamer hinzufügen, entfernen. Unten alles beschrieben.
Alles vibecodeing.                              
                                                  



# Live Stream Listener

Kleine Desktop-App für Linux, die eine Liste von Streamern überwacht und **nur den Ton**
abspielt, sobald jemand live geht. Ein animiertes GIF („Kopf") bewegt sich, wenn Audio kommt.

Unterstützte Plattformen: **Kick, Twitch, YouTube, TikTok** (über [streamlink](https://streamlink.github.io)).



## Funktionen

- Streamerliste mit Live-Erkennung (Prüfung alle 30 Sekunden)
- Automatisches Abspielen des **obersten** Streamers, der live ist (Reihenfolge per Drag & Drop)
- Nur Audio (mpv ohne Video), Lautstärkeregler und Mute
- Auswahl des Audio-Ausgabegeräts
- Rahmenloses, durchsichtiges Fenster; Bedienleiste erscheint beim Darüberfahren
- Eigenes GIF wählbar (max. 450×450 Pixel), GIF reagiert auf einstellbaren Pegel
- Kopfgröße 100 / 75 / 50 / 25 %, „Immer im Vordergrund"
- Button zum Aktualisieren von streamlink

## Installation

### Automatisch (Ubuntu/Debian, Arch, Fedora)

```bash
git clone https://github.com/DEIN-NAME/live-stream-listener.git
cd live-stream-listener
bash install.sh
```

Das Script installiert mpv, pipx und die nötigen Systempakete, holt die aktuelle
streamlink-Version über pipx, richtet eine eigene Python-Umgebung mit PyQt5 ein und legt einen
Menüeintrag sowie den Befehl `live-stream-listener` an. Es benötigt `sudo` für die Systempakete.

### Manuell

1. Systempakete: `mpv`, `pipx`, Python 3 mit `venv`, `pactl` (Paket `pulseaudio-utils` bzw. `libpulse`)
2. streamlink (aktuelle Version, wichtig für Kick/TikTok):
   ```bash
   pipx install streamlink
   pipx ensurepath
   ```
3. Python-Umgebung und Start:
   ```bash
   python3 -m venv venv
   venv/bin/pip install -r requirements.txt
   venv/bin/python live-stream-listener.py
   ```

Falls Qt mit „Could not load the Qt platform plugin xcb" abbricht:
`sudo apt install libxcb-cursor0 libxcb-xinerama0`

## Bedienung

- **Fenster verschieben:** auf das Bild klicken und ziehen
- **Maus über das Bild:** Lautstärke, Mute, Kanal im Browser öffnen, Optionen
- **Rechtsklick:** „Immer im Vordergrund", „Beenden" (auch Strg+Q)

### Streamer hinzufügen (Optionen → Eingabefeld → „Folgen")

| Plattform | Eingabe |
|---|---|
| Kick | Link oder nur der Name (ohne Angabe gilt Kick) |
| Twitch | Link oder `twitch:name` |
| YouTube | Kanal-Link oder `@handle` |
| TikTok | Link oder `tiktok:@name` |

Die Reihenfolge der Liste ist die Priorität: Sind mehrere gleichzeitig live, wird der oberste
abgespielt. Ein Doppelklick startet einen Streamer von Hand.

Einstellungen liegen in `~/.config/live-stream-listener/`.

## Aktualisieren

- Die App: neue Version herunterladen und `bash install.sh` erneut ausführen.
- streamlink (wenn eine Plattform nicht mehr erkannt wird): Optionen → „streamlink aktualisieren"
  oder `pipx upgrade streamlink`.

## Fehlerbehebung

| Problem | Lösung |
|---|---|
| Streamer wird nicht als live erkannt | `streamlink --version` prüfen, streamlink aktualisieren; testen mit `streamlink https://kick.com/NAME best` |
| Kein Ton / falsches Gerät | In den Optionen die Audio-Ausgabe wählen; mpv separat testen |
| GIF reagiert nicht auf Ton | Pegel-Schwelle in den Optionen anpassen; benötigt ein mpv, das Audiopegel liefert |
| Fenster bleibt unsichtbar/schwarz | Ein Compositor wird für das durchsichtige Fenster benötigt |

Plattformen ändern ihre Schnittstellen gelegentlich. Dann kann die Erkennung ausfallen, bis
streamlink angepasst wurde. Besonders YouTube und TikTok sind weniger zuverlässig.

## Deinstallieren

```bash
rm -rf ~/.local/share/live-stream-listener ~/.config/live-stream-listener
rm -f ~/.local/bin/live-stream-listener ~/.local/share/applications/live-stream-listener.desktop
```

## Lizenz

GPL-3.0-or-later, siehe `LICENSE` (PyQt5 steht unter GPLv3).

## Hinweis
Udo ballert Babyies
