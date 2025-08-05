#!/bin/bash

# Video transcoding script using ffmpeg
# Converts input video(s) to ProRes format in transcoded directory
# Supports wildcards and multiple files

# Function to display usage
usage() {
    echo "Batch Video Transcoder for DaVinci Resolve"
    echo "=================================================="
    echo ""
    echo "DESCRIPTION:"
    echo "  Converts video files to Apple ProRes format using ffmpeg."
    echo "  Creates a 'transcoded' subdirectory in each input file's location."
    echo "  Supports single files, multiple files, and wildcard patterns."
    echo ""
    echo "USAGE:"
    echo "  $0 <input_video_file(s)>"
    echo ""
    echo "ENCODING SETTINGS:"
    echo "  Video: ProRes 422 HQ (profile 3, quality 9)"
    echo "  Audio: PCM 16-bit"
    echo "  Pixel Format: YUV 4:2:2 10-bit"
    echo ""
    echo "EXAMPLES:"
    echo "  Single file:"
    echo "    $0 my-video.mov"
    echo ""
    echo "  Multiple specific files:"
    echo "    $0 video1.mp4 video2.mkv video3.avi"
    echo ""
    echo "  All files with same extension:"
    echo "    $0 *.mov"
    echo "    $0 *.mp4"
    echo ""
    echo "  Multiple extensions at once:"
    echo "    $0 *.mp4 *.mov *.mkv"
    echo ""
    echo "  Files in specific directory:"
    echo "    $0 /path/to/videos/*.mov"
    echo "    $0 ~/Movies/*.mp4"
    echo ""
    echo "  Mixed patterns:"
    echo "    $0 important-video.mp4 *.mov /other/path/*.mkv"
    echo ""
    echo "OUTPUT:"
    echo "  Files are saved as: [original_directory]/transcoded/[filename].mov"
    echo ""
    exit 1
}

# Function to process a single file
process_file() {
    local INPUT_FILE="$1"
    
    # Check if input file exists
    if [ ! -f "$INPUT_FILE" ]; then
        echo "Warning: File '$INPUT_FILE' does not exist, skipping..."
        return 1
    fi
    
    # Get the directory where the input file is located
    local INPUT_DIR=$(dirname "$INPUT_FILE")
    local INPUT_FILENAME=$(basename "$INPUT_FILE")
    
    # Extract filename without extension
    local FILENAME_NO_EXT="${INPUT_FILENAME%.*}"
    
    # Create transcoded directory if it doesn't exist
    local TRANSCODED_DIR="$INPUT_DIR/transcoded"
    mkdir -p "$TRANSCODED_DIR"
    
    local OUTPUT_FILE="$TRANSCODED_DIR/${FILENAME_NO_EXT}.mov"
    
    echo "Converting '$INPUT_FILE' to '$OUTPUT_FILE'..."
    echo "Input directory: $INPUT_DIR"
    echo "Output directory: $TRANSCODED_DIR"
    echo ""
    
    # Change to the input file's directory
    cd "$INPUT_DIR"
    
    # Run ffmpeg command
    ffmpeg -i "$INPUT_FILENAME" \
        -c:v prores_ks \
        -profile:v 3 \
        -qscale:v 9 \
        -vendor ap10 \
        -pix_fmt yuv422p10le \
        -acodec pcm_s16le \
        "$OUTPUT_FILE"
    
    # Check if ffmpeg succeeded
    if [ $? -eq 0 ]; then
        echo ""
        echo "✓ Transcoding completed successfully for: $INPUT_FILENAME"
        echo "Output file: $OUTPUT_FILE"
        echo ""
        return 0
    else
        echo ""
        echo "✗ Transcoding failed for: $INPUT_FILENAME"
        echo ""
        return 1
    fi
}

# Check if any arguments are provided
if [ $# -eq 0 ]; then
    echo "Error: No input files specified"
    usage
fi

# Initialize counters
TOTAL_FILES=0
SUCCESSFUL_FILES=0
FAILED_FILES=0

echo "Starting batch transcoding..."
echo "================================"

# Process each argument (which may be expanded wildcards)
for INPUT_FILE in "$@"; do
    TOTAL_FILES=$((TOTAL_FILES + 1))
    
    if process_file "$INPUT_FILE"; then
        SUCCESSFUL_FILES=$((SUCCESSFUL_FILES + 1))
    else
        FAILED_FILES=$((FAILED_FILES + 1))
    fi
done

# Print summary
echo "================================"
echo "Batch transcoding completed!"
echo "Total files processed: $TOTAL_FILES"
echo "Successful: $SUCCESSFUL_FILES"
echo "Failed: $FAILED_FILES"

# Exit with appropriate code
if [ $FAILED_FILES -gt 0 ]; then
    exit 1
else
    exit 0
fi