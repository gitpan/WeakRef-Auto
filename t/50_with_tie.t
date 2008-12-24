#!perl -w

use strict;
use Test::More tests => 4;

use WeakRef::Auto;
use Devel::Peek;

use Tie::Scalar;
use Tie::Hash;

my $ts;
tie $ts, 'Tie::StdScalar';


autoweaken $ts;
{
	my $t = [42];
	$ts = $t;
	is $ts, $t;
}

{
	local $TODO = 'autoweaken($tied_scalar) is not yet implemented';
	is $ts, undef;
}

my %thash;
tie %thash, 'Tie::StdHash';

autoweaken $thash{foo};

{
	my $t = [42];
	$thash{foo} = $t;
	is $thash{foo}, $t;
}
{
	local $TODO = 'autoweaken($tied_hash{foo}) is not yet implemented';
	is $thash{foo}, undef;
}
