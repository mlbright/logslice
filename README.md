# logslice

> logslice lets you select a range of entries from any chronologically ordered
> log file containing timestamps.

## Usage

You call logslice with a start time (--begin) and an end time (--end) specified as ISO 8601 timestamps.

You also specify the format of the timestamp (--format) and a regular expression to pluck it out of the log.

logslice operates on STDIN and sends its results to STDOUT.

```
perl logslice.pl --begin="2019-02-22T06:00:00" --end="2019-02-22T07:00:00" \
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

Why use logslice? If the log entries are chronologically ordered, there's no point in examining every entry to find the first and last entry you are interested in. Use binary search! logslice does this for you.
