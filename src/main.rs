mod cli;
mod frontmatter;
mod sidecar;
mod adapters;
mod fs_scan;
mod logging;
mod index;
mod checker;
mod watcher;
mod config;
mod query_pack;
mod symbol_table;
mod anchor;
mod scope_tracker;
mod symbol_resolver;
mod wildcard_matcher;
mod architecture_exporter;
mod export_formats;

fn main() {
    logging::init();
    if let Err(e) = cli::run() {
        eprintln!("Error: {:#}", e);
        for (i, cause) in e.chain().skip(1).enumerate() {
            eprintln!("  caused by[{}]: {}", i, cause);
        }
        std::process::exit(1);
    }
}

// Include stress tests that generate synthetic code and run scan/check
#[cfg(test)]
mod generated_tests;
