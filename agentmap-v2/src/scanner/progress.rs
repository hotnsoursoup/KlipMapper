//! Progress reporting for directory scanning.

use indicatif::{ProgressBar, ProgressDrawTarget, ProgressState, ProgressStyle as IndicatifStyle};
use std::borrow::Cow;
use std::fmt::Write;

/// Progress reporting style configuration.
#[derive(Debug, Clone, Copy, Default)]
pub enum ProgressStyle {
    /// No progress output.
    Silent,
    /// Simple dots for each file.
    Dots,
    /// Progress bar with file count.
    #[default]
    Bar,
    /// Detailed output with file names.
    Verbose,
}

/// Progress reporter for scanning operations.
pub struct ScanProgress {
    bar: Option<ProgressBar>,
    style: ProgressStyle,
    total: u64,
    processed: u64,
}

impl ScanProgress {
    /// Create a new progress reporter.
    pub fn new(style: ProgressStyle, total: u64) -> Self {
        let bar = match style {
            ProgressStyle::Silent => None,
            ProgressStyle::Dots => {
                let pb = ProgressBar::new(total);
                pb.set_draw_target(ProgressDrawTarget::stderr());
                pb.set_style(
                    IndicatifStyle::with_template("{spinner:.green} {pos}/{len}")
                        .unwrap()
                );
                Some(pb)
            }
            ProgressStyle::Bar => {
                let pb = ProgressBar::new(total);
                pb.set_draw_target(ProgressDrawTarget::stderr());
                pb.set_style(
                    IndicatifStyle::with_template(
                        "{spinner:.green} [{elapsed_precise}] [{bar:40.cyan/blue}] {pos}/{len} ({eta})"
                    )
                    .unwrap()
                    .with_key("eta", |state: &ProgressState, w: &mut dyn Write| {
                        write!(w, "{:.1}s", state.eta().as_secs_f64()).unwrap()
                    })
                    .progress_chars("=> ")
                );
                Some(pb)
            }
            ProgressStyle::Verbose => {
                let pb = ProgressBar::new(total);
                pb.set_draw_target(ProgressDrawTarget::stderr());
                pb.set_style(
                    IndicatifStyle::with_template(
                        "{spinner:.green} {pos}/{len} {msg}"
                    )
                    .unwrap()
                );
                Some(pb)
            }
        };

        Self {
            bar,
            style,
            total,
            processed: 0,
        }
    }

    /// Create a silent progress reporter.
    pub fn silent() -> Self {
        Self::new(ProgressStyle::Silent, 0)
    }

    /// Increment progress by one.
    pub fn inc(&mut self) {
        self.processed += 1;
        if let Some(ref bar) = self.bar {
            bar.inc(1);
        }
    }

    /// Set current file being processed (for verbose mode).
    pub fn set_message(&self, msg: impl Into<Cow<'static, str>>) {
        if let Some(ref bar) = self.bar {
            bar.set_message(msg);
        }
    }

    /// Finish progress reporting.
    pub fn finish(&self) {
        if let Some(ref bar) = self.bar {
            bar.finish_with_message("done");
        }
    }

    /// Finish with a custom message.
    pub fn finish_with_message(&self, msg: impl Into<Cow<'static, str>>) {
        if let Some(ref bar) = self.bar {
            bar.finish_with_message(msg);
        }
    }

    /// Get the current progress count.
    pub fn processed(&self) -> u64 {
        self.processed
    }

    /// Get the total count.
    pub fn total(&self) -> u64 {
        self.total
    }

    /// Update total count (useful when discovering files progressively).
    pub fn set_total(&mut self, total: u64) {
        self.total = total;
        if let Some(ref bar) = self.bar {
            bar.set_length(total);
        }
    }

    /// Check if progress style is silent.
    pub fn is_silent(&self) -> bool {
        matches!(self.style, ProgressStyle::Silent)
    }
}

impl Drop for ScanProgress {
    fn drop(&mut self) {
        if let Some(ref bar) = self.bar {
            if !bar.is_finished() {
                bar.finish();
            }
        }
    }
}
