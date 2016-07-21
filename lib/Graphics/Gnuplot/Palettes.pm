package Graphics::Gnuplot::Palettes;

use strict;
use warnings;

use List::MoreUtils qw(any);
use File::Basename;
use File::Spec;
use base qw(Exporter);

our @EXPORT = qw(palette);
our @EXPORT_OK = qw(palette_groups palette_names);

my @groups = ();
my %palettes = ();

my $here = $INC{'Graphics/Gnuplot/Palettes.pm'};
opendir(my $H, File::Spec->catfile(dirname($here), 'Palettes'));
@groups = grep {$_ !~ m{\A\.}} readdir $H;
closedir $H;

foreach my $g (@groups) {
  opendir(my $H, File::Spec->catfile(dirname($here), 'Palettes', $g));
  my @keys = grep {$_ =~ s{\.pm}{}} grep {$_ =~ m{\.pm\z}} readdir $H;
  closedir $H;
  $palettes{$g} = [];
  foreach my $k (@keys) {
    eval "use Graphics::Gnuplot::Palettes::".$g."::".$k." (qw/\$$k/);"; # works on perl 5.14
    #eval "use Graphics::Gnuplot::Palettes::$g::$k (qw/\$$k/);";
    push @{$palettes{$g}}, $k;
  };
};


sub palette {
  my ($group, $name);
  if ($#_ == 0) {
    $name = $_[0];
  } elsif ($#_ > 0) {
    ($group, $name) = @_;
  } else {
    return "rgbformulae 7,5,15";
  };
  if ($group and exists($palettes{$group}->{$name})) {
    my $retval = join("::", "\$Graphics::Gnuplot::Palettes", $group, $name, $name);
    return eval "$retval";
    #return eval "\$Graphics::Gnuplot::Palettes::$group::$name::$name";
  } else{
    foreach my $g (@groups) {
      if (any {$_ eq $name} @{$palettes{$g}}) {
	my $retval = join("::", "\$Graphics::Gnuplot::Palettes", $g, $name, $name);
	return eval "$retval";
	#return eval "\$Graphics::Gnuplot::Palettes::$g::$name::$name";
      };
    };
  };
  return "rgbformulae 7,5,15";
};

sub palette_groups {
  return @groups;
};

sub palette_names {
  my ($gp) = @_;
  return @{$palettes{$gp}} if ($gp);
  my @all = ();
  foreach my $g (@groups) {
    push @all, sort @{$palettes{$g}};
  };
  return @all;
};


1;

=head1 NAME

Graphics::Gnuplot::Palettes - A tool for managing Gnuplot surface plot palettes with Perl

=head1 VERSION

1.00

=head1 DESCRIPTION

Gnuplot has a powerful and flexible way of managing color maps for
surface plots, but it's a pain to use.  Good color maps tend to
require rather lengthy descriptions.  The purpose of this package is
to remove some of the friction when using any of perl's various tools
for interacting with Gnuplot.  Using various collections of
high-quality color maps, this package allows simple access by name.

Each color map is represented by a small perl module which defines and
exports a named string containing the text expected by Gnuplot to
define the color map.  In this way, it is easy quick and easy to
switch between color maps.

=head1 FUNCTIONS

=over 4

=item C<palette> (exported by default)

Return the palette definition for use with gnuplot.

  my $pal = palette($name);

where C<$name> is one of the names returned by C<palette_names>.

This searches through all groups for a palette with $name.  In the
case of a name collision, it returns the first one it finds.  A
two-argument form can be used to resolve a name collision:

  my $pal = palette($group, $name);

where C<$group> is one of the names returned by C<palette_groups> and
C<$name> is one of the names returned by C<palette_names>.

If the group or name cannot be resolved, this function returns the
"Gnuplot-->Pm3d" palette, which is C<rgbformulae 7,5,15>.

Note that this is the palette definition.  The string "set palette" is
not returned by the C<palette> function.  So, to make a suitable
command for Gnuplot, you would have to do something like:

  printf "set palette %s\n", palette($name);

=item C<palette_groups> (can be exported)

Return a list of all palette groups, currently : Gnuplot, CET,
Moreland, and Matlab>

=item C<palette_names> (can be exported)

Return a list of all palette names.  This makes no effort to handle
palette name collisions, should any exist.  (Which do not, at this
time.)

The one-argument form returns the names in a specific group.

  my @list = palette_names("Moreland");

returns

  ("BentCoolWarm", "BlackBody", "ExtendedBlackBody", "ExtendedKindlmann.pm",
   "Kindlmann.pm", "SmoothCoolWarm")

=back

=head1 DEPENDENCIES

Testing relies upon: L<PDL>, L<PDL::Lite>, L<PDL::IO::FlexRaw>, and
L<PDL::Graphics::Gnuplot>.

All other dependencies are to standard library modules.

=head1 MORE PALETTES

Incorporating the palettes from http://colorbrewer2.org/ and
https://github.com/aschn/gnuplot-colorbrewer would be great.

There are several nice palettes at
https://datascience.lanl.gov/colormaps.html

Matplotlib's color map library:
http://scipy-cookbook.readthedocs.org/items/Matplotlib_Show_colormaps.html

=head1 BUGS AND LIMITATIONS

Please report problems as issues at the github site
L<https://github.com/bruceravel/BLA-XANES>

Patches are welcome.

=head1 AUTHOR

Bruce Ravel (bravel AT bnl DOT gov)

L<http://github.com/bruceravel/BLA-XANES>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2016 Bruce Ravel.  All rights reserved.

This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself. See L<perlgpl>.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

=cut




