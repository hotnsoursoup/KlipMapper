mod cli;
mod frontmatter;
mod sidecar;
mod adapters;
mod fs_scan;
mod logging;

fn main() -> anyhow::Result<()> {
    logging::init();
    cli::run()
}
