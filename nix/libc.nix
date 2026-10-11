# The root CMakeLists appends -static to CMAKE_EXE_LINKER_FLAGS on every
# platform but Apple, so the executables need a static glibc while the shared
# .prx libraries must keep the dynamic one. Offering the static output alone
# puts its directory ahead of the dynamic libc for every link: a shared library
# then draws malloc from libc.a and fails on its local-exec thread-local
# relocations, and an executable that does not carry -static, such as glslang's
# standalone compiler, links libc.a yet still asks for the dynamic interpreter
# and crashes at startup.
#
# Searching the dynamic libc first settles both. It holds no libc.a, so a
# -static link passes over it and reaches the static output, while every other
# link finds libc.so there before anything else.
{ lib, glibc }:

let
  dynamicLibc = "-L${lib.getLib glibc}/lib";
in
{
  static = glibc.static;

  # CMake appends the project's own flags to each of these.
  cmakeFlags = map (variable: lib.cmakeFeature variable dynamicLibc) [
    "CMAKE_EXE_LINKER_FLAGS"
    "CMAKE_SHARED_LINKER_FLAGS"
    "CMAKE_MODULE_LINKER_FLAGS"
  ];

  # The same three variables, for a shell where the cmake command is the
  # developer's to type: CMake seeds all of them from LDFLAGS, and reads none of
  # them from the environment directly.
  ldflags = dynamicLibc;
}
