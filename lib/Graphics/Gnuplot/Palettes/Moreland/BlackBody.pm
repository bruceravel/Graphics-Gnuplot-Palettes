package Graphics::Gnuplot::Palettes::Moreland::BlackBody;

=for Copyright
 .
 Palette from Kenneth Moreland
 http://www.kennethmoreland.com/color-advice/
 .
 "Why We Use Bad Color Maps and What You Can Do About It."  See also
 Kenneth Moreland. In Proceedings of Human Vision and Electronic Imaging
 (HVEI), 2016. (To appear)
 .
 Converted for use with Gnuplot from Perl by Bruce Ravel


=cut

use strict;
use base qw( Exporter );

our @EXPORT_OK = qw($BlackBody);
our $BlackBody = 'defined (\
  0.000000  0.000000  0.000000  0.000000,\
  0.032258  0.085791  0.030987  0.017333,\
  0.064516  0.133175  0.058869  0.034680,\
  0.096774  0.180002  0.073069  0.051539,\
  0.129032  0.229816  0.084060  0.064781,\
  0.161290  0.281398  0.093913  0.075409,\
  0.193548  0.334522  0.102639  0.084245,\
  0.225806  0.388958  0.110254  0.092799,\
  0.258065  0.444612  0.116733  0.101403,\
  0.290323  0.501422  0.122026  0.110058,\
  0.322581  0.559331  0.126068  0.118768,\
  0.354839  0.618286  0.128768  0.127532,\
  0.387097  0.678238  0.130007  0.136351,\
  0.419355  0.712850  0.181722  0.130817,\
  0.451613  0.743632  0.232650  0.120992,\
  0.483871  0.774325  0.279316  0.108090,\
  0.516129  0.804936  0.323627  0.090796,\
  0.548387  0.835473  0.366525  0.066236,\
  0.580645  0.865943  0.408541  0.026029,\
  0.612903  0.876634  0.464020  0.017307,\
  0.645161  0.883455  0.518984  0.014963,\
  0.677419  0.889052  0.572164  0.013500,\
  0.709677  0.893376  0.624109  0.013033,\
  0.741935  0.896370  0.675180  0.013680,\
  0.774194  0.897974  0.725631  0.015556,\
  0.806452  0.898117  0.775643  0.018777,\
  0.838710  0.896720  0.825351  0.023459,\
  0.870968  0.927670  0.859991  0.319086,\
  0.903226  0.956159  0.893933  0.503317,\
  0.935484  0.978271  0.928565  0.671307,\
  0.967742  0.993196  0.963913  0.835609,\
  1.000000  1.000000  1.000000  1.000000\
)';

1