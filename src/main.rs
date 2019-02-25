extern crate regex;
extern crate structopt;

use structopt::StructOpt;
use regex::Regex;
use std::fs::File;
use std::io::prelude::*;
use std::io::{self, BufReader, Write};

#[derive(StructOpt, Debug)]
#[structopt(name = "basic")]
struct Opt {
    #[structopt(short = "b", long = "begin")]
    begin: String,

    #[structopt(short = "e", long = "end")]
    end: String,

    #[structopt(short = "f", long = "format")]
    format: String,

    #[structopt(short = "r", long = "regex")]
    regex: String,
}

fn main() -> io::Result<()> {
    let _opt = Opt::from_args();
    println!("{:?}", _opt);
    let date_re = Regex::new(r"\[\d+/\w+/\d\d\d\d:\d\d:\d\d:\d\d\.\d+\]").unwrap();
    let f = File::open("haproxy.log")?;
    let f = BufReader::new(f);

    let stdout = io::stdout(); // get the global stdout entity
    stdout.lock();
    let mut handle = io::BufWriter::new(stdout); // optional: wrap that handle in a buffer

    for line in f.lines() {
        let s = line.unwrap();
        if date_re.is_match(s.trim_end()) {
            writeln!(handle, "{}", s).unwrap();
        }
    }

    Ok(())
}
