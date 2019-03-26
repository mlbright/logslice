# timegrep

> timegrep lets you select a range of entries from any chronologically ordered
> log file containing timestamps.

## Usage

You call timegrep with a start time (--begin) and an end time (--end) specified as ISO 8601 timestamps.

You also specify the format of the timestamp (--format) and a regular expression to pluck it out of the log.

timegrep operates on STDIN and sends its results to STDOUT.

```
perl timegrep.pl --begin="2019-02-22T06:00:00" --end="2019-02-22T07:00:00" \
  --regex='\[(\d+\/\w+\/\d\d\d\d:\d\d:\d\d:\d\d\.\d+)\]' \
  --format='%d/%B/%Y:%T.%3N' < haproxy.log > filtered.log
```

## Installation

```
sudo cpan install App::cpanminus
sudo cpanm DateTime::Format::Strptime
sudo cpanm List::BinarySearch
```

## Why?

Why use timegrep? If the log entries are chronologically ordered, there's no point in examining every entry to find the first and last entry you are interested in. Use binary search! timegrep does this for you, and prints out all the intermediate log records.
It can do this because it operates on large chunks of thousands of lines at once.

## See also

[dategrep](https://github.com/mdom/dategrep)

## Run the Rust version

```
cargo run -- --start="2019-03-25T06:00:00" --end="2019-03-25T07:00:00" --chunk=100 --year=2019 --regexp=" \[([^\]]+)\] " --format="%d/%b/%Y:%F" < haproxy.log 
```
