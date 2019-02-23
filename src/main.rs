extern crate regex;

use regex::Regex;
use std::fs::File;
use std::io::prelude::*;
use std::io::{self, BufReader};

fn main() -> io::Result<()> {
    let date_re = Regex::new(r"[\d+/\w+/\d\d\d\d:\d\d:\d\d:\d\d\.\d+]").unwrap();
    let f = File::open("haproxy.log")?;
    let f = BufReader::new(f);

    for line in f.lines() {
        let s = line.unwrap();
        if date_re.is_match(s.trim_right()) {
            println!("{}", s);
        }
    }

    Ok(())
}
