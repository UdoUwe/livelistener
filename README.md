<h1 align="center">U.D.O livelistener</h1>
<p align="center">
Der U.D.O.-Listener für alle Udo-Fans. Sobald ein Streamer live geht, wird die Audio aus seinem Steam abgespielt. Und der Mund von Udo bewegt sich. Alles cuckcoding, hinsetzen und zuschauen. Das Standard-GIF ist KI-generiert und stellt keine Person aus dem realen Leben dar.

<p align="center">
<img width="368" height="684" alt="50fe0afa-0ea9-4620-9c4c-295b4112b647" src="https://github.com/user-attachments/assets/ff986432-7fa3-4508-a229-c9c30ed51a19" />




<h1 align="center">livelistener</h1>

<p align="center">
  Überwacht deine Lieblings-Streamer und spielt <b>nur den Ton</b> ab, sobald jemand live ist.<br>
  Kick · Twitch · YouTube · TikTok
</p>


---

## Funktionen

- **Mehrere Plattformen:** Kick, Twitch, YouTube und TikTok in einer Liste
- **Automatische Wiedergabe:** Alle 30 Sekunden wird geprüft, wer live ist. Läuft ein Streamer, wird nur der Ton         abgespielt (kein Video, wenig Last). Sind mehrere live, wird der oberste in der Liste abgespielt
- **Sortieren per Drag & Drop:** Die Reihenfolge der Liste legt die Priorität fest
- **Animiertes GIF** im Fenster, das sich bewegt, sobald der Ton einen einstellbaren Pegel überschreitet. Eigenes GIF wählbar (max. 1024×1024 Pixel)
- **Große Monitore (4K):** Die GIF-Größe lässt sich bis 200 % stellen. Für ein scharfes Bild bei großer Anzeige lohnt sich ein GIF mit mehr Pixeln
- **Steuerung** direkt unter dem GIF: Lautstärke, Pause/Play, Stumm, Stream im Browser öffnen, Optionen
- **Audio-Ausgabe** frei wählbar (PipeWire/PulseAudio)
- **Dark Mode**
- **Automatisches streamlink-Update** bei jedem Start im Hintergrund (wenn über pipx installiert)
- **Tray-Icon:** Die App läuft im Hintergrund weiter, `Strg+Q` beendet sie

## Voraussetzungen

- Linux mit PipeWire oder PulseAudio, oder Windows 10/11 (siehe [Windows](#windows))
- Python 3.8 oder neuer
- [mpv](https://mpv.io/) (Wiedergabe)
- [streamlink](https://streamlink.github.io/) (Stream-Erkennung)
- PyQt5 (Oberfläche)
- `pactl` und `pkill` (meist vorinstalliert)

Der Installer erledigt das.

## Installation (Linux)

```bash
git clone https://github.com/UdoUwe/livelistener.git
cd livelistener
bash install.sh
```

Der Installer unterstützt `apt` (Debian, Ubuntu, Mint), `dnf` (Fedora), `pacman` (Arch) und `zypper` (openSUSE). Er

1. installiert fehlende Systempakete (dafür wird `sudo` gefragt),
2. installiert `streamlink` per `pipx`,
3. richtet die App samt eigener Python-Umgebung unter `~/.local/share/livelistener` ein,
4. legt den Startbefehl `livelistener` und einen Eintrag im Anwendungsmenü an.

Optionen:

| Befehl | Wirkung |
| --- | --- |
| `bash install.sh --no-deps` | keine Systempakete installieren (wenn du mpv, pipx usw. schon hast) |
| `bash install.sh --uninstall` | App wieder entfernen (Einstellungen bleiben erhalten) |

Nach der Installation startest du livelistener über das Anwendungsmenü oder mit `livelistener`.

### Manuell starten (ohne Installer)

```bash
python3 -m venv .venv
.venv/bin/pip install -r requirements.txt
pipx install streamlink          # und mpv über den Paketmanager installieren
.venv/bin/python livelistener.py
```

## Windows



**Benutzen:**

1. Lade die Datei `livelistener-windows.zip` herunter und entpacke sie.
2. Starte `livelistener.exe`. 

Windows SmartScreen kann vor der unsignierten `.exe` warnen („Weitere Informationen“ → „Trotzdem ausführen“).


## Deinstallation (Linux)

```bash
cd livelistener
bash install.sh --uninstall
```

Das entfernt die App (`~/.local/share/livelistener`), den Startbefehl `livelistener`, den Menüeintrag und das Icon. Nicht entfernt werden:

- **Deine Einstellungen** in `~/.config/livelistener`. Zum Löschen: `rm -rf ~/.config/livelistener`
- **streamlink:** `pipx uninstall streamlink`
- **Systempakete** wie mpv und pipx: über deinen Paketmanager, z. B. `sudo apt remove mpv pipx`

## Benutzung

1. Fahre mit der Maus über das Fenster und klicke auf das Zahnrad, um die **Optionen** zu öffnen.
2. Füge einen Streamer hinzu und klicke auf **Folgen**:

   | Plattform | Eingabe |
   | --- | --- |
   | Kick | Link oder nur der Name, z. B. `name` |
   | Twitch | Link oder `twitch:name` |
   | YouTube | Kanal-Link oder `@handle`, oder der Direktlink zu einem Livestream (z. B. `https://www.youtube.com/watch?v=…`) |
   | TikTok | Link oder `tiktok:@name` |

   **YouTube mit mehreren Livestreams:** Läuft bei einem Kanal mehr als ein Livestream, spielt livelistener immer den ersten ab. Willst du einen anderen Stream desselben Kanals hören, füge den Direktlink zu diesem Stream als eigenen Eintrag hinzu.

3. Lass **Automatisch abspielen** aktiviert. Sobald ein Streamer aus deiner Liste live ist, startet der Ton.
4. Doppelklick auf einen Eintrag spielt ihn sofort ab.

Der Knopf **Pause/Play** pausiert den laufenden Stream, ein zweiter Klick spielt ihn wieder ab. Die automatische Wiedergabe bleibt an, startet den pausierten Streamer aber erst wieder, wenn er zwischendurch offline war.

## Einstellungen

Alle Einstellungen werden automatisch in `~/.config/livelistener/config.json` gespeichert. Ein eigenes GIF wird dort als `custom.gif` kopiert, das Original darf also gelöscht werden.

## Fehlerbehebung

- **Kein Tray-Icon unter GNOME:** GNOME zeigt Tray-Icons nur mit der Erweiterung *AppIndicator and KStatusNotifierItem Support*.
- **„streamlink nicht gefunden“ / kein Ton:** Prüfe im Terminal `streamlink --version` und `mpv --version`. Bei streamlink muss `~/.local/bin` im `PATH` sein (`pipx ensurepath`, danach neu anmelden).
- **Kein Streamer wird als live erkannt:** Teste im Terminal `streamlink --stream-url https://kick.com/NAME audio_only,worst`. streamlink wird bei jedem Start der App automatisch aktualisiert (nur bei Installation über pipx). Du kannst es auch manuell mit `pipx upgrade streamlink` aktualisieren.
- **YouTube: „This plugin does not support protected videos“:** Dein streamlink ist zu alt. Aktuelle Versionen brauchen Python 3.10 oder neuer; bei älterem Python (z. B. Ubuntu 20.04 mit Python 3.8) bleibt pipx bei einer alten Version hängen. Der Installer nutzt dann `uv`, das sich ein eigenes Python holt, und die App hält streamlink beim Start aktuell. Manuell: `curl -LsSf https://astral.sh/uv/install.sh | sh`, dann `pipx uninstall streamlink` und `uv tool install --python 3.12 streamlink`. Mit `streamlink --version` prüfst du das Ergebnis.
- **Windows: kein Ton / Streamer wird nicht erkannt:** Prüfe, ob die Ordner `mpv` und `streamlink` neben `livelistener.exe` liegen, und starte in der Eingabeaufforderung `streamlink\\bin\\streamlink.exe --version`. Beim Start meldet die App fehlende Programme.
- **Falsches Audiogerät:** Wähle in den Optionen unter *Audio-Ausgabe* das gewünschte Gerät.


