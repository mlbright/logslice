use std::process;
use structopt::StructOpt;
use timegrep;
use timegrep::CLI;

fn main() {
    let config = CLI::from_args();
    if let Err(e) = timegrep::run(config) {
        eprintln!("application error: {}", e);
        process::exit(1);
    }
}
