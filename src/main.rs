extern crate regex;

use regex::Regex;
use std::fs::File;
use std::io::prelude::*;
use std::io::BufReader;

fn main() {
    let date_re = Regex::new(r"[\d+/\w+/\d{4}:\d\d:\d\d:\d\d\.\d+]").unwrap();

    let log_path = "haproxy.log";
    let f = File::open(log_path).expect("Could not open file!");
    let mut buffered = BufReader::new(f);

    let mut buf = String::new();
    loop {
        match buffered.read_line(&mut buf) {
            Ok(n) => {
                if n > 0 {
                    {
                        let line = buf.trim_right();
                        if date_re.is_match(line) {
                            println!("{}", line);
                        }
                    }
                    buf.clear();
                }
            }
            Err(_) => break,
        }
    }
}
