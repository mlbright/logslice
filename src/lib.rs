extern crate chrono;
extern crate itertools;
extern crate regex;
extern crate structopt;

use chrono::prelude::*;
use itertools::Itertools;
use regex::Regex;
use std::error::Error;
use std::io;
use std::io::prelude::*;
use structopt::StructOpt;

/// Get a time slice of a log
#[derive(StructOpt, Debug)]
#[structopt(name = "timegrep")]
pub struct CLI {
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
    #[structopt(short = "f", long = "finish")]
    end: String,

    // This option can be specified either `--regexp` or `-r value`.
    /// regular expression to pluck out the time each line
    #[structopt(short = "r", long = "regexp")]
    regexp: String,

    // This option can be specified either `--format` or `-f value`.
    /// format of the timestamp
    #[structopt(short = "t", long = "time-format")]
    format: String,

    // This option can be specified either `--chunk` or `-c value`.
    /// Specify chunk size
    #[structopt(short = "c", long = "chunk", default_value = "8192")]
    chunk: usize,
}

pub fn run(cli: CLI) -> Result<(), Box<dyn Error>> {
    if cli.verbose > 0 {
        println!("printing logs from '{}' to '{}'", cli.start, cli.end);
    }
    let stdin = io::stdin();
    let timestamp_re = Regex::new(&cli.regexp).unwrap();
    let start = Utc
        .datetime_from_str(&cli.start, "%Y-%m-%dT%H:%M:%S")
        .unwrap();
    let end = Utc
        .datetime_from_str(&cli.end, "%Y-%m-%dT%H:%M:%S")
        .unwrap();

    for chunk in &stdin.lock().lines().chunks(cli.chunk) {
        let lines: Vec<String> = chunk.map(|r| r.unwrap()).collect();
        process_chunk(&lines, &timestamp_re, &cli.format, &start, &end);
    }

    Ok(())
}

fn process_chunk(
    lines: &Vec<String>,
    time_re: &Regex,
    format: &str,
    start: &DateTime<Utc>,
    end: &DateTime<Utc>,
) {
    for line in lines {
        match time_re.captures(line) {
            Some(caps) => {
                if caps.len() > 0 {
                    let stamp = Utc.datetime_from_str(&caps[1], format).unwrap();
                    if stamp >= *start && stamp <= *end {
                        println!("{}", line)
                    }
                }
            }
            None => eprintln!("{}", line),
        }
    }
}
