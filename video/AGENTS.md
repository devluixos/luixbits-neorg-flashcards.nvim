# Remotion project instructions

- The canonical video format is the laptop's internal `eDP-1` panel:
  `2880×1800`, 16:10. Do not change the composition to 1920×1080 or another
  16:9 preset unless the user explicitly requests a different target.
- Keep output dimensions in `src/timeline.ts` as `OUTPUT_WIDTH` and
  `OUTPUT_HEIGHT`. The visual design surface is `1920×1200` and scales by 1.5
  to the native output, keeping layout values readable while rendering sharply.
- Keep the delivery frame rate at 30 fps unless the user explicitly asks for a
  different frame rate. The panel's 120 Hz refresh rate is not the video frame
  rate.
- New footage intended to fill the frame must be captured or cropped to 16:10.
  Prefer 2880×1800 source footage; do not stretch 16:9 footage.
- Keep captions within the existing title-safe margins and inspect them at full
  output resolution after layout or copy changes.
- After changing the composition, run `npm run check`, inspect
  `npm run compositions`, render `npm run still`, and render the complete MP4
  before declaring the video ready. On NixOS, use
  `bash scripts/render-video-nixos.sh` from the repository root.
