#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 48;

use PDL::Lite;
use PDL::IO::FlexRaw;
use PDL::NiceSlice;
use PDL::Graphics::Gnuplot;

use Graphics::Gnuplot::Palettes qw(palette palette_names);

$SIG{__WARN__} = sub { 1 };
$SIG{__DIE__}  = sub { 1 };


my $pi    = 3.14159;
my $theta = PDL::Core::zeros(200)->xlinvals(0, 6*$pi);
my $z     = PDL::Core::zeros(200)->xlinvals(0, 5);

BEGIN {
    use_ok( 'Graphics::GnuplotIF' );
}

unless( _is_interactive() and
        get_ans("Do you want to run the (brief but interactive) tests?", 'y') ) {
  #for (1..$tests-1) { ok(1) }
  done_testing();
  exit;
}

my $pal = palette("Palette name: Pm3d");
my $pdl = Read('image.tif');
my $w   = PDL::Graphics::Gnuplot -> new();

my $term = q{};
if (PDL::Graphics::Gnuplot::terminfo =~ m{The default P::G::G window is currently using the '(\w+)' terminal}) {
  $term = $1;
  $w->output("$term 1");
};
ok($term, "Recognized terminal");


$w->image({palette=>$pal, title=>"Pm3d",
	   xlabel=>'pixels (width)', ylabel=>'pixels (height)', cblabel=>'counts', ymin=>194, ymax=>0, size=>'ratio 0.4'},
	  $pdl);
if (get_ans("(Pm3d) Is this a plot with a black-blue-red-yellow color palette?", 'y') ) {
  ok(1, 'Pm3d');
} else {
  ok(0, 'Pm3d');
};


$w->output("$term 2");
foreach my $p (palette_names()) {
  next if ($p eq "Pm3d");
  $pal = palette($p);
  (my $t = $p) =~ s{_}{\\\\_}g;
  $w->image({palette=>$pal, title=>"Palette name: $t",
	     xlabel=>'pixels (width)', ylabel=>'pixels (height)', cblabel=>'counts', ymin=>194, ymax=>0, size=>'ratio 0.4'},
	    $pdl);
  if (get_ans("($p) Did this plot and is this color palette different from the original?", 'y') ) {
    ok(1, $p);
  } else {
    ok(0, $p);
  };
};

diag(q{});
diag("Hit 'q' in each plot window to dismiss them.");
diag(q{});



sub Read {
  my ($file) = @_;
  my $bytes =  -s $file;
  my $longs = $bytes / 4;
  my $img  = readflex($file, [ { Type=>'long', NDims=>1, Dims=>[$longs] } ]);
  my $im2d = $img(1024:-1)->splitdim(0,487);
  $im2d->badflag(1);
  return $im2d;
};


## copied (also without comments) from Term::Twiddle
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
