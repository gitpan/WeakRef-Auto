package WeakRef::Auto;

use 5.008_001;
use strict;

our $VERSION = '0.01';

use Exporter qw(import);
our @EXPORT = qw(autoweaken);

sub autoweaken(\$);

use XSLoader;
XSLoader::load(__PACKAGE__, $VERSION);

1;
__END__

=head1 NAME

WeakRef::Auto -  Automatically makes references weaken

=head1 VERSION

This document describes WeakRef::Auto version 0.01.

=head1 SYNOPSIS

	use WeakRef::Auto;

	autoweaken my $ref; # $ref is always weaken

	$ref = \$var; # $ref is weak

=head1 DESCRIPTION

C<WeakRef::Auto> provides C<autoweaken()>, which keeps references weaken.

=head1 FUNCTIONS

=head2 autoweaken($var)

Turns I<$var> into auto-weaken variables, and keeps the values weak
references.

I<$var> can be an element of hashes or arrayes.

NOTE: the prototype of C<autoweaken()> is C<"\$">. That is,
C<autoweakn($var)> means C<&autoweaken(\$var)>. 

=head1 DEPENDENCIES

Perl 5.8.1 or later.

=head1 BUGS AND LIMITATIONS

C<autoweaken()> does not work with tied variables, because autoweaken-ness is
attached to the variable, not to the value refered by the variable, and tied
variables iteract with their objects by values, not variables.

	my $x = tie my %hash, 'Tie::StdHash';
	autoweaken $hash{foo};
	# $hash{foo} seems autoweaken. Really?
	# Actually, $hash{foo} is connected to $x->{foo},
	# but there is no way to autoweaken($x->{foo}).


Patches are welcome.

=head1 SEE ALSO

L<Scalar::Util> for a description of weak references.

=head1 AUTHOR

Goro Fuji E<lt>gfuji(at)cpan.orgE<gt>.

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2008, Goro Fuji E<lt>gfuji(at)cpan.orgE<gt>.
Some rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
