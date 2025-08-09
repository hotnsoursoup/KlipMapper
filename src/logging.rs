use time::{macros::format_description, UtcOffset};
use tracing_subscriber::{fmt::time::OffsetTime, EnvFilter};

pub fn init() {
    let timer = OffsetTime::new(
        UtcOffset::UTC,
        format_description!(
            "[year]-[month]-[day]T[hour]:[minute]:[second].[subsecond digits:3]Z"
        ),
    );

    let _ = tracing_subscriber::fmt()
        .with_env_filter(EnvFilter::from_default_env().add_directive("info".parse().unwrap()))
        .with_timer(timer)
        .json()
        .flatten_event(true)
        .try_init();
}
