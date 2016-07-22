package Graphics::Gnuplot::Palettes::Brewer::RdBu;

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

our @EXPORT_OK = qw($RdBu);
our $RdBu = 'set palette defined ( 0 "#B2182B", 1 "#D6604D", 2 "#F4A582", 3 "#FDDBC7", 4 "#D1E5F0", 5 "#92C5DE", 6 "#4393C3", 7 "#2166AC" )';

1;
