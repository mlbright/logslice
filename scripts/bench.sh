#!/bin/bash
set -e

echo "Rust version:"
time cargo run --release -- --start="2019-03-29T10:07:00" --finish="2019-03-29T10:08:00" --regexp="now=\"([^\"]+)\"" --time-format="%Y-%m-%dT%H:%M:%S%:z" < unicorn.log > rust.slice 2> rust.err

echo "Perl version:"
time perl scripts/timegrep.pl --start="2019-03-29T10:07:00" --finish="2019-03-29T10:08:00" --regexp="now=\"([^\"]+)+00:00\"" --time-format="%Y-%m-%dT%H:%M:%S" < unicorn.log> perl.slice 2> perl.err 
