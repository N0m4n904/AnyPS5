# SDL2 and the Vulkan loader are linked into the system libraries statically and
# reach the host's display, input and audio stacks through dlopen, so these
# libraries are needed both to configure SDL and at run time.
{
  alsa-lib,
  libpulseaudio,
  libx11,
  libxcb,
  libxcursor,
  libxext,
  libxfixes,
  libxi,
  libxinerama,
  libxkbcommon,
  libxrandr,
  libxscrnsaver,
  systemdLibs,
  vulkan-loader,
}:

[
  alsa-lib
  libpulseaudio
  libxkbcommon
  systemdLibs
  vulkan-loader
  libx11
  # The Vulkan window surface of SDL's X11 backend is an XCB surface.
  libxcb
  libxcursor
  libxext
  libxfixes
  libxi
  libxinerama
  libxrandr
  libxscrnsaver
]
