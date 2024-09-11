#!/usr/bin/env raku
use v6.d;

#use lib <. lib>;
use Math::DistanceFunctions::Native;
use NativeCall;
use NativeHelpers::Array;
use JSON::Fast;

my $iterations = 1_000;

my @large-vec1 = (^1000).map({1.rand});
my @large-vec2 = (^1000).map({1.rand});
my $large-vec1c = copy-to-carray(@large-vec1, num64);
my $large-vec2c = copy-to-carray(@large-vec2, num64);

#`[
note ('@large-vec2c' => $large-vec2c);
note $large-vec2c.WHAT;
note $large-vec2c ~~ CArray;
note $large-vec2c ~~ Positional;
note $large-vec2c.all ~~ Numeric:D;
note $large-vec2c;
note $large-vec2c.elems;
#note to-json($large-vec1c);
]

my $start = now;
for ^$iterations {
    cosine-distance(@large-vec1, @large-vec2);
}
my $large-cosine-time = now - $start;

$start = now;
for ^$iterations {
    cosine-distance($large-vec1c, $large-vec2c);
}
my $c-large-cosine-time = now - $start;

$start = now;
for ^$iterations {
    euclidean-distance(@large-vec1, @large-vec2);
}
my $large-euclidean-time = now - $start;

$start = now;
for ^$iterations {
    euclidean-distance($large-vec1c, $large-vec2c);
}
my $c-large-euclidean-time = now - $start;

say "Total Cosine Distance Time             : {$large-cosine-time}s";
say "Average Cosine Distance Time           : {$large-cosine-time / $iterations}s";
say "Total Cosine Distance Time CArray      : {$c-large-cosine-time}s";
say "Average Cosine Distance Time CArray    : {$c-large-cosine-time / $iterations}s";
say "Total Euclidean Distance Time          : {$large-euclidean-time}s";
say "Average Euclidean Distance Time        : {$large-euclidean-time / $iterations}s";
say "Total Euclidean Distance Time CArray   : {$c-large-euclidean-time}s";
say "Average Euclidean Distance Time CArray : {$c-large-euclidean-time / $iterations}s";