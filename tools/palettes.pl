#!/usr/bin/perl

use strict;
use warnings;

use File::Basename;
use File::Spec;

use PDL::Lite;
use PDL::IO::FlexRaw;
use PDL::NiceSlice;
use PDL::Graphics::Gnuplot;

use Graphics::Gnuplot::Palettes qw(palette palette_names);

## PDL::Graphics::Gnuplot calls PDL::Core::barf and prints to STDERR
## rather a lot, these tests are extremely unlikely to run to
## completion unless that behavior is disabled.  See also the
## redefinition of barf in the P::G::G package at the end of this file
$SIG{__WARN__} = sub { 1 };
$SIG{__DIE__}  = sub { 1 };




my $w   = PDL::Graphics::Gnuplot -> new();
my $term = q{};
my @topts = split(" ", $w->{options}->{terminal});
$term = $topts[0];
$w->output("$term 1") if $term;

my @properties = (xlabel=>'pixels (width)', ylabel=>'pixels (height)', cblabel=>'counts',
		  ymin=>194, ymax=>0, size=>'ratio 0.4');


SKIP: {

  my $pdl = Read('/home/bruce/git/Graphics-Gnuplot-Palettes/t/image.tif');

  ## plot image in default palette
  $w->image({palette=>palette("Pm3d"), title=>"Palette name: Pm3d", @properties}, $pdl);
  $w->image({hardcopy=>File::Spec->catfile('_images', 'palettes', 'Pm3d.png'), palette=>palette('Pm3d'), title=>"Palette name: Pm3d", @properties}, $pdl);

  ## plot image using all remaining palette in a second window for visual comparison
  foreach my $p (palette_names()) {
    next if ($p eq "Pm3d");
    (my $t = $p) =~ s{_}{\\\\_}g;
    my $posneg = ($p =~ m{Sequential}) ? 'negative ' : 'positive ';
    $w->image({palette=>$posneg.palette($p), title=>"Palette name: $t", @properties}, $pdl);
    $w->image({hardcopy=>File::Spec->catfile('_images', 'palettes', $p.'.png'), palette=>$posneg.palette($p), title=>"Palette name: $t", @properties}, $pdl);
  };

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


package PDL::Graphics::Gnuplot;
{
  no warnings 'redefine';
  sub barf { goto &Carp::cluck };
}
