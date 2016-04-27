#!/usr/bin/perl

## download the float color tables from http://www.kennethmoreland.com/color-advice/
## I used the 32 tables but this script will work with any of them:

## wget http://www.kennethmoreland.com/color-advice/bent-cool-warm/bent-cool-warm-table-float-0032.csv
## wget http://www.kennethmoreland.com/color-advice/black-body/black-body-table-float-0032.csv
## wget http://www.kennethmoreland.com/color-advice/extended-black-body/extended-black-body-table-float-0032.csv
## wget http://www.kennethmoreland.com/color-advice/extended-kindlmann/extended-kindlmann-table-float-0032.csv
## wget http://www.kennethmoreland.com/color-advice/kindlmann/kindlmann-table-float-0032.csv
## wget http://www.kennethmoreland.com/color-advice/smooth-cool-warm/bent-cool-warm-table-float-0032.csv


use strict;
use warnings;

use List::Util qw(min);
use Text::Template;

my $tmpl = Text::Template->new(TYPE=>'FILE', SOURCE=>'module.tmpl')
  or die "Couldn't construct template: $Text::Template::ERROR";
my $copyright;
{
  local $/;
  $copyright = (<DATA>);
}


opendir(my $HERE, '.');
my @list = sort grep {$_ =~ m{csv\z}} readdir $HERE;
closedir $HERE;

foreach my $f (@list) {

  my $fname = $f;
  $fname =~ s{-table-float-0032.csv}{};
  my @parts = split(/-/, $fname);
  $fname = q{};
  foreach my $p (@parts) {
    $fname .= ucfirst($p);
  };
  print $fname, "\t", $f, $/;

  open my $fh, '<', $f;
  my $palette = "defined (\\\n";
  foreach my $l (<$fh>) {
    next if ($l =~ m{\Ascalar});
    $palette .= sprintf("  %8.6f  %8.6f  %8.6f  %8.6f,\\\n", map {min($_, 1)} split(/,/, $l)); # smooth-cool-warm has a value >1 -- yikes!
  };
  chop $palette;
  chop $palette;
  chop $palette;
  $palette .= "\\\n)";
  close $fh;

  mkdir '../lib/Graphics/Gnuplot/Palettes/Moreland/' if not -d '../lib/Graphics/Gnuplot/Palettes/Moreland/';
  open(my $PM, '>', '../lib/Graphics/Gnuplot/Palettes/Moreland/'.$fname.'.pm');
  print $PM $tmpl->fill_in(HASH => {group=>'Moreland', name=>$fname, palette=>$palette, copyright=>$copyright});
  close $PM;
};





__DATA__
 Palette from Kenneth Moreland
 http://www.kennethmoreland.com/color-advice/
 .
 "Why We Use Bad Color Maps and What You Can Do About It."  See also
 Kenneth Moreland. In Proceedings of Human Vision and Electronic Imaging
 (HVEI), 2016. (To appear)
 .
 Converted for use with Gnuplot from Perl by Bruce Ravel
