#!/usr/bin/perl

## wget http://peterkovesi.com/projects/colourmaps/CETperceptual_ParaView.xml

use strict;
use warnings;
use Text::Template;

use XML::LibXML;

my $tmpl = Text::Template->new(TYPE=>'FILE', SOURCE=>'module.tmpl')
  or die "Couldn't construct template: $Text::Template::ERROR";



open my $fh, '<', 'CETperceptual_ParaView.xml';
binmode $fh; # drop all PerlIO layers possibly created by a use open pragma
my $doc = XML::LibXML->load_xml(IO => $fh);

my %map = (cyclic=>'C', diverging=>'D', isoluminant=>'I', linear=>'L', rainbow=>'RB');
my $mapre = join("|", keys(%map));

my $copyright = (<DATA>);

foreach my $map ($doc->findnodes('//ColorMap')) {
  my ($name) = $map->findnodes('./@name');

  my $fname = $name->to_literal;
  $fname =~ s{[-_]c?\d+}{}g;
  $fname =~ s{($mapre)}{$map{$1}}g;
  $fname =~ s{-}{_}g;
  print $fname, "\t", $name->to_literal, "\n";
  open(my $PM, '>', '../lib/Graphics/Gnuplot/Palettes/CET/'.$fname.'.pm');

  #next if ($name->to_literal ne 'diverging_bwr_40-95_c42');

  my @list = ();
  foreach my $point ($map->findnodes('./Point')) {
    #print ++$count, "\n";
    my $x = $point->findnodes('./@x')->to_literal->value;
    push @list, sprintf "  %8.6f  %8.6f  %8.6f  %8.6f",
      $x,
      $point->findnodes('./@r')->to_literal,
      $point->findnodes('./@g')->to_literal,
      $point->findnodes('./@b')->to_literal;
  };

  my $palette = "defined (\\\n";
  foreach my $l (@list) {
    if ($l eq $list[-1]) {
      $palette .= $l . "\\\n";
    } else {
      $palette .= $l . ",\\\n";
    };
  };
  $palette .= ")";

  mkdir '../lib/Graphics/Gnuplot/Palettes/CET/' if not -d '../lib/Graphics/Gnuplot/Palettes/CET/';
  print $PM $tmpl->fill_in(HASH => {group=>'CET', name=>$fname, palette=>$palette, copyright=>$copyright});

  close $PM;
};


__DATA__
 Used under the terms of the Creative Commons BY License
 http://creativecommons.org/licenses/by/4.0/
 .
 Peter Kovesi
 Good Colour Maps: How to Design Them.
 arXiv:1509.03700 [cs.GR] 2015
 and
 http://peterkovesi.com/projects/colourmaps/
 .
 Converted for use with Gnuplot from Perl by Bruce Ravel
