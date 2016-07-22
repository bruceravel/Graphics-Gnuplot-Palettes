package Graphics::Gnuplot::Palettes::Brewer::Accent;

=for Copyright
 .
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


=cut

use strict;
use base qw( Exporter );

our @EXPORT_OK = qw($Accent);
our $Accent = 'set palette defined ( 0 "#7FC97F", 1 "#BEAED4", 2 "#FDC086", 3 "#FFFF99", 4 "#386CB0", 5 "#F0027F", 6 "#BF5B17", 7 "#666666" )';

1;
