package Graphics::Gnuplot::Palettes;

use strict;
use warnings;

use List::MoreUtils qw(any);
use File::Basename;
use File::Spec;
use base qw(Exporter);

our @EXPORT = qw(palette palette_groups %palettes);

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
    eval "use Graphics::Gnuplot::Palettes::$g::$k (qw/\$$k/);";
    push @{$palettes{$g}}, $k;
  };
};


#use Data::Dump::Color;
#dd \%palettes;

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
    return eval "\$Graphics::Gnuplot::Palettes::$group::$name::$name";
  } else{
    foreach my $g (@groups) {
      if (any {$_ eq $name} @{$palettes{$g}}) {
	return eval "\$Graphics::Gnuplot::Palettes::$g::$name::$name";
      };
    };
  };
  return "rgbformulae 7,5,15";
};

sub palette_groups {
  return @groups;
};


1;
