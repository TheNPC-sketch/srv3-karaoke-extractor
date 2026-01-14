#!/bin/bash

# ----------------------------------------
# YTSubConverter + yt-dlp interactive downloader
#
# Modes:
#   (none)     -> keep video + ASS in folder
#   -burn      -> burn subtitles, auto cleanup, MP4 output
#   -burn-e    -> edit ASS before burning, MP4 output
#   -soft      -> mux ASS as soft subtitle track, MKV output, default track
#   -soft-e    -> edit ASS before muxing, MKV output, default track
# ----------------------------------------

# -------- argument handling --------
URL="$1"
MODE="normal"

if [ -z "$URL" ]; then
    echo "Usage: $0 <YouTube URL> [-burn | -burn-e | -soft | -soft-e]"
    exit 1
fi

case "$2" in
    -burn)    MODE="burn" ;;
    -burn-e)  MODE="burn-edit" ;;
    -soft)    MODE="soft" ;;
    -soft-e)  MODE="soft-edit" ;;
esac

# -------- dependency checks --------
command -v yt-dlp >/dev/null || { echo "yt-dlp not installed"; exit 1; }
command -v ytsubconverter >/dev/null || { echo "YTSubConverter not found"; exit 1; }

if [[ "$MODE" != "normal" ]] && ! command -v ffmpeg >/dev/null; then
    echo "ffmpeg is required for this mode"
    exit 1
fi

# -------- default editor: micro --------
EDITOR_CMD="${EDITOR:-micro}"

# -------- metadata --------
VIDEO_TITLE=$(yt-dlp --get-title "$URL")
SAFE_TITLE=$(echo "$VIDEO_TITLE" | sed 's#[/:]#_#g')

# -------- format selection --------
echo "Available formats for \"$VIDEO_TITLE\":"
yt-dlp -F "$URL"
read -p "Enter the format code you want to download: " FORMAT_CODE

# -------- quality suffix --------
FORMAT_INFO=$(yt-dlp -F "$URL" | grep "^$FORMAT_CODE " | awk '{print $3,$4}')
QUALITY_SUFFIX=$(echo "$FORMAT_INFO" | tr -d ' ')

VIDEOS_DIR="$HOME/Videos"

# -------- destination handling --------
if [[ "$MODE" == "normal" ]]; then
    DEST_DIR="$VIDEOS_DIR/${SAFE_TITLE}_${QUALITY_SUFFIX}"
    mkdir -p "$DEST_DIR"
else
    DEST_DIR="$VIDEOS_DIR/temp"
    mkdir -p "$DEST_DIR"
fi

# -------- set output filename based on mode --------
if [[ "$MODE" == soft* ]]; then
    FINAL_OUTPUT="$VIDEOS_DIR/${SAFE_TITLE}.mkv"
else
    FINAL_OUTPUT="$VIDEOS_DIR/${SAFE_TITLE}.mp4"
fi

echo "Downloading to: $DEST_DIR"

# -------- download --------
yt-dlp "$URL" \
    -f "$FORMAT_CODE" \
    --merge-output-format mp4 \
    --write-subs \
    --sub-format srv3 \
    -o "$DEST_DIR/%(title)s.%(ext)s"

echo "Download complete."

# -------- convert subtitles --------
ASS_FILE=""

for file in "$DEST_DIR"/*.srv3; do
    [ -f "$file" ] || continue
    ASS_FILE="${file%.srv3}.ass"
    echo "Converting '$file' -> '$ASS_FILE'..."
    ytsubconverter "$file" "$ASS_FILE" || exit 1
    rm "$file"
done

# -------- edit subtitles if requested --------
if [[ "$MODE" == "burn-edit" || "$MODE" == "soft-edit" ]]; then
    echo
    echo "Editing ASS file in micro:"
    echo "$ASS_FILE"
    echo "Save and exit to continue."
    echo
    "$EDITOR_CMD" "$ASS_FILE"
fi

# -------- process video --------
if [[ "$MODE" == "burn" || "$MODE" == "burn-edit" ]]; then
    echo "Burning subtitles into video..."
    VIDEO_FILE=$(ls "$DEST_DIR"/*.mp4 | head -n 1)

    ffmpeg -y \
        -i "$VIDEO_FILE" \
        -vf "ass=$(printf '%q' "$ASS_FILE")" \
        -c:a copy \
        "$FINAL_OUTPUT"

elif [[ "$MODE" == "soft" || "$MODE" == "soft-edit" ]]; then
    echo "Muxing ASS subtitles as soft subtrack (default)..."
    VIDEO_FILE=$(ls "$DEST_DIR"/*.mp4 | head -n 1)

    ffmpeg -y \
        -i "$VIDEO_FILE" \
        -i "$ASS_FILE" \
        -map 0:v -map 0:a -map 1:0 \
        -c copy \
        -metadata:s:s:0 language=eng \
        -disposition:s:0 default \
        "$FINAL_OUTPUT"
fi

# -------- cleanup --------
if [[ "$MODE" != "normal" ]]; then
    echo "Cleaning up temporary files..."
    rm -rf "$DEST_DIR"
fi

echo "All done!"
