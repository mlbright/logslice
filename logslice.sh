#!/bin/bash
set -e

# regex='\[(\d+\/\w+\/\d\d\d\d:\d\d:\d\d:\d\d\.\d+)\]'
regex='^([A-Za-z]+ \d+ \d\d:\d\d:\d\d) '
# format='%d/%B/%Y:%T.%3N'
format='%b %d %T'

time wc -l sample.log

time perl logslice-binary-search.pl \
  --year=2019 \
  --regex="$regex" \
  --begin="2019-02-20T06:00:00" \
  --end="2019-02-23T07:00:00" \
  --format="$format" < sample.log | wc -l

time perl logslice-naive.pl \
  --year=2019 \
  --regex="$regex" \
  --begin="2019-02-20T06:00:00" \
  --end="2019-02-23T07:00:00" \
  --format="$format" < sample.log | wc -l
