package Math::Lehmer;

use 5.006;
use strict;
use warnings;

use List::Util qw'sum product';

=head1 NAME

Math::Lehmer - convert between integers and their Lehmer codes

=head1 VERSION

Version 0.001

=cut

our $VERSION = '0.001';

=head1 SYNOPSIS

    use Math::Lehmer;

    my $lehmer = to_lehmer(1234); # [ 1, 4, 1, 1, 2, 0, 0 ]
    say from_lehmer($lehmer);     # 1234

=head1 DESCRIPTION

Conventionally, we use base-10 (decimal) numbers and, in computing,
base-2 (binary) and base-16 (hexadecimal) numbers are common.

Lehmer codes (see L</REFERENCES>) are another way of representating
integer values.

In a decimal integer, as we move from rightmost digit to the leftmost,
the weighting increases by a factor of 10. Binary numbers increase by
2, and hex numbers by 16.

Lehmer codes use a factorial-based weighting for the digits, with the
least-significant digit having a weighting of 0!, the next having a
weighting of 1! and so on. Given that 0! and 1! are equal, the
right-most digit is always 0.

For example, the lemer code for decimal 16 is 2, 2, 0, 0:

    factorials:         3!  2!  1!  0!
    decimal weighting:  6   2   0   0
                        2   2   0   0 =  2*6 + 2*2
                                      =  16 decimal

and, decimal 123 converts to 1, 0, 0, 1, 1, 0:

    factorials:          5!  4!  3!  2!  1!  0!
    decimal weighting:  120  24   6   2   0   0
                          1   0   0   1   1   0  =  120 + 2 + 1
                                                 =  123 decimal

=head1 EXPORT

Two functions are exported: C<to_lehmer> and C<from_lehmer>.

=cut

require Exporter;
our @ISA = 'Exporter';
our @EXPORT = qw( from_lehmer to_lehmer );

=head1 FUNCTIONS

=head2 from_lehmer($lehmer): $integer

=cut

sub from_lehmer {
    my @lehmer = @{+shift};
    my $f = 0;
    return sum map { product pop @lehmer, 2..$f++ } 1..@lehmer;
}

=head2 to_lehmer($integer): $lehmer

=cut

sub to_lehmer {
    my $n = shift;

    return [ _to_lehmer($n, _length_of_lehmer($n)) ];
}

sub _length_of_lehmer {
    my $n = shift;

    my $k = my $factorial = 1;

    while (1) {
        $factorial *= $k++;
        last if $factorial > $n
    }

    return $k - 1;
}

sub _to_lehmer {
    my ($n, $max_factorial)  = @_;
    return 0 if $max_factorial <= 1;

    my $multiplier = product 2.. $max_factorial - 1;
    my $digit = int $n / $multiplier;
    return $digit,
           _to_lehmer($n % $multiplier, $max_factorial - 1);
}

=head1 AUTHOR

Brian Greenfield, C<< <briang at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-math-lehmer at
rt.cpan.org>, or through the web interface at
L<https://rt.cpan.org/NoAuth/ReportBug.html?Queue=Math-Lehmer>.  I
will be notified, and then you'll automatically be notified of
progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Math::Lehmer

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<https://rt.cpan.org/NoAuth/Bugs.html?Dist=Math-Lehmer>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Math-Lehmer>

=item * CPAN Ratings

L<https://cpanratings.perl.org/d/Math-Lehmer>

=item * Search CPAN

L<https://metacpan.org/release/Math-Lehmer>

=back

=head1 REFERENCES

Wikipedia, L<Lehmer code|https://en.wikipedia.org/wiki/Lehmer_code>

2ality.com, L<Encoding permutations as integers via the Lehmer
code|https://2ality.com/2013/03/permutations.html>

Stack Overflow, L<Fast permutations -E<gt> number -E<gt> permutation
mapping
algorithms|https://stackoverflow.com/questions/1506078/fast-permutations-number-permutation-mapping-algorithms>

keithschwarz.com, L<factoradic
permutation|http://keithschwarz.com/code/?dir=factoradic-permutation>

=head1 LICENSE AND COPYRIGHT

This software is copyright (c) 2019 by Brian Greenfield.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

1;
