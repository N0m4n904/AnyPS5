# 3rdparty/ffmpeg-core carries no sources: its CMakeLists downloads a prebuilt
# package for the submodule's own commit while CMake configures, which a build
# sandbox cannot do. Fetching it up front and passing FFMPEG_PREBUILT_DIR is the
# path the submodule already provides for a package prepared elsewhere.
{
  fetchzip,
  rev,
  # Update together with the ffmpeg-core input; a wrong value is reported as a
  # hash mismatch for this URL.
  hash ? "sha256-MX8Rifr6CvFFkm0IAmJPNGzLb8FG5HJJUKO/l0zegko=",
}:

fetchzip {
  name = "ffmpeg-core-${rev}";
  url = "https://github.com/KytyPS5/ext-ffmpeg-core/releases/download/${rev}/ffmpeg-linux-x64.zip";
  stripRoot = false;
  inherit hash;
}
