const std = @import("std");
const Builder = std.build.Builder;

pub fn Pkg(path: []const u8) type {
    return struct {
        const freetypeSourcesBase: []const []const u8 = &.{
            path ++ "/src/autofit/autofit.c",
            path ++ "/src/base/ftbase.c",
            path ++ "/src/base/ftbbox.c",
            path ++ "/src/base/ftbdf.c",
            path ++ "/src/base/ftbitmap.c",
            path ++ "/src/base/ftcid.c",
            path ++ "/src/base/ftfstype.c",
            path ++ "/src/base/ftgasp.c",
            path ++ "/src/base/ftglyph.c",
            path ++ "/src/base/ftgxval.c",
            path ++ "/src/base/ftinit.c",
            path ++ "/src/base/ftmm.c",
            path ++ "/src/base/ftotval.c",
            path ++ "/src/base/ftpatent.c",
            path ++ "/src/base/ftpfr.c",
            path ++ "/src/base/ftstroke.c",
            path ++ "/src/base/ftsynth.c",
            path ++ "/src/base/fttype1.c",
            path ++ "/src/base/ftwinfnt.c",
            path ++ "/src/bdf/bdf.c",
            path ++ "/src/bzip2/ftbzip2.c",
            path ++ "/src/cache/ftcache.c",
            path ++ "/src/cff/cff.c",
            path ++ "/src/cid/type1cid.c",
            path ++ "/src/gzip/ftgzip.c",
            path ++ "/src/lzw/ftlzw.c",
            path ++ "/src/pcf/pcf.c",
            path ++ "/src/pfr/pfr.c",
            path ++ "/src/psaux/psaux.c",
            path ++ "/src/pshinter/pshinter.c",
            path ++ "/src/psnames/psnames.c",
            path ++ "/src/raster/raster.c",
            path ++ "/src/sdf/sdf.c",
            path ++ "/src/sfnt/sfnt.c",
            path ++ "/src/smooth/smooth.c",
            path ++ "/src/svg/svg.c",
            path ++ "/src/truetype/truetype.c",
            path ++ "/src/type1/type1.c",
            path ++ "/src/type42/type42.c",
            path ++ "/src/winfonts/winfnt.c",
        };

        const freetypeFlags = [_][]const u8{
            "-I" ++ path ++ "/include/",
            "-DFT2_BUILD_LIBRARY",
        };

        pub fn library(b: *Builder, target: std.zig.CrossTarget, mode: std.builtin.Mode) *std.build.LibExeObjStep {
            const freetype = b.addStaticLibrary("freetype", null);
            freetype.setTarget(target);
            freetype.setBuildMode(mode);
            freetype.linkLibC();
            freetype.addCSourceFiles(freetypeSourcesBase, &freetypeFlags);

            if (target.isWindows()) {
                freetype.addCSourceFile(path ++ "/builds/windows/ftsystem.c", &freetypeFlags);
            } else if (target.isLinux()) {
                // const flags =
                const flags = freetypeFlags ++ [_][]const u8{
                    "-DHAVE_FCNTL_H",
                    "-DHAVE_UNISTD_H",
                };

                freetype.addCSourceFile(path ++ "/builds/unix/ftsystem.c", &flags);
            } else {
                freetype.addCSourceFile(path ++ "/src/base/ftsystem.c", &freetypeFlags);
            }

            if (!target.isWindows()) {
                freetype.addCSourceFile(path ++ "/src/base/ftdebug.c", &freetypeFlags);
            }

            // // if (target.isLinux()) {
            // }

            return freetype;
        }
    };
}
