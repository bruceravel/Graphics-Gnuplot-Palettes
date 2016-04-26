#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 1;

use PDL::Lite;
use PDL::IO::FlexRaw;
use PDL::NiceSlice;
use PDL::Graphics::Gnuplot;

use Graphics::Gnuplot::Palettes;

my $pi    = 3.14159;
my $theta = PDL::Core::zeros(200)->xlinvals(0, 6*$pi);
my $z     = PDL::Core::zeros(200)->xlinvals(0, 5);

local $|=1;


my $pal = palette("D_L_bjy");

my $pdl = Read('image.tif');


my $w = PDL::Graphics::Gnuplot -> new();
$w->image({palette=>$pal, title=>"Image",
	   xlabel=>'pixels (width)', ylabel=>'pixels (height)', cblabel=>'counts', ymin=>194, ymax=>0, size=>'ratio 0.4'},
	  $pdl);
ok(1, 'blah');

print $/;
print $PDL::Graphics::Gnuplot::last_plotcmd;


sub Read {
  my ($file) = @_;
  my $bytes =  -s $file;
  my $longs = $bytes / 4;

  my $img  = readflex($file, [ { Type=>'long', NDims=>1, Dims=>[$longs] } ]);
  my $im2d = $img(1024:-1)->splitdim(0,487);
  $im2d->badflag(1);
  #$im2d->inplace->setvaltobad(0);
  my ($c, $r) = $im2d->dims;
  #$self->fetch_metadata;
  return $im2d;
};
