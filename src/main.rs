mod cli;
mod frontmatter;
mod sidecar;
mod adapters;
mod fs_scan;
mod logging;
mod index;
mod checker;
mod watcher;

fn main() -> anyhow::Result<()> {
    logging::init();
    cli::run()
}
