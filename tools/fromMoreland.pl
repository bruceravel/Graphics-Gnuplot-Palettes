#!/usr/bin/perl

use strict;
use warnings;

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
    $palette .= sprintf("  %8.6f  %8.6f  %8.6f  %8.6f,\\\n", split(/,/, $l));
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
