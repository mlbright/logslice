extern crate structopt;

use structopt::StructOpt;

/// Get a time slice of a log
#[derive(StructOpt, Debug)]
#[structopt(name = "timeslice")]
struct CLI {
    // A flag, true if used in the command line. Note doc comment will
    // be used for the help message of the flag.
    /// Activate debug mode
    #[structopt(short = "d", long = "debug")]
    debug: bool,

    // The number of occurrences of the `v/verbose` flag
    /// Verbose mode (-v, -vv, -vvv, etc.)
    #[structopt(short = "v", long = "verbose", parse(from_occurrences))]
    verbose: u8,

    // This option can be specified either `--start` or `-s value`.
    /// start time
    #[structopt(short = "s", long = "start")]
    start: String,

    // This option can be specified either `--end` or `-e value`.
    /// end time
    #[structopt(short = "e", long = "end")]
    end: String,

    // This option can be specified either `--regexp` or `-r value`.
    /// regular expression to pluck out the time each line
    #[structopt(short = "r", long = "regexp")]
    regexp: String,

    // This option can be specified either `--format` or `-f value`.
    /// format of the timestamp
    #[structopt(short = "f", long = "format")]
    format: String,

    // This option can be specified either `--year` or `-y value`.
    /// Specify a year, if necessary
    #[structopt(short = "y", long = "year")]
    year: u32,

    // This option can be specified either `--chunk` or `-c value`.
    /// Specify chunk size
    #[structopt(short = "c", long = "chunk")]
    chunk: u32,
}

fn main() {
    let opt = CLI::from_args();
}
