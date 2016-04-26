package Graphics::Gnuplot::Palettes::Matlab::Jet;

=for Copyright
 .
 Matlab color map parula, from
 http://www.gnuplotting.org/matlab-colorbar-parula-with-gnuplot/
 Creative Commons BY-NC
 For more information:
 http://www.mathworks.de/products/matlab/matlab-graphics/#new_look_for_matlab_graphics

=cut

use strict;
use base qw( Exporter );

our @EXPORT_OK = qw($Jet);
our $Jet = "defined ( 0 '#000090',\\
                      1 '#000fff',\\
                      2 '#0090ff',\\
                      3 '#0fffee',\\
                      4 '#90ff70',\\
                      5 '#ffee00',\\
                      6 '#ff7000',\\
                      7 '#ee0000',\\
                      8 '#7f0000')";

1;
