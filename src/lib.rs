// AgentMap library - Modern code analysis and mapping tool
// This lib.rs exposes the public API for integration tests and external usage

pub mod cli;
pub mod frontmatter;
pub mod sidecar;
pub mod adapters;
pub mod fs_scan;
pub mod logging;
pub mod index;
pub mod checker;
pub mod watcher;
pub mod config;

// New modern architecture modules - public API
pub mod core;
pub mod parsers;
pub mod query_pack;
pub mod symbol_table;
pub mod anchor;
pub mod scope_tracker;
pub mod symbol_resolver;
pub mod wildcard_matcher;
pub mod architecture_exporter;
pub mod export_formats;