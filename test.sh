#!/bin/bash
set -e

time wc -l haproxy.log

time perl logslice.pl \
  --year=2019 \
  --regex='^([A-Za-z]+ \d+ \d\d:\d\d:\d\d) ' \
  --begin="2019-02-22T06:00:00" \
  --end="2019-02-22T07:00:00" \
  --format='%b %d %T' < haproxy.log | wc -l

time perl logslice.pl \
  --year=2019 \
  --regex='\[(\d+\/\w+\/\d\d\d\d:\d\d:\d\d:\d\d\.\d+)\]' \
  --begin="2019-02-22T06:00:00" \
  --end="2019-02-22T07:00:00" \
  --format='%d/%B/%Y:%T.%3N' < haproxy.log | wc -l

time perl logslice.pl \
  --year=2019 \
  --regex='^([A-Za-z]+ \d+ \d\d:\d\d:\d\d) ' \
  --begin="2019-02-22T06:00:00" \
  --end="2019-02-22T07:00:00" \
  --format='%b %d %T' < github-audit.log | wc -l
