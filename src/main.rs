extern crate regex;
extern crate structopt;

use structopt::StructOpt;
use regex::Regex;
use std::fs::File;
use std::io::prelude::*;
use std::io::{self, BufReader};

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
    let opt = Opt::from_args();
    println!("{:?}", opt);
    let date_re = Regex::new(r"\[\d+/\w+/\d\d\d\d:\d\d:\d\d:\d\d\.\d+\]").unwrap();
    let f = File::open("haproxy.log")?;
    let f = BufReader::new(f);

    for line in f.lines() {
        let s = line.unwrap();
        if date_re.is_match(s.trim_end()) {
            println!("{}", s);
        }
    }

    Ok(())
}
