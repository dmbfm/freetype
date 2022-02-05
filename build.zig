const std = @import("std");
const Builder = std.build.Builder;
const Pkg = @import("./pkg.zig").Pkg(".");

pub fn build(b: *Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    var freetype = Pkg.library(b, target, mode);

    freetype.install();
}
