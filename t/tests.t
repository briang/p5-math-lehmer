#!/usr/bin/perl

use 5.006; use strict; use warnings;
# use Data::Dump;

use Test::More;

use Math::Lehmer;

subtest "can determine the length of lehmer codes" => sub {
    my @tests = (
        [0, 1],
        [1, 2],
        [2, 3],
        [3, 3],
        [4, 3],
        [5, 3],
        [6, 4],
        [7, 4],
        [23, 4],
        [24, 5],
    );

    for my $t (@tests) {
        my ($int, $length) = @$t;
        is Math::Lehmer::_length_of_lehmer($int), $length,
          "length of lehmer($int) is $length";
    }
};

my @to_from_tests = (
    [    0,                   [0] ],
    [    1,                [1, 0] ],
    [    2,             [1, 0, 0] ],
    [   16,          [2, 2, 0, 0] ],
    [  123,    [1, 0, 0, 1, 1, 0] ],
    [ 1234, [1, 4, 1, 1, 2, 0, 0] ],
);

subtest "can convert from int to lehmer code" => sub {
    for my $t (@to_from_tests) {
        my ($int, $lehmer) = @$t;
        is_deeply to_lehmer($int), $lehmer, "lehmer($int) is [@$lehmer]" ;
    }
};

subtest "can convert from lehmer code to int" => sub {
    for my $t (@to_from_tests) {
        my ($int, $lehmer) = @$t;
        is from_lehmer($lehmer), $int, "int([@$lehmer]) is $int" ;
    }
};

done_testing;
