use v6.d;

unit module Math::DistanceFunctions::Native;

use NativeCall;
use NativeHelpers::Array;

my constant $library = %?RESOURCES<libraries/DistanceFunctions>;

sub SquaredEuclideanDistance(CArray[num64], CArray[num64], int32 --> num64) is native($library) {*}

sub EuclideanDistance(CArray[num64], CArray[num64], int32 --> num64) is native($library) {*}

sub CosineDistance(CArray[num64], CArray[num64], int32 --> num64) is native($library) {*}

sub DotProduct(CArray[num64], CArray[num64], int32 --> num64) is native($library) {*}

sub VectorNorm(CArray[num64], int32, Str --> num64) is native($library) {*}

#-----------------------------------------------------------
our proto sub squared-euclidean-distance($v1, $v2 --> Numeric:D) is export {*}

multi sub squared-euclidean-distance($v1, $v2 --> Numeric:D) {
    if !(($v1 ~~ Positional:D) && ($v2 ~~ Positional:D) && $v1.elems == $v2.elems) {
        die "The arguments are expected to be both numeric arrays of the same length.";
    }
    return SquaredEuclideanDistance(
            $v1 ~~ CArray ?? $v1 !! copy-to-carray($v1, num64),
            $v2 ~~ CArray ?? $v2 !! copy-to-carray($v2, num64),
            $v1.elems);
}


#-----------------------------------------------------------
our proto sub euclidean-distance($v1, $v2 --> Numeric:D) is export {*}

multi sub euclidean-distance($v1, $v2 --> Numeric:D) {
    if !(($v1 ~~ Positional:D) && ($v2 ~~ Positional:D) && $v1.elems == $v2.elems) {
        die "The arguments are expected to be both numeric arrays of the same length.";
    }
    return EuclideanDistance(
            $v1 ~~ CArray ?? $v1 !! copy-to-carray($v1, num64),
            $v2 ~~ CArray ?? $v2 !! copy-to-carray($v2, num64),
            $v1.elems);
}

#-----------------------------------------------------------
our proto sub cosine-distance($v1, $v2 --> Numeric:D) is export {*}

multi sub cosine-distance($v1, $v2 --> Numeric:D) {
    if !(($v1 ~~ Positional:D) && ($v2 ~~ Positional:D) && $v1.elems == $v2.elems) {
        die "The arguments are expected to be both numeric arrays of the same length.";
    }
    return CosineDistance(
            $v1 ~~ CArray ?? $v1 !! copy-to-carray($v1, num64),
            $v2 ~~ CArray ?? $v2 !! copy-to-carray($v2, num64),
            $v1.elems);
}

#-----------------------------------------------------------
our proto sub dot-product($v1, $v2 --> Numeric:D) is export {*}

multi sub dot-product($v1, $v2 --> Numeric:D) {
    if !(($v1 ~~ Positional:D) && ($v2 ~~ Positional:D) && $v1.elems == $v2.elems) {
        die "The arguments are expected to be both numeric arrays of the same length.";
    }
    return DotProduct(
            $v1 ~~ CArray ?? $v1 !! copy-to-carray($v1, num64),
            $v2 ~~ CArray ?? $v2 !! copy-to-carray($v2, num64),
            $v1.elems);
}

#-----------------------------------------------------------
our proto sub norm(| --> Numeric:D) is export {*}

multi sub norm(:v(:$vector)!, Str:D :p(:$type) = '2' --> Numeric:D) {
    return norm($vector, :$type);
}

multi sub norm($v, Str:D :p(:$type) = '2' --> Numeric:D) {

    if !(($v ~~ Positional:D) && ($v.all ~~ Numeric:D)) {
        die "The first argument is expected to be a numeric array.";
    }
    return VectorNorm($v ~~ CArray:D ?? $v !! copy-to-carray($v, num64), $v.elems, $type);
}