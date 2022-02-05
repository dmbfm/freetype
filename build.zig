const std = @import("std");
const Builder = std.build.Builder;

const freetypeSourcesBase: []const []const u8 = &.{
    "src/autofit/autofit.c",
    "src/base/ftbase.c",
    "src/base/ftbbox.c",
    "src/base/ftbdf.c",
    "src/base/ftbitmap.c",
    "src/base/ftcid.c",
    "src/base/ftfstype.c",
    "src/base/ftgasp.c",
    "src/base/ftglyph.c",
    "src/base/ftgxval.c",
    "src/base/ftinit.c",
    "src/base/ftmm.c",
    "src/base/ftotval.c",
    "src/base/ftpatent.c",
    "src/base/ftpfr.c",
    "src/base/ftstroke.c",
    "src/base/ftsynth.c",
    "src/base/fttype1.c",
    "src/base/ftwinfnt.c",
    "src/bdf/bdf.c",
    "src/bzip2/ftbzip2.c",
    "src/cache/ftcache.c",
    "src/cff/cff.c",
    "src/cid/type1cid.c",
    "src/gzip/ftgzip.c",
    "src/lzw/ftlzw.c",
    "src/pcf/pcf.c",
    "src/pfr/pfr.c",
    "src/psaux/psaux.c",
    "src/pshinter/pshinter.c",
    "src/psnames/psnames.c",
    "src/raster/raster.c",
    "src/sdf/sdf.c",
    "src/sfnt/sfnt.c",
    "src/smooth/smooth.c",
    "src/svg/svg.c",
    "src/truetype/truetype.c",
    "src/type1/type1.c",
    "src/type42/type42.c",
    "src/winfonts/winfnt.c",
};

const freetypeFlags = [_][]const u8{
    "-I./include/",
    "-DFT2_BUILD_LIBRARY",
};

pub fn createLibrary(b: *Builder) *std.build.LibExeObjStep {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const freetype = b.addStaticLibrary("freetype", null);
    freetype.setTarget(target);
    freetype.setBuildMode(mode);
    freetype.linkLibC();
    freetype.addCSourceFiles(freetypeSourcesBase, &freetypeFlags);

    if (target.isWindows()) {
        freetype.addCSourceFile("builds/windows/ftsystem.c", &freetypeFlags);
    } else if (target.isLinux()) {
        freetype.addCSourceFile("builds/unix/ftsystem.c", &freetypeFlags);
    } else {
        freetype.addCSourceFile("src/base/ftsystem.c", &freetypeFlags);
    }

    if (!target.isWindows()) {
        freetype.addCSourceFile("src/base/ftdebug.c", &freetypeFlags);
    }

    return freetype;
}

pub fn build(b: *Builder) void {
    var freetype = createLibrary(b);

    freetype.install();
}
