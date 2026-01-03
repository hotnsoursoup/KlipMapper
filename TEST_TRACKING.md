# AgentMap Test Tracking & Coverage Document

> **Purpose**: Living document to track testing progress, coverage gaps, and ensure file changes trigger appropriate test updates

**Last Updated**: 2025-01-12  
**Document Version**: 1.0  
**Maintainer**: AI Assistant

## 📊 Executive Summary

| Metric | Status | Target |
|--------|--------|--------|
| **Overall Test Coverage** | 🟡 95% Passing (59/62) | ✅ 85%+ |
| **Core Module Coverage** | 🟡 Improving | ✅ 90%+ |
| **Integration Tests** | 🟡 Basic | ✅ Comprehensive |
| **Test Compilation** | ✅ Passing | ✅ All Pass |
| **Performance Tests** | 🔴 Missing | ✅ Benchmarks |

## 🗂️ Test Structure Overview

```
tests/
├── 📁 unit/              # Unit tests for individual modules
│   ├── ✅ config.rs           # Configuration system tests (18 tests)
│   ├── ⚠️ adapters.rs         # Language adapter tests (needs review)
│   ├── ⚠️ symbol_table.rs     # Symbol table operations (needs review)
│   ├── ⚠️ query_pack.rs       # Query package tests (needs review)
│   └── ⚠️ query_provider.rs   # Query provider tests (needs review)
├── 📁 integration/       # Integration tests for component interaction
│   ├── ⚠️ cli_tests.rs        # CLI command integration (needs review)
│   ├── ⚠️ cli_commands.rs     # Command execution tests (needs review)
│   ├── ⚠️ multilang_analysis.rs # Multi-language analysis (needs review)
│   └── ⚠️ sidecar_generation.rs # Sidecar file generation (needs review)
├── 📁 fixtures/          # Test data and mock files
│   ├── ✅ multilang_project/  # Multi-language test project
│   ├── ⚠️ complex_project/    # Complex project structure (needs validation)
│   └── ⚠️ small_project/      # Simple test project (needs validation)
├── 📁 benchmarks/        # Performance and benchmark tests
│   └── 🔴 mod.rs              # Empty - needs implementation
├── ✅ relationship_analysis_test.rs # Core relationship analysis (5 tests)
└── ✅ treesitter_integration_test.rs # TreeSitter parsing (3 tests)
```

## 🎯 Test Coverage Analysis

### ✅ Well-Tested Modules

| Module | File | Test Count | Coverage | Status |
|--------|------|------------|----------|--------|
| **Config System** | `src/config.rs` | 18 | 🟢 High | All scenarios covered |
| **Relationship Analysis** | `src/core/relationship_analyzer.rs` | 5 | 🟡 Medium | Core functionality tested |
| **TreeSitter Integration** | `src/parsers/treesitter_engine.rs` | 3 | 🟡 Medium | Basic parsing tested |

### 🔴 Critical Gaps (Immediate Priority)

| Module | File | Gap Description | Risk Level |
|--------|------|-----------------|------------|
| **Symbol Types** | `src/core/symbol_types.rs` | No unit tests | 🔴 High |
| **Language System** | `src/core/language.rs` | No comprehensive tests | 🔴 High |
| **Core Analyzer** | `src/core/analyzer.rs` | Missing integration tests | 🔴 High |
| **Wildcard Matcher** | `src/wildcard_matcher.rs` | Compilation failures | 🔴 Critical |
| **Symbol Resolver** | `src/symbol_resolver.rs` | No comprehensive tests | 🔴 High |

### 🟡 Partial Coverage (Medium Priority)

| Module | File | Status | Needs |
|--------|------|--------|-------|
| **CLI Commands** | `src/cli.rs` | Basic integration | Error handling tests |
| **Query System** | `src/query_pack.rs` | Unit tests exist | Integration validation |
| **Architecture Export** | `src/architecture_exporter.rs` | Missing tests | Full feature coverage |
| **File Scanning** | `src/fs_scan.rs` | No tests | Path handling validation |

### 🟢 Lower Priority Modules

| Module | File | Status | Notes |
|--------|------|--------|-------|
| **Logging** | `src/logging.rs` | Low risk | Standard logging, can defer |
| **Watcher** | `src/watcher.rs` | Low risk | File watching, can defer |
| **Export Formats** | `src/export_formats.rs` | Low risk | Output formatting, can defer |

## 🔧 Compilation Issues Analysis

### ✅ Resolved Build Failures

1. **wildcard_matcher.rs** - FIXED ✅
   - Fixed Symbol struct initialization by adding missing fields (id, owner, fingerprint, guard)
   - Resolved mutability issues by using thread-safe versions of regex compilation methods
   - All compilation errors resolved

### 🔴 Remaining Test Failures (3/62)

1. **wildcard_matcher::tests::test_fuzzy_matching**
   ```
   Expected: 1 result, Got: 0 results
   ```
   **Issue**: Fuzzy matching threshold too high (0.8 → 0.5 reduces sensitivity)
   **Fix Priority**: 🟡 Medium

2. **anchor::tests::test_anchor_compression**
   ```
   Error: missing field `refs` at line 1 column 297
   ```
   **Issue**: Serialization/deserialization schema mismatch
   **Fix Priority**: 🟡 Medium

3. **wildcard_matcher::tests::test_match_result_wrapper_ordering**
   ```
   Expected: 0.9, Got: 0.8
   ```
   **Issue**: BinaryHeap ordering logic for max-heap behavior
   **Fix Priority**: 🟡 Medium

### Warning Analysis
- 29 unused import warnings (cosmetic, low priority)
- Several unused variable warnings (cleanup recommended)

## 📋 File Change Triggers

### Automatic Test Requirements

| File Pattern | Required Tests | Test Framework |
|--------------|----------------|----------------|
| `src/core/*.rs` | Unit + Integration | `rstest` + `tokio::test` |
| `src/parsers/*.rs` | Parser integration | `tokio::test` |
| `src/*.rs` (root) | Unit tests minimum | Standard `#[test]` |
| `queries/*.scm` | Query validation | TreeSitter integration |
| Configuration files | Config loading tests | `tempfile` + unit tests |

### Test Signatures by Module

```rust
// Core module testing pattern
#[cfg(test)]
mod tests {
    use super::*;
    use rstest::*;
    use tokio_test;
    
    #[fixture]
    fn sample_symbol() -> Symbol { /* */ }
    
    #[rstest]
    fn test_feature_with_fixture(sample_symbol: Symbol) { /* */ }
    
    #[tokio::test]
    async fn test_async_functionality() { /* */ }
}
```

## 🚀 Recommended Test Frameworks

### Primary: `rstest` (Fixture-based testing)
```toml
[dev-dependencies]
rstest = "0.18"
rstest_reuse = "0.6"
```

**Benefits**: 
- Excellent fixture support for complex setup
- Parametrized testing with `#[case]`
- Template reuse with `rstest_reuse`

### Secondary: `tokio-test` (Async testing)
```toml
tokio-test = "0.4"
```

### Supporting: Standard ecosystem
```toml
tempfile = "3.8"      # Temporary file/directory testing
pretty_assertions = "1.4"  # Better assertion output
criterion = "0.5"     # Benchmarking
```

## 📈 Test Metrics & KPIs

### Coverage Targets

| Category | Current | Target | Status |
|----------|---------|--------|--------|
| **Line Coverage** | Unknown | 85% | 🔴 Need baseline |
| **Branch Coverage** | Unknown | 80% | 🔴 Need baseline |
| **Function Coverage** | Unknown | 95% | 🔴 Need baseline |
| **Integration Coverage** | 20% | 90% | 🔴 Significant gap |

### Test Quality Metrics

- **Test Compilation**: ❌ Failing (compilation errors)
- **Test Runtime**: ⏱️ Unknown (can't run tests)
- **Flaky Tests**: 📊 Unknown
- **Test Performance**: ⚡ Unknown

## 🔄 Maintenance Procedures

### Daily Maintenance

1. **Compilation Check**
   ```bash
   cargo test --target x86_64-unknown-linux-gnu --lib
   ```

2. **Coverage Report** (when tests pass)
   ```bash
   cargo tarpaulin --target x86_64-unknown-linux-gnu --out html
   ```

### Weekly Maintenance

1. **Test Health Review**
   - Check for flaky tests
   - Review test performance
   - Update test fixtures if needed

2. **Coverage Analysis**
   - Identify new coverage gaps
   - Plan test additions
   - Review test quality

### Monthly Maintenance

1. **Full Test Suite Audit**
   - Review all test files
   - Update this tracking document
   - Plan testing improvements

2. **Framework Updates**
   - Update test dependencies
   - Review new testing patterns
   - Refactor outdated tests

## 🎯 Immediate Action Plan (Next 7 Days)

### Phase 1: Fix Compilation (Day 1-2) 🔴
- [ ] Fix Symbol struct initialization in `wildcard_matcher.rs`
- [ ] Resolve mutability issues
- [ ] Clean up critical compilation errors
- [ ] Verify all tests compile

### Phase 2: Core Module Testing (Day 3-5) 🟡
- [ ] Add comprehensive tests for `symbol_types.rs`
- [ ] Create integration tests for `language.rs`
- [ ] Expand `core/analyzer.rs` test coverage
- [ ] Add error handling tests for CLI

### Phase 3: Documentation & Process (Day 6-7) 🟢
- [ ] Document test patterns and conventions
- [ ] Create test templates for future modules
- [ ] Set up automated coverage reporting
- [ ] Update this tracking document

## 📝 Test Development Guidelines

### Test Naming Convention
```rust
// Unit tests
#[test]
fn test_[functionality]_[scenario]_[expected_outcome]() { }

// Integration tests  
#[tokio::test]
async fn integration_[component]_[scenario]_[expected_outcome]() { }

// Fixture-based tests
#[rstest]
fn test_[functionality]_with_[fixture_type](fixture: FixtureType) { }
```

### Test Organization
- **Unit tests**: Same file as module, in `#[cfg(test)]` mod
- **Integration tests**: Separate files in `tests/` directory
- **Fixtures**: Shared fixtures in `tests/fixtures/` or individual fixture functions
- **Helpers**: Common test utilities in `tests/common/mod.rs`

### Test Documentation
```rust
/// Tests the relationship analysis functionality with complex inheritance hierarchies.
/// 
/// This test verifies that:
/// - Parent-child relationships are correctly identified
/// - Interface implementations are tracked
/// - Circular dependencies are detected
/// - Metrics are calculated accurately
#[tokio::test]
async fn test_relationship_analysis_with_inheritance() { }
```

## 🔍 Monitoring & Alerts

### Red Flags (Immediate Action Required)
- ❌ Test compilation failures
- 🔥 Test coverage drops below 80%
- ⚠️ More than 5 flaky tests
- 💥 Any core module without tests

### Yellow Flags (Review Within Week)
- 🟡 Test coverage below 85%
- ⏱️ Test runtime increases >20%
- 📈 More than 10 warnings in test code
- 🔄 Test fixtures becoming stale

### Green Flags (Good Health)
- ✅ All tests passing
- 📊 Coverage above 85%
- ⚡ Fast test execution (<30s)
- 🔄 Regular test maintenance

---

## 📚 Appendix: Test Examples

### Example: Core Module Unit Test
```rust
#[cfg(test)]
mod tests {
    use super::*;
    use rstest::*;
    
    #[fixture]
    fn sample_dart_class() -> Symbol {
        Symbol::new(
            "test::TestClass".to_string(),
            "TestClass".to_string(),
            SymbolKind::Class {
                is_abstract: false,
                superclass: None,
                interfaces: Vec::new(),
                is_generic: false,
            },
            SourceLocation {
                file_path: PathBuf::from("test.dart"),
                start_line: 1,
                start_column: 1,
                end_line: 10,
                end_column: 1,
                byte_offset: 0,
                byte_length: 100,
            },
        )
    }
    
    #[rstest]
    fn test_symbol_creation_with_dart_class(sample_dart_class: Symbol) {
        assert_eq!(sample_dart_class.name, "TestClass");
        assert_eq!(sample_dart_class.fully_qualified_name, "test::TestClass");
        match sample_dart_class.kind {
            SymbolKind::Class { is_abstract, .. } => {
                assert!(!is_abstract);
            }
            _ => panic!("Expected Class symbol kind"),
        }
    }
}
```

### Example: Integration Test
```rust
#[tokio::test]
async fn test_full_analysis_pipeline() {
    let engine = ModernTreeSitterEngine::new().unwrap();
    let analyzer = RelationshipAnalyzer::new();
    
    // Test with real Dart code
    let code = include_str!("../fixtures/sample_app.dart");
    let result = engine.analyze_file(Path::new("sample_app.dart"), code).await.unwrap();
    
    analyzer.register_file(result).await.unwrap();
    let analysis = analyzer.analyze_relationships().await.unwrap();
    
    assert!(analysis.metrics.total_relationships > 0);
    assert!(analysis.metrics.coupling_score >= 0.0);
}
```

---

## 📖 How to Maintain This Document

### 🔄 Daily Updates (For Active Development)

1. **After Each Test Session**:
   ```bash
   # Run tests and update status
   cargo test --target x86_64-unknown-linux-gnu --lib
   # Update compilation status in "Executive Summary"
   # Mark any new tests as "✅ Working" or "🔴 Failing"
   ```

2. **File Change Triggers**:
   - When modifying `src/core/*.rs` → Add corresponding test requirements to tracking
   - When adding new dependencies → Update test framework sections
   - When changing test structure → Update "Test Structure Overview"

3. **Quick Status Updates**:
   - Update test counts in module tables
   - Change status indicators (🔴/🟡/🟢) based on current state
   - Record new compilation issues in "Critical Build Failures"

### 📊 Weekly Reviews

1. **Coverage Analysis**:
   ```bash
   # Generate coverage report (when tests pass)
   cargo install cargo-tarpaulin
   cargo tarpaulin --target x86_64-unknown-linux-gnu --out html
   # Update "Test Metrics & KPIs" section
   ```

2. **Test Health Assessment**:
   - Review and update "Executive Summary" metrics
   - Check for new critical gaps
   - Update priority levels based on development focus
   - Review and prune completed tasks from action plans

3. **Documentation Cleanup**:
   - Update "Last Updated" date
   - Increment document version if major changes
   - Verify all links and references work
   - Remove outdated information

### 🗓️ Monthly Maintenance

1. **Full Test Audit**:
   ```bash
   # Generate comprehensive test report
   cargo test --target x86_64-unknown-linux-gnu -- --list
   # Count actual tests vs. documented counts
   ```

2. **Strategic Review**:
   - Reassess coverage targets based on project maturity
   - Update test framework recommendations
   - Review maintenance procedures effectiveness
   - Plan testing infrastructure improvements

3. **Stakeholder Communication**:
   - Generate summary report from tracking data
   - Communicate testing health to team
   - Gather feedback on testing experience
   - Plan testing roadmap updates

### 🚨 Emergency Procedures

#### When Tests Stop Compiling
1. **Immediate Actions**:
   - Document compilation errors in "Critical Build Failures"
   - Update "Test Compilation" status to 🔴 Failing
   - Add issue to "Immediate Action Plan" with 🔴 priority
   - Estimate fix timeline and communicate to stakeholders

2. **Resolution Tracking**:
   ```bash
   # Create tracking branch for test fixes
   git checkout -b test-fixes-$(date +%Y%m%d)
   # Document each fix attempt
   # Test compilation after each change
   cargo test --target x86_64-unknown-linux-gnu --lib --no-run
   ```

#### When Coverage Drops Significantly
1. **Investigation**:
   - Compare current vs. previous coverage reports
   - Identify which modules lost coverage
   - Determine if due to new code or removed tests
   - Update relevant module status to 🟡 or 🔴

2. **Recovery Plan**:
   - Add specific coverage recovery tasks to action plan
   - Set target date for coverage restoration
   - Prioritize based on module criticality

### 📝 Document Update Templates

#### Adding New Test Module
```markdown
### ✅ New Module Name

| Module | File | Test Count | Coverage | Status |
|--------|------|------------|----------|--------|
| **Module Name** | `src/path/module.rs` | X | 🟢 High | Description |
```

#### Recording Build Failure
```markdown
### Critical Build Failures

X. **module_name.rs** (Lines X, Y)
   ```rust
   // ERROR: Description of error
   problematic_code_here
   ```
   **Impact**: Effect on testing
   **Fix Priority**: 🔴 Immediate/🟡 Medium/🟢 Low
```

#### Weekly Status Update
```markdown
<!-- Update Executive Summary table -->
| Metric | Status | Target | Change from Last Week |
|--------|--------|--------|-----------------------|
| **Overall Test Coverage** | 🟡 X% | ✅ 85%+ | +/-X% |
```

### 🔧 Tools & Automation

#### Useful Commands
```bash
# Quick test compilation check
cargo check --target x86_64-unknown-linux-gnu --tests

# Count tests by type
find tests/ -name "*.rs" -exec grep -l "#\[test\]" {} \; | wc -l

# Generate test list with descriptions
cargo test --target x86_64-unknown-linux-gnu -- --list | grep -E "test " > test_inventory.txt

# Check for unused test fixtures
grep -r "fixture" tests/ --include="*.rs" | grep -v "use"
```

#### Automation Scripts (Recommended)
```bash
#!/bin/bash
# daily_test_health.sh
echo "📊 AgentMap Test Health Check - $(date)"
echo "=================================="

# Compilation check
if cargo check --target x86_64-unknown-linux-gnu --tests; then
    echo "✅ Test compilation: PASS"
else
    echo "❌ Test compilation: FAIL"
fi

# Test count
TEST_COUNT=$(find tests/ -name "*.rs" -exec grep -l "#\[test\]" {} \; | wc -l)
echo "📝 Total test files: $TEST_COUNT"

# Coverage (if tests pass)
if cargo test --target x86_64-unknown-linux-gnu --lib > /dev/null 2>&1; then
    echo "✅ Test execution: PASS"
    # Add coverage calculation here
else
    echo "❌ Test execution: FAIL"
fi
```

### 📋 Quality Checklist

Before updating this document, verify:

- [ ] All status indicators are current and accurate
- [ ] Test counts match actual test files
- [ ] Compilation status reflects latest build attempt
- [ ] Action plans have realistic timelines
- [ ] Examples and code snippets are valid
- [ ] Links and references work correctly
- [ ] "Last Updated" date is current
- [ ] Any new patterns follow established conventions

### 🎯 Success Metrics for This Document

Track effectiveness of this tracking system:

- **Document Accuracy**: Do status indicators match reality?
- **Actionability**: Are action plans being followed and completed?
- **Timeliness**: Are updates happening on schedule?
- **Value**: Is this document helping improve test quality?
- **Usage**: Is the team actually referencing and updating it?

### 🆘 Troubleshooting Common Issues

#### "I can't update the test counts"
```bash
# Count unit tests
find tests/unit -name "*.rs" -exec grep -c "#\[test\]" {} \; | awk '{sum+=$1} END {print sum}'

# Count integration tests  
find tests/integration -name "*.rs" -exec grep -c "#\[tokio::test\]" {} \; | awk '{sum+=$1} END {print sum}'

# Count rstest fixtures
grep -r "#\[fixture\]" tests/ --include="*.rs" | wc -l
```

#### "The document is getting too long"
Consider splitting into multiple focused documents:
- `TEST_COVERAGE_REPORT.md` - Current status and metrics
- `TEST_MAINTENANCE_GUIDE.md` - Procedures and templates
- `TEST_ROADMAP.md` - Future plans and improvements

#### "Status indicators don't match reality"
Regular calibration needed:
1. Run actual tests: `cargo test --target x86_64-unknown-linux-gnu`
2. Compare results with documented status
3. Update all discrepancies immediately
4. Add verification to daily routine

---

**Next Review Date**: 2025-01-19  
**Document Signature**: `TEST_TRACKING_v1.0_20250112`