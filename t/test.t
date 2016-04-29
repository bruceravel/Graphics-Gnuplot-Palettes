#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 51;

use File::Basename;
use File::Spec;

use PDL::Lite;
use PDL::IO::FlexRaw;
use PDL::NiceSlice;
use PDL::Graphics::Gnuplot;

## PDL::Graphics::Gnuplot calls PDL::Core::barf and prints to STDERR
## rather a lot, these tests are extremely unlikely to run to
## completion unless that behavior is disabled.  See also the
## redefinition of barf in the P::G::G package at the end of this file
$SIG{__WARN__} = sub { 1 };
$SIG{__DIE__}  = sub { 1 };


BEGIN {
  use_ok('Graphics::Gnuplot::Palettes', qw(palette palette_groups palette_names));
}


## introspection tests
my @groups = palette_groups;
is($#groups, 3, "correct number of groups");
my @names = palette_names;
is($#names, 45, "correct number of names");
@names = palette_names("Moreland");
is($#names, 5, "correct number of Moreland names");


my $w   = PDL::Graphics::Gnuplot -> new();
my $term = q{};
if (PDL::Graphics::Gnuplot::terminfo =~ m{The default P::G::G window is currently using the '(\w+)' terminal}) {
  $term = $1;
  $w->output("$term 1");
};
ok($term, "Recognized terminal");

my @properties = (xlabel=>'pixels (width)', ylabel=>'pixels (height)', cblabel=>'counts', ymin=>194, ymax=>0, size=>'ratio 0.4');


SKIP: {
  skip "Not running interactive tests", 46 unless ( _is_interactive() and
						    get_ans("Do you want to run the (brief but interactive) tests?", 'y') );

  my $pdl = Read(File::Spec->catfile(dirname($0),'image.tif'));

  ## plot image in default palette
  $w->image({palette=>palette("Pm3d"), title=>"Palette name: Pm3d", @properties}, $pdl);
  ok(get_ans("(Pm3d) Is this a plot with a black-blue-red-yellow color palette?", 'y'), 'Pm3d' );

  ## plot image using all remaining palette in a second window for visual comparison
  $w->output("$term 2");
  foreach my $p (palette_names()) {
    next if ($p eq "Pm3d");
    (my $t = $p) =~ s{_}{\\\\_}g;
    $w->image({palette=>palette($p), title=>"Palette name: $t", @properties}, $pdl);
    my $extra = q{};
    $extra = "\n(This one is pretty similar ... look closely!)" if ($p eq 'ExtendedBlackBody');
    ok(get_ans("($p) Was the plot made?  Is its color palette different from the original?$extra", 'y'), $p);
  };

  diag(q{});
  diag("Hit 'q' in each plot window to dismiss them.");
  diag(q{});
}

sub Read {
  my ($file) = @_;
  my $bytes =  -s $file;
  my $longs = $bytes / 4;
  my $img   = readflex($file, [ { Type=>'long', NDims=>1, Dims=>[$longs] } ]);
  my $im2d  = $img(1024:-1)->splitdim(0,487);
  $im2d->badflag(1);
  return $im2d;
};


## copied (without comments) from Term::Twiddle
sub get_ans {
    my $query   = shift;
    my $default = shift || 'y';
    my $ans     = shift || $default;

    print STDERR "$query [$ans]: ";
    chomp( $ans = <STDIN> );
    $ans = ( $ans ? $ans : $default );

    return $ans =~ /^$default/i;
}

# and copied (also without comments) from Term::Twiddle
# scottw: copied (also without comments) from IO::Prompt::Tiny
# Copied (without comments) from IO::Interactive::Tiny by Daniel Muey,
# based on IO::Interactive by Damian Conway and brian d foy
sub _is_interactive {
  my ($out_handle) = (@_, select);
  return 0 if not -t $out_handle;
  if ( tied(*ARGV) or defined(fileno(ARGV)) ) {
    return -t *STDIN if defined $ARGV && $ARGV eq '-';
    return @ARGV>0 && $ARGV[0] eq '-' && -t *STDIN if eof *ARGV;
    return -t *ARGV;
  } else {
    return -t *STDIN;
  }
}

package PDL::Graphics::Gnuplot;
{
  no warnings 'redefine';
  sub barf { goto &Carp::cluck };
}
