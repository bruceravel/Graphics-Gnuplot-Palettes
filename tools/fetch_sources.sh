#!/bin/sh

fetcher=wget
## fetcher="curl -O -J"

## Moreland
$fetcher http://www.kennethmoreland.com/color-advice/bent-cool-warm/bent-cool-warm-table-float-0032.csv
$fetcher http://www.kennethmoreland.com/color-advice/black-body/black-body-table-float-0032.csv
$fetcher http://www.kennethmoreland.com/color-advice/extended-black-body/extended-black-body-table-float-0032.csv
$fetcher http://www.kennethmoreland.com/color-advice/extended-kindlmann/extended-kindlmann-table-float-0032.csv
$fetcher http://www.kennethmoreland.com/color-advice/kindlmann/kindlmann-table-float-0032.csv
$fetcher http://www.kennethmoreland.com/color-advice/smooth-cool-warm/bent-cool-warm-table-float-0032.csv

## CET
$fetcher http://peterkovesi.com/projects/colourmaps/CETperceptual_ParaView.xml
