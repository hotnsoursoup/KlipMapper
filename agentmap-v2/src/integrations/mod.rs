//! External integrations for AgentMap.
//!
//! This module provides integration with external storage and indexing systems.

#[cfg(feature = "db-kit")]
pub mod dbkit;

#[cfg(feature = "db-kit")]
pub mod daemon;

#[cfg(feature = "db-kit")]
pub use dbkit::*;

#[cfg(feature = "db-kit")]
pub use daemon::{Daemon, DaemonConfig, IndexResult, ScanResult};
