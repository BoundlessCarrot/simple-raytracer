// Run with zig build-exe raytracer.zig && ./raytracer > img.ppm

const std = @import("std");
const pr = std.io.getStdOut().writer();
const pow = std.math.pow;

//The set of sphere positions describing the world.
//Those integers are in fact bit vectors.
// const sphere_positions: [9]usize = .{ 247570, 280596, 280600, 249748, 18578, 18577, 231184, 16, 16 }; // orginal values
const NUM_LINES: usize = 18;
const NUM_COLUMNS: usize = 36;
const sphere_positions: [NUM_LINES]usize = .{ 68552523617, 25820553265, 12910288921, 8334188557, 3227570183, 6455140365, 12910288921, 25820553265, 51572146017, 136575363, 71566723, 58983811, 17040771, 17040771, 17040771, 17040771, 17040771, 4259359 }; //personal message

var dprng = std.rand.DefaultPrng.init(0);
const rand = dprng.random();

/// A 3D vector
const vec = struct {
    x: f32,
    y: f32,
    z: f32,

    const Self = @This();

    /// Init
    pub fn init(x: f32, y: f32, z: f32) vec {
        return vec{ .x = x, .y = y, .z = z };
    }

    /// Empty init
    pub fn empty() vec {
        return vec{ .x = 0.0, .y = 0.0, .z = 0.0 };
    }

    /// Vector addition
    pub fn add(self: Self, other: vec) vec {
        return vec{ .x = self.x + other.x, .y = self.y + other.y, .z = self.z + other.z };
    }

    /// Vectot scaling/multiplication
    pub fn scale(self: Self, scalar: f32) vec {
        return vec{ .x = self.x * scalar, .y = self.y * scalar, .z = self.z * scalar };
    }

    /// Vector dot product
    pub fn dot(self: Self, other: vec) f32 {
        return self.x * other.x + self.y * other.y + self.z * other.z;
    }

    /// Vector cross product
    pub fn cross(self: Self, other: vec) vec {
        return vec{ .x = self.y * other.z - self.z * other.y, .y = self.z * other.x - self.x * other.z, .z = self.x * other.y - self.y * other.x };
    }

    /// vector normalization
    pub fn norm(self: Self) vec {
        const mag_sq = self.x * self.x + self.y * self.y + self.z * self.z;
        const mag = @sqrt(mag_sq);
        return vec{
            .x = self.x / mag,
            .y = self.y / mag,
            .z = self.z / mag,
        };
    }
};

// (S)ample the world and return the pixel color for
// a ray passing by point o (Origin) and d (Direction)
fn sample(orig: vec, dir: vec) vec {
    var t: f32 = 0.0;
    var n: vec = vec.empty();

    // Find the closest intersection
    var m: usize = trace(orig, dir, &t, &n);
    if (m == 0) {
        // No intersection
        return vec.init(0.7, 0.6, 1.0).scale(pow(f32, 1.0 - dir.z, 4.0));
    }

    // a sphere maybe was hit
    var h: vec = orig.add(dir.scale(t)); // intersection point
    var l: vec = vec.init(9.0 + rand.float(f32), 9.0 + rand.float(f32), 16.0).add(h.scale(-1.0)).norm(); // light vector
    var r: vec = dir.add(n.scale(n.dot(dir.scale(-2.0)))); // reflection vector

    //Calculated the lambertian factor
    var b: f32 = l.dot(n);

    //Calculate illumination factor (lambertian coefficient > 0 or in shadow)?
    if (b < 0.0 or trace(h, l, &t, &n) > 0) {
        b = 0.0;
    }

    // Calculate the color 'p' with diffuse and specular component
    var p: f32 = pow(f32, l.dot(r.scale(@floatFromInt(@intFromBool(b > 0.0)))), 99.0);

    if (m == 1) {
        h = h.scale(0.2); //No sphere was hit and the ray was going downward: Generate a floor color
        // std.debug.print("as float val: {any}, {d}\n", .{ h, (@ceil(h.x) + @ceil(h.y)) });
        const temp2: isize = @as(isize, @intFromFloat(@ceil(h.x) + @ceil(h.y))) & 1;
        const vec1 = if (temp2 == 1) vec.init(3.0, 1.0, 1.0) else vec.init(3.0, 3.0, 3.0);
        const temp3 = b * 0.2 + 0.1;
        return vec1.scale(temp3);
    }

    //m == 2 A sphere was hit. Cast an ray bouncing from the sphere surface.
    return vec.init(p, p, p).add(sample(h, r)).scale(0.5);
}

// The intersection test for line [o,v].
// Return 2 if a hit was found (and also return distance t and bouncing ray n).
// Return 0 if no hit was found but ray goes upward
// Return 1 if no hit was found but ray goes downward
fn trace(orig: vec, dir: vec, t: *f32, n: *vec) usize {
    t.* = 1e9;
    var m: usize = 0;
    var p: f32 = -orig.z / dir.z;
    if (0.01 < p) {
        t.* = p;
        n.* = vec.init(0.0, 0.0, 1.0);
        m = 1;
    }

    //The world is encoded in G, with array.len lines and the width of your ascii art in columns
    for (0..NUM_COLUMNS) |k| {
        // if you change the bit vector list, you need to change the loop range as well
        for (0..NUM_LINES - 1) |j| {
            //For this line j, is there a sphere at column j ?
            // const pos = sphere_positions[j];
            if ((sphere_positions[j] & pow(usize, 2, k)) != 0) {
                // There is a sphere but does the ray hits it ?
                var spr: vec = orig.add(vec.init(-@as(f32, @floatFromInt(k)), 0.0, -@as(f32, @floatFromInt(j)) - 4.0));
                var b: f32 = spr.dot(dir);
                var c: f32 = spr.dot(spr) - 1.0;
                var q: f32 = b * b - c;
                //Does the ray hit the sphere ?
                if (q > 0.0) {
                    //It does, compute the distance camera-sphere
                    var s: f32 = -b - @sqrt(q);
                    if (s < t.* and s > 0.01) {
                        // So far this is the minimum distance, save it. And also
                        // compute the bouncing ray vector into 'n'
                        t.* = s;
                        n.* = (spr.add(dir.scale(t.*))).norm();
                        m = 2;
                    }
                }
            }
        }
    }
    return m;
}

pub fn main() !void {
    // image header
    try pr.print("P3 512 512 255\n", .{});

    var g: vec = vec.init(-6.0, -16.0, 0.0).norm(); // camera direction
    var a: vec = vec.init(0.0, 0.0, 1.0).cross(g).norm().scale(0.002); // camera up vector
    var b: vec = g.cross(a).norm().scale(0.002); // camera right vector
    var c: vec = (a.add(b)).scale(-256.0).add(g); // the offset from the eye point (ignoring the lens perturbation `t`) to the corner of the focal plane (see [1])

    // iterate over each pixel
    var y: usize = 512;

    while (y > 0) : (y -= 1) {
        var x: usize = 512;
        while (x > 0) : (x -= 1) {
            var p: vec = vec.init(13.0, 13.0, 13.0); // the color of the pixel

            // cast 64 rays per pixel
            var i: usize = 64;
            while (i > 0) : (i -= 1) {
                // delta to apply to the origin of the ray
                var t: vec = a.scale((rand.float(f32) - 0.5) * 99.0).add(b.scale((rand.float(f32) - 0.5) * 99.0)); // a lil delta

                // Set the camera focal point v(17,16,8) and Cast the ray
                // Accumulate the color returned in the p variable
                var ray_orig: vec = vec.init(17.0, 16.0, 8.0).add(t);
                const rand1 = rand.float(f32) + @as(f32, @floatFromInt(x));
                const rand2 = rand.float(f32) + @as(f32, @floatFromInt(y));
                var ray_dir: vec = t.scale(-1.0).add(a.scale(rand1).add(b.scale(rand2)).add(c).scale(16.0)).norm();
                p = sample(ray_orig, ray_dir).scale(3.5).add(p);
            }

            try pr.print("{d} {d} {d}\n", .{ @as(usize, @intFromFloat(p.x)), @as(usize, @intFromFloat(p.y)), @as(usize, @intFromFloat(p.z)) });
        }
    }
}

// Sources
// [0] https://fabiensanglard.net/rayTracing_back_of_business_card/
// [1] https://news.ycombinator.com/item?id=6425965
