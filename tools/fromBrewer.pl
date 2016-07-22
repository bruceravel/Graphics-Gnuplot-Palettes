#!/usr/bin/perl

## git clone https://github.com/aschn/gnuplot-colorbrewer.git

use strict;
use warnings;

use File::Spec;
use List::Util qw(min);
use Text::Template;


my $location = '/home/bruce/source/gnuplot-colorbrewer/';

my $tmpl = Text::Template->new(TYPE=>'FILE', SOURCE=>'module.tmpl')
  or die "Couldn't construct template: $Text::Template::ERROR";
my $copyright;
{
  local $/;
  $copyright = (<DATA>);
}

foreach my $subdir (qw(diverging qualitative sequential)) {

  opendir(my $HERE, File::Spec->catfile($location, $subdir));
  my @list = sort grep {$_ =~ m{plt\z}} readdir $HERE;
  closedir $HERE;

  foreach my $f (@list) {
    my $fname = File::Spec->catfile($location, $subdir, $f);
    open my $fh, '<', $fname;
    my $flag = 0;
    my $palette = q{};
    while (<$fh>) {
      $flag = 1 if ($_ =~ m{\Aset palette defined});
      if ($flag) {
	$palette .= $_;
      };
    };
    $palette =~ s{,\\\s+}{, }g;
    $palette =~ s{\n\z}{};
    $palette =~ s{\'}{"}g;
    $palette =~ s{set palette }{};
    close $fh;

    mkdir '../lib/Graphics/Gnuplot/Palettes/Brewer/' if not -d '../lib/Graphics/Gnuplot/Palettes/Brewer/';
    (my $ff = $f) =~ s{\.plt\z}{};
    #print '../lib/Graphics/Gnuplot/Palettes/Brewer/'.$ff.'.pm', $/;
    open(my $PM, '>', '../lib/Graphics/Gnuplot/Palettes/Brewer/'.ucfirst($subdir).'_'.$ff.'.pm');
    print $PM $tmpl->fill_in(HASH => {group=>'Brewer', name=>ucfirst($subdir).'_'.$ff, palette=>$palette, copyright=>$copyright});
    close $PM;

  };

};


1;

__DATA__
 Palette from gnuplot-colorbrewer, https://github.com/aschn/gnuplot-colorbrewer
 .
 gnuplot-colorbrewer is released under the Apache License 2.0, as is
 ColorBrewer.
 .
 Copyright 2013 Anna Schneider
 .
 Licensed under the Apache License, Version 2.0 (the "License"); you
 may not use this file except in compliance with the License. You may
 obtain a copy of the License at
 .
 http://www.apache.org/licenses/LICENSE-2.0
 .
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
 implied. See the License for the specific language governing
 permissions and limitations under the License.
 .
 Converted for use with Gnuplot from Perl by Bruce Ravel
