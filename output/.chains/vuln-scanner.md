ℹ️ Vuln Scanner — claude-video (clean)

*Vuln Scanner — bradautomates/claude-video*
Clean audit. 3 candidates reviewed, 0 confirmed. The /watch skill (yt-dlp+ffmpeg+Whisper, ~12.9k★) is defensively coded — list-form subprocess, `--` separators, `-` prefix rejection, path resolution. The 2 GHA mutable-tag hits are hardening nits; the whisper.py urllib hit is a false positive (hardcoded endpoint). Scanners: semgrep=ok, trufflehog=ok, osv=ok.