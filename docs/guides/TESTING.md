# Testing Standards

## Principles

1. **Execution-first**: Tests must actually run, not just compile
2. **Meaningful assertions**: Every assertion must be capable of failing
3. **Real scenarios**: Use realistic test data, not just happy paths

## Test Organization

```
agentmap-v2/
├── tests/
│   ├── integration/       # Cross-module tests
│   └── fixtures/          # Test data files
└── src/
    └── */mod.rs           # Unit tests in #[cfg(test)] modules
```

## Running Tests

```bash
# All tests
cargo test

# Specific test
cargo test test_name

# With output
cargo test -- --nocapture
```

## Test Patterns

### Unit Tests
- Place in same file as code under `#[cfg(test)]`
- Test one function/method per test
- Use descriptive names: `test_symbol_resolution_with_alias`

### Integration Tests
- Place in `tests/` directory
- Test component interactions
- Use realistic fixtures

## Anti-Patterns to Avoid

- Tests that compile but don't execute
- Placeholder assertions (`assert!(true)`)
- Mocking away the thing being tested
- Tests without error cases
