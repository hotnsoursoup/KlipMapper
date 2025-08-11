# AgentMap - AI Assistant Guide

> **Purpose**: High-level navigation and usage guide for AI assistants working on the AgentMap codebase optimization project.

## 📋 Project Overview

**AgentMap** is a multi-language code analysis tool that maps software architecture, relationships, and patterns across codebases. This project underwent a comprehensive modernization from legacy synchronous architecture to a modern async-first, multi-language system.

### Current Status (2025-01-11)
- **Phase**: 3 of 3 phases completed (Inheritance Analysis)
- **Progress**: 23/31 tasks completed (74%)
- **Architecture**: Modern async-first with TreeSitter integration
- **Languages Supported**: 7 (Dart, TypeScript, JavaScript, Python, Rust, Go, Java)
- **Test Status**: ✅ All core relationship tests passing (5/5)

## 🗺️ Documentation Navigation

### 📚 **Start Here - Essential Documents**

| Document | Purpose | When to Use |
|----------|---------|-------------|
| **[OPTIMIZATION_QUICK_REFERENCE.md](docs/OPTIMIZATION_QUICK_REFERENCE.md)** | Quick status, commands, next actions | Every session start, quick lookups |
| **[OPTIMIZATION_TRACKING.md](docs/OPTIMIZATION_TRACKING.md)** | Comprehensive overview, metrics, decisions | Understanding project history, planning |
| **[TECHNICAL_IMPLEMENTATION_LOG.md](docs/TECHNICAL_IMPLEMENTATION_LOG.md)** | Detailed code changes, patterns, fixes | Deep technical work, debugging |
| **[OPTIMIZATION_DECISIONS.json](docs/OPTIMIZATION_DECISIONS.json)** | Structured decision data, benchmarks | Automation, data analysis, metrics |

### 🎯 **Usage Workflow for AI Assistants**

#### **Starting a New Session** 
1. **Read** `OPTIMIZATION_QUICK_REFERENCE.md` - Get current status and priorities
2. **Check** todo list status with `TodoWrite` tool
3. **Review** any failing tests or blocking issues

#### **Working on Code Changes**
1. **Reference** `TECHNICAL_IMPLEMENTATION_LOG.md` for patterns and examples
2. **Update** todo status as work progresses
3. **Document** new decisions in tracking files

#### **Making Optimization Decisions**
1. **Check** `OPTIMIZATION_DECISIONS.json` for past decisions and rationale
2. **Review** "alternatives_considered" to avoid re-evaluating known options
3. **Follow** established patterns from `TECHNICAL_IMPLEMENTATION_LOG.md`

#### **Before Completing Work**
1. **Update** all tracking documents with changes made
2. **Record** any new lessons learned or issues encountered
3. **Update** todo status and next priorities

## 🏗️ Codebase Architecture

### **Core Modules**
```
src/core/
├── mod.rs                    # Module declarations
├── analyzer.rs               # Async analysis engine (unused - future)
├── language.rs               # Multi-language abstraction layer
├── symbol_types.rs           # Comprehensive symbol classification
└── relationship_analyzer.rs  # ⭐ MAIN: Inheritance & relationship analysis

src/parsers/
└── treesitter_engine.rs     # Modern TreeSitter integration

tests/
└── relationship_analysis_test.rs  # ⭐ WORKING: Core integration tests
```

### **Key Implementation Areas**
- **Inheritance Analysis**: `src/core/relationship_analyzer.rs:255-780` (language-specific methods)
- **TreeSitter Integration**: `src/parsers/treesitter_engine.rs:35-530` (async parsing engine)
- **Multi-Language Support**: `src/core/language.rs:16-300` (7 language definitions)
- **Type System**: `src/core/symbol_types.rs:1-379` (comprehensive symbol classification)

## 🎯 Current Priorities

### **High Priority (Do Next)**
1. **Performance Benchmarking** - Establish baselines for memory, speed, build time
2. **Full Test Suite** - Run complete test suite, identify/fix regressions
3. **Design Pattern Detection** - Next phase of relationship analysis

### **Medium Priority**
1. **TreeSitter Version Planning** - Monitor for 0.25.x compatibility
2. **Import Resolution Enhancement** - Cross-file symbol resolution
3. **Code Cleanup** - Address 31 compiler warnings

### **Completed Recently** ✅
- Multi-language inheritance analysis with language-specific optimization
- Async-first architecture with modern dependencies
- Comprehensive relationship analysis and testing
- TreeSitter integration with fallback handling

## ⚠️ Important Constraints & Guidelines

### **Technical Constraints**
- **TreeSitter Version**: Must stay on 0.22.6 due to language grammar compatibility
- **Target Platform**: Linux x86_64 (`--target x86_64-unknown-linux-gnu`)
- **Test Pattern**: Always build comprehensive tests alongside implementation
- **Architecture**: Maintain async-first patterns established in Phase 2

### **User Feedback Integration**
- **Language Optimization**: "detecting the language and then use the best one for that language instead of a broad one that works okay" ✅ Implemented
- **Testing Emphasis**: "Ensure you are building testing along the way" ✅ Following
- **Multi-Language Focus**: "This app isnt dart specific btw" ✅ 7 languages supported

### **Code Quality Standards**
- **Error Handling**: Use `anyhow::Result` with descriptive contexts
- **Concurrency**: Use `Arc<DashMap>` for concurrent access, avoid `Mutex<HashMap>`
- **Testing**: Write integration tests that work with mock and real data
- **Documentation**: Update tracking files with all changes made

## 🔧 Essential Commands

### **Quick Status Check**
```bash
# Check compilation
cargo check --target x86_64-unknown-linux-gnu

# Run core tests
cargo test --test relationship_analysis_test --target x86_64-unknown-linux-gnu

# Current status
git status
```

### **Testing & Quality**
```bash
# Run all tests
cargo test --target x86_64-unknown-linux-gnu

# Fix warnings
cargo fix --lib -p agentmap

# Format code
cargo fmt
```

### **Performance Analysis**
```bash
# Build time
time cargo build --target x86_64-unknown-linux-gnu

# Binary size
ls -la target/x86_64-unknown-linux-gnu/debug/agentmap
```

## 🐛 Known Issues & Workarounds

### **TreeSitter Version Conflict** ⚠️
- **Issue**: Cannot update to 0.25.8 due to language grammar incompatibility
- **Workaround**: Staying on 0.22.6, monitor quarterly for updates
- **Impact**: Limited access to newest TreeSitter features

### **Test Environment Handling** ✅ Resolved
- **Issue**: Mock TreeSitter trees causing crashes in tests
- **Solution**: Implemented fallback symbol-based analysis for non-existent files
- **Location**: `src/core/relationship_analyzer.rs:267-270`

### **Compiler Warnings** 📝 Low Priority
- **Issue**: 31 warnings (mostly unused imports/variables)
- **Impact**: Non-blocking, compilation successful
- **Fix**: Available via `cargo fix --lib -p agentmap`

## 📊 Success Metrics

### **Quality Gates**
- ✅ **Zero Breaking Changes** - Backward compatibility maintained
- ✅ **100% Test Pass Rate** - All relationship analysis tests passing
- ✅ **Modern Dependencies** - Tokio 1.47, Serde 1.0.219, Anyhow 1.0.97
- ✅ **Multi-Language Support** - 7 languages with optimized parsing

### **Performance Targets** (TBD)
- **Build Time**: < 5 seconds
- **Memory Usage**: Baseline to be established
- **Processing Speed**: Baseline to be established
- **Test Coverage**: > 80% for core modules

## 🚀 Future Roadmap

### **Phase 4: Performance & Polish** (Next)
1. Establish comprehensive performance baselines
2. Implement design pattern detection algorithms  
3. Add advanced usage relationship analysis
4. Complete full test suite validation

### **Phase 5: Advanced Features** (Future)
1. Architecture layer detection
2. Code quality metrics and scoring
3. Real-time analysis capabilities
4. Integration with IDEs and CI/CD

### **Phase 6: Ecosystem Integration** (Future)
1. Plugin architecture for extensibility
2. Export formats (JSON, GraphML, etc.)
3. Web dashboard for visualization
4. API for external tool integration

## 💡 AI Assistant Best Practices

### **Session Management**
1. **Always** check `OPTIMIZATION_QUICK_REFERENCE.md` at start
2. **Always** use `TodoWrite` tool to track progress
3. **Always** update tracking documents before ending session

### **Code Development**
1. **Follow** established patterns in `TECHNICAL_IMPLEMENTATION_LOG.md`
2. **Test** changes immediately with `cargo test`
3. **Maintain** async-first architecture patterns
4. **Document** decisions and rationale as you go

### **Problem Solving**
1. **Check** known issues section first
2. **Reference** past decisions in `OPTIMIZATION_DECISIONS.json`
3. **Learn** from lessons learned in tracking files
4. **Record** new issues and solutions discovered

### **Communication**
1. **Be concise** - User prefers brief, direct responses
2. **Show progress** - Use todo tracking to demonstrate work
3. **Explain rationale** - Reference past decisions and constraints
4. **Focus on deliverables** - Emphasize concrete results and next steps

---

## 🎯 **Quick Start Checklist for New Sessions**

- [ ] Read `OPTIMIZATION_QUICK_REFERENCE.md` for current status
- [ ] Check todo list with `TodoWrite` tool  
- [ ] Run `cargo test --test relationship_analysis_test --target x86_64-unknown-linux-gnu`
- [ ] Verify no blocking issues in known issues section
- [ ] Identify next priority task and begin work
- [ ] Update tracking documents with progress made

---

*This guide serves as the primary entry point for all AI assistants working on AgentMap optimization. Keep it updated as the project evolves.*

**Last Updated**: 2025-01-11  
**Next Review**: When starting Phase 4