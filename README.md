# Batch Video Transcoder for DaVinci Resolve

A bash script for batch converting video files to Apple ProRes format using ffmpeg. Supports single files, multiple files, and wildcard patterns.

## Features

- 🎬 **Batch Processing**: Convert multiple video files in one command
- 🔍 **Wildcard Support**: Use patterns like `*.mp4`, `*.mov`, etc.
- 📁 **Smart Directory Handling**: Creates `transcoded` subdirectories automatically
- 🔄 **Error Resilient**: Continues processing other files even if one fails
- 📊 **Progress Tracking**: Shows detailed progress and final summary
- ⚡ **High Quality Output**: Uses Apple ProRes 422 HQ codec

## Requirements

- **ffmpeg** with ProRes support
- **bash** shell
- Unix-like operating system (Linux, macOS, WSL)

### Installing ffmpeg

**macOS (Homebrew):**
```bash
brew install ffmpeg
```

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install ffmpeg
```

**CentOS/RHEL:**
```bash
sudo yum install epel-release
sudo yum install ffmpeg
```

## Installation

1. Download the script:
```bash
curl -O https://raw.githubusercontent.com/dddk1ddd/prores_converter/main/CONVERT.sh
```

2. Make it executable:
```bash
chmod +x CONVERT.sh
```

3. Optionally, move to a directory in your PATH:
```bash
sudo mv CONVERT.sh /usr/local/bin/CONVERT
```

## Usage

```bash
./CONVERT.sh <input_video_file(s)>
```

### Examples

**Single file:**
```bash
./CONVERT.sh my-video.mov
```

**Multiple specific files:**
```bash
./CONVERT.sh video1.mp4 video2.mkv video3.avi
```

**All files with same extension:**
```bash
./CONVERT.sh *.mov
./CONVERT.sh *.mp4
```

**Multiple extensions at once:**
```bash
./CONVERT.sh *.mp4 *.mov *.mkv
```

**Files in specific directory:**
```bash
./CONVERT.sh /path/to/videos/*.mov
./CONVERT.sh ~/Movies/*.mp4
```

**Mixed patterns:**
```bash
./CONVERT.sh important-video.mp4 *.mov /other/path/*.mkv
```

## Output Format

### Video Settings
- **Codec**: Apple ProRes 422 HQ (`prores_ks`)
- **Profile**: 3 (422 HQ)
- **Quality**: 9 (high quality)
- **Pixel Format**: YUV 4:2:2 10-bit (`yuv422p10le`)
- **Vendor**: Apple (`ap10`)

### Audio Settings
- **Codec**: PCM 16-bit (`pcm_s16le`)

### File Structure
```
original-directory/
├── input-video.mp4
└── transcoded/
    └── input-video.mov
```

## Example Output

```
Starting batch transcoding...
==================================
Converting 'video1.mp4' to 'transcoded/video1.mov'...
Input directory: /home/user/videos
Output directory: /home/user/videos/transcoded

[ffmpeg output...]

✓ Transcoding completed successfully for: video1.mp4
Output file: /home/user/videos/transcoded/video1.mov

Converting 'video2.mkv' to 'transcoded/video2.mov'...
[...]

==================================
Batch transcoding completed!
Total files processed: 2
Successful: 2
Failed: 0
```

## Supported Input Formats

The script can handle any video format that ffmpeg supports, including:
- MP4 (`.mp4`)
- MOV (`.mov`)
- AVI (`.avi`)
- MKV (`.mkv`)
- WMV (`.wmv`)
- FLV (`.flv`)
- WebM (`.webm`)
- And many more...

## Error Handling

- **Missing files**: Warns and skips non-existent files
- **FFmpeg errors**: Reports failures but continues with remaining files
- **Directory creation**: Automatically creates output directories
- **Exit codes**: Returns appropriate exit codes for scripting integration

## Why ProRes?

Apple ProRes is an excellent intermediate codec for video editing because it:
- Is the only format that works in the free version of DaVinci Resolve in Linux
- Provides high quality with reasonable file sizes
- Offers fast encoding/decoding performance
- Maintains quality through multiple generations
- Is widely supported by professional video editing software
- Uses intra-frame compression for easy editing

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the GNU General Public License Version 3 - see the [LICENSE](LICENSE) file for details.

## Troubleshooting

### Common Issues

**"ffmpeg: command not found"**
- Install ffmpeg using your system's package manager

**"Permission denied"**
- Make sure the script is executable: `chmod +x CONVERT.sh`

**"No such file or directory"**
- Check that input files exist and paths are correct
- Use quotes around filenames with spaces: `"my video.mp4"`

**ProRes encoding fails**
- Ensure your ffmpeg build includes ProRes support
- Try updating to a newer version of ffmpeg

### Getting Help

If you encounter issues:
1. Check that ffmpeg is installed and working: `ffmpeg -version`
2. Test with a single small file first
3. Check file permissions and available disk space
4. Open an issue with the error message and system details

## Acknowledgments

- Built with [ffmpeg](https://ffmpeg.org/)
- Thanks to the open source community and Claude AI
