# srv3-karaoke-extractor – YouTube Karaoke Subtitle Extractor (.srv3 → .ass)

srv3 is a Linux command-line tool designed specifically for YouTube videos that use karaoke-style, syllable-animated subtitles (the .srv3 subtitle format).

It downloads the video, extracts YouTube’s timing-accurate karaoke subtitle data, converts it to .ass format (preserving syllable animation and timing), and organizes everything cleanly into your ~/Videos directory.

In newer versions, due to YouTube switching to SABR streaming, srv3 downloads video-only footage and automatically combines it with the best available audio stream during processing. This ensures maximum video quality while remaining compatible with YouTube’s current delivery format.

The tool is built to work out of the box on Debian-based distributions, with a fully automated installer for Debian/Ubuntu systems (including Xubuntu).
---

## 🎤 Why .srv3 / Karaoke Subtitles?

Many music videos, anime openings/endings, and lyric videos on YouTube use karaoke-style subtitles, where:

- Words or syllables animate individually
- Timing is embedded at syllable level
- Standard subtitle formats (`.srt`, `.vtt`) cannot preserve this behavior

YouTube stores this data in the `.srv3` format.

`srv3` exists specifically to:

- Extract this syllable-accurate subtitle data
- Convert it into Advanced SubStation Alpha (`.ass`)
- Preserve karaoke timing and animation correctly

---

## ✨ Features

- Designed specifically for karaoke / syllable-animated subtitles  
- Download YouTube videos in high quality  
- Extract `.srv3` subtitle tracks  
- Convert `.srv3 → .ass` with full karaoke timing  
- Automatically delete original `.srv3` files  
- Clean output structure: `~/Videos/<Video Title>/`  
- Global `srv3` command usable from any directory  
- Fully automated dependency installation for **your debian-based distro**

---

## 📦 Requirements (Installed Automatically)

The installer handles everything required for your debian-based distro, including:

- `yt-dlp`  
- `ffmpeg`  
- .NET 8 Runtime  
- YTSubConverter  
- System utilities (`curl`, `wget`, etc.)  

No manual setup is normally required.

---

## 📁 Repository Layout

Your repository should contain:

```
.
├── install.sh
├── srv3
├── YTSubConverter-Linux.deb
└── README.md
```

All files must remain in the same directory during installation for **your debian-based distro**.

---

## 🚀 Installation (Recommended for Your Debian-Based Distro)

1️⃣ Clone the repository:
```
git clone https://github.com/TheNPC-sketch/srv3-karaoke-extractor
cd srv3-karaoke-extractor
```

2️⃣ Make installer executable:

```
chmod +x install.sh
```

3️⃣ Run the installer:

```
sudo ./install.sh
```

This will:

- Install all dependencies for your distro
- Install yt-dlp
- Install .NET 8 Runtime
- Install YTSubConverter
- Register global commands:
- srv3
- ytsubconverter

🔹 Logging out and back in is recommended after installation.

## 🎬 Usage
Download karaoke-subbed videos by using the following command:

```
srv3 "https://www.youtube.com/watch?v=VIDEO_ID" [MODE]
```
The script downloads SABR video + best audio, extracts YouTube srv3 subtitles, converts them to ASS, and optionally burns or muxes them.

| Mode      | Output Location               | Output Type     | Description                                                   |
| --------- | ----------------------------- | --------------- | ------------------------------------------------------------- |
| *(none)*  | `~/Videos/<title>_<quality>/` | Folder          | Downloads video + ASS subtitles and keeps all files           |
| `-burn`   | `~/Videos/`                   | MP4             | Burns ASS subtitles into video and deletes temp files         |
| `-burn-e` | `~/Videos/`                   | MP4             | Opens ASS in editor before burning                            |
| `-soft`   | `~/Videos/`                   | MKV             | Muxes ASS as soft subtitle (default track), cleans temp files |
| `-soft-e` | `~/Videos/`                   | MKV             | Opens ASS in editor before muxing                             |
| `-subs-o` | `~/Videos/`                   | ASS             | Downloads **only subtitles** (no video)                       |
| `-subs`   | Depends on extra flags        | ASS / MKV / MP4 | Downloads video from URL1 and subtitles from URL2             |

**Example**
```
# Download video + subtitles, keep everything in a folder
srv3 "https://www.youtube.com/watch?v=abcd1234"

# Burn subtitles into MP4
srv3 "https://www.youtube.com/watch?v=abcd1234" -burn

# Edit subtitles before burning
srv3 "https://www.youtube.com/watch?v=abcd1234" -burn-e

# Mux subtitles as soft track (MKV)
srv3 "https://www.youtube.com/watch?v=abcd1234" -soft

# Edit subtitles before muxing
srv3 "https://www.youtube.com/watch?v=abcd1234" -soft-e

# Download only the ASS subtitle file
srv3 "https://www.youtube.com/watch?v=abcd1234" -subs-o
```

**Using `-subs`(Seperate Video and Subtitle URLs)**

You can download video from one URL and subtitles from another (useful for reuploads, lyric videos, or alternate subtitle sources).

```
srv3 <VIDEO_URL> -subs <SUBS_URL> [PROCESS_MODE]
```
Supported processing modes after `-subs`:
- `-soft`
- `-soft-e`
- `-burn`
- `-burn-e`

**Examples**
```
# Video from URL1 + subtitles from URL2, keep files in folder
srv3 "VIDEO_URL" -subs "SUBS_URL"

# Video from URL1 + subtitles from URL2, burn into MP4
srv3 "VIDEO_URL" -subs "SUBS_URL" -burn

# Edit subtitles before burning
srv3 "VIDEO_URL" -subs "SUBS_URL" -burn-e

# Mux subtitles as soft ASS track
srv3 "VIDEO_URL" -subs "SUBS_URL" -soft

# Edit subtitles before muxing
srv3 "VIDEO_URL" -subs "SUBS_URL" -soft-e
```

## 🎚 Format Selection

When running, `srv3`:

Lists all available YouTube formats

Prompts you to select the desired format code

Downloads the exact format you choose

This ensures maximum compatibility for your distro and for videos with special subtitle timing.

## 🛠 How It Works (Technical Overview)
Uses yt-dlp -F to enumerate formats

Prompts user for format selection

Downloads:

- Video
- Audio
- .srv3 karaoke subtitles
- Merges streams into MP4
- Converts subtitles:
-     .srv3 → .ass

Preserves syllable timing and karaoke effects

Cleans up intermediate files

Organizes output into `~/Videos`

All paths and tools follow Linux standards for your debian-based distro

## ❗ If install.sh Fails (Detailed Help)
**1️⃣ Confirm supported distro**

`srv3` is intended for your distro if it is:

- Ubuntu
- Xubuntu
- Kubuntu
- Linux Mint

Any Debian-based distro

~Verify:

```
lsb_release -a
```

**2️⃣ Missing .deb file**


Error:

```
YTSubConverter-Linux.deb not found
```

Fix: 
Download the Linux `.deb` for `YTSubConverter` and place it next to install.sh.


**3️⃣ .NET runtime issues**

Install manually for your distro:

```
sudo apt update
sudo apt install dotnet-runtime-8.0
```

Verify:

```
dotnet --list-runtimes
```

**4️⃣ ytsubconverter command missing**

Manually create the wrapper:

```
sudo tee /usr/local/bin/ytsubconverter > /dev/null << 'EOF'
#!/bin/bash
dotnet /opt/ytsubconverter/ytsubconverter.dll "$@"
EOF
```

```
sudo chmod +x /usr/local/bin/ytsubconverter
```

**5️⃣ srv3 command missing**

```
sudo install -m 755 srv3 /usr/local/bin/srv3
```

**6️⃣ Re-run installer**

Safe to rerun for your distro:

```
sudo ./install.sh
```

## 🧹 Uninstalling

```
sudo rm /usr/local/bin/srv3
sudo rm /usr/local/bin/ytsubconverter
sudo apt remove ytsubconverter
```

**Optionally:**

```
rm -rf ~/.srv3_config
```

## 👏 Huge Thanks TO!
- `YTSubConverter` -- https://github.com/arcusmaximus/YTSubConverter/
- `yt-dlp` -- https://github.com/yt-dlp/yt-dlp/
- `ffmpeg` -- https://git.ffmpeg.org/ffmpeg.git

**This project would not be possible without these essential tools and utilities.**

## ⭐ Notes
- Intended for karaoke / syllable-animated subtitle tracks
- Not useful for plain .srt subtitles
- Desktop environment independent
- Designed to be stable and distro-friendly
