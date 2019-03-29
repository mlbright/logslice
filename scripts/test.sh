#!/bin/bash
set -e

time wc -l haproxy.log

time perl timegrep.pl \
  --year=2019 \
  --regexp='^([A-Za-z]+ \d+ \d\d:\d\d:\d\d) ' \
  --begin="2019-02-22T06:00:00" \
  --end="2019-02-22T07:00:00" \
  --time-format='%b %d %T' < haproxy.log | wc -l

time perl timegrep.pl \
  --year=2019 \
  --regexp='\[(\d+\/\w+\/\d\d\d\d:\d\d:\d\d:\d\d\.\d+)\]' \
  --begin="2019-02-22T06:00:00" \
  --end="2019-02-22T07:00:00" \
  --time-format='%d/%B/%Y:%T.%3N' < haproxy.log | wc -l

time perl timegrep.pl \
  --year=2019 \
  --regexp='^([A-Za-z]+ \d+ \d\d:\d\d:\d\d) ' \
  --begin="2019-02-22T06:00:00" \
  --end="2019-02-22T07:00:00" \
  --time-format='%b %d %T' < github-audit.log | wc -l
