# MPV Configuration

I chose MPV to be my main media player due to its customisability, minimalistic interface, and keyboard-oriented workflow.

MPV seem to be equally versatile in opening various media formats as VLC so we're not missing out on anything there.

## Keybinds
I prefer to stick to the default keybinds for MPV.

## Notable Features
Some of the notable features that I use will be documented here for quick reference.

### Save Position on Quit
I prefer to manually do this for files I intend to resume later via the `Shift+Q` keybind.

The type of information to save (e.g. volume,brightness,subtitles) are listed in `mpv --list-options` under `--watch-later-options`.

Watch later files are by default stored in `~/.local/state/mpv/watch_later`.
Plain filepaths are not stored by default (for privacy reasons), the filenames in the watch later directories are MD5 hashes of the full filepath (and path components).
e.g. `echo -n '/home/leafboat/Downloads/vid.mp4' | md5sum` should give the corresponding filename in the Watch Later Directory.

When a playlist includes a video that is in the Watch Later Directory mpv will not play from the start of the playlist but instead resume from the first file in the Watch Later Directory.

### Subtitles
- If a subtitle file with the same name as the video exists in the same directory, it will be auto-detected and used by default.
    - Subtitle file paths can be specified with `--sub-file-paths` [option](https://mpv.io/manual/master/#options-sub-file-paths)
    - Auto-detection behaviour (whether to fuzzy match or traverse recusively) can be changed with the `--sub-auto` [option](https://mpv.io/manual/master/#options-sub-auto)

- Subtitle files can also be dragged and dropped in

## Privacy
By default, MPV **doesn't store**
- Watch later positions for resuming playback later
    - Even when enabled, it doesn't store filenames by default
- Watch history

> Source: [MPV Manual](https://mpv.io/manual/master/) search `privacy`.

