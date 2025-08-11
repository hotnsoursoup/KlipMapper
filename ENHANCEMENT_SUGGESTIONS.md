# Enhancement Suggestions

This document lists files that could be enhanced to improve the functionality, usability, and completeness of the `agentmap` tool.

## Core Functionality

- **`src/cli.rs`**:
    - **Enhancement:** Complete the `query` command. Currently, it uses hardcoded demo data. The `load_symbol_table` function should be implemented to build a real symbol table from parsed files.
    - **Enhancement:** Enhance the `embed` command. The anchor system is a work in progress and needs to be fully integrated.
    - **Enhancement:** Improve the `export` command with more formats and analysis features.

- **`src/symbol_table.rs`**:
    - **Enhancement:** Add caching to the `ProjectSymbolTable` to improve performance for large projects.
    - **Enhancement:** Implement more sophisticated query capabilities, such as searching for symbols by type, scope, or other attributes.

- **`src/query_pack.rs`**:
    - **Enhancement:** Add support for more programming languages by creating new `QueryPack` implementations.
    - **Enhancement:** Implement more advanced queries, such as finding all callers of a function or all implementations of an interface.

- **`src/anchor.rs`**:
    - **Enhancement:** Complete the implementation of the anchor system. This includes reading anchor data from sidecar files and using it to improve the accuracy of other commands.
    - **Enhancement:** Improve the symbol filtering logic to be more accurate and configurable.

- **`src/symbol_resolver.rs`**:
    - **Enhancement:** Complete the implementation of the `SymbolResolver` to accurately resolve cross-references between symbols.

## Documentation

- **`README.md`**:
    - **Enhancement:** Update the documentation for the `query`, `export`, and `embed` commands.
    - **Enhancement:** Add a section on how to create new `QueryPack` implementations for other languages.

- **`docs/enhanced_anchor_system.md`**:
    - **Enhancement:** Update the documentation to reflect the latest state of the anchor system.

- **`AGENTMAP_REFACTOR_ROADMAP.md`**:
    - **Enhancement:** Update the roadmap with the latest progress and future plans.

## User Experience

- **(New file) `src/gui.rs`**:
    - **Enhancement:** Create a graphical user interface (GUI) to make the tool more accessible and easier to use. The GUI could provide a visual representation of the code architecture and make it easier to explore the symbol table and query results.
