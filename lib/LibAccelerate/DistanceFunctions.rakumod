use v6.d;

unit module LibAccelerate::DistanceFunctions;

use NativeCall;
use NativeHelpers::Array;

my constant $library = %?RESOURCES<libraries/DistanceFunctions>;

sub SquaredEuclideanDistance(CArray[num64], CArray[num64], int32 --> num64) is native($library) {*}

sub EuclideanDistance(CArray[num64], CArray[num64], int32 --> num64) is native($library) {*}

sub CosineDistance(CArray[num64], CArray[num64], int32 --> num64) is native($library) {*}

sub DotProduct(CArray[num64], CArray[num64], int32 --> num64) is native($library) {*}

sub VectorNorm(CArray[num64], int32, Str --> num64) is native($library) {*}

#-----------------------------------------------------------
our sub squared-euclidean-distance(@v1, @v2 --> Numeric:D) is export {
    if !(@v1.elems == @v2.elems && (@v1.all ~~ Numeric:D) && (@v2.all ~~ Numeric:D) ) {
        die "The arguments are expected to be both numeric arrays of the same length.";
    }
    return SquaredEuclideanDistance(copy-to-carray(@v1, num64), copy-to-carray(@v2, num64), @v1.elems);
}

#-----------------------------------------------------------
our sub euclidean-distance(@v1, @v2 --> Numeric:D) is export {
    if !(@v1.elems == @v2.elems && (@v1.all ~~ Numeric:D) && (@v2.all ~~ Numeric:D) ) {
        die "The arguments are expected to be both numeric arrays of the same length.";
    }
    return EuclideanDistance(copy-to-carray(@v1, num64), copy-to-carray(@v2, num64), @v1.elems);
}

#-----------------------------------------------------------
our sub cosine-distance(@v1, @v2 --> Numeric:D) is export {
    if !(@v1.elems == @v2.elems && (@v1.all ~~ Numeric:D) && (@v2.all ~~ Numeric:D) ) {
        die "The arguments are expected to be both numeric arrays of the same length.";
    }
    return CosineDistance(copy-to-carray(@v1, num64), copy-to-carray(@v2, num64), @v1.elems);
}

#-----------------------------------------------------------
our sub dot-product(@v1, @v2 --> Numeric:D) is export {
    if !(@v1.elems == @v2.elems && (@v1.all ~~ Numeric:D) && (@v2.all ~~ Numeric:D) ) {
        die "The arguments are expected to be both numeric arrays of the same length.";
    }
    return DotProduct(copy-to-carray(@v1, num64), copy-to-carray(@v2, num64), @v1.elems);
}

#-----------------------------------------------------------
our proto sub norm(| --> Numeric:D) is export {*}

multi sub norm(:v(:@vector)!, Str:D :p(:$type) --> Numeric:D) {
    return norm(@vector, :$type);
}

multi sub norm(@v, Str:D :p(:$type) --> Numeric:D) {
    if !(@v.all ~~ Numeric:D) {
        die "The first argument is expected to be a numeric array.";
    }
    return VectorNorm(copy-to-carray(@v, num64), @v.elems, $type);
}