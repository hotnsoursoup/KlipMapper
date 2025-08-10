# VS Code Smart Profile – Workspace-Focused Extension Control

This document explains what the Smart Profile tooling does, what it affects, and exactly how to use it across different kinds of workspaces (including mixed repos).

## What It Does
- Detects the languages/frameworks present in your repo (Flutter/Dart, Node/JS/TS, Python, Go, Rust, Java, C#, C++/CMake, Qt, SQL).
- Generates a VS Code profile file at `.vscode/smart-profile.code-profile` that:
  - Enables extensions relevant to the detected stacks.
  - Disables known heavy language extensions not detected in this workspace.
  - Does not install or uninstall anything.
- Optional: updates `.vscode/extensions.json` to mark disabled stacks as `unwantedRecommendations` (reduces menu clutter and prompts).

## Scope and Safety
- Per window: The profile applies only to the VS Code window that uses it. Other windows can run different profiles simultaneously.
- Per workspace: Files under `.vscode/` only affect that folder/repo.
- No global side-effects: Nothing is disabled globally and nothing is installed.
- Reversible: Switch profiles or delete the generated `.code-profile` file at any time.

## Global Installation (Windows)
1. Create a folder on PATH (recommended): `D:\Tooling\VSCode`.
2. Copy these files there from `tools/vscode/`:
   - `smart_profile.py`
   - `vs-smart-profile.ps1`
   - `vs-smart-profile.cmd`
   - `pyproject.toml` (optional, for `uvx` usage)
3. Ensure `D:\Tooling\VSCode` is on your PATH.
   - PowerShell: `$env:Path += ';D:\Tooling\VSCode'`
   - Permanently via System Properties → Environment Variables → Path.
4. If PowerShell blocks the script the first time, either run the `.cmd` wrapper or `Unblock-File D:\Tooling\VSCode\vs-smart-profile.ps1`.

## Usage (from any repo)
- Basic (auto-detect whole folder):
  - `vs-smart-profile`
- Also mark disabled stacks as unwanted recommendations:
  - `vs-smart-profile --write-unwanted`
- Pick a workspace explicitly:
  - `vs-smart-profile --workspace C:\\path\\to\\repo`
- Focus detection on a subfolder in a mixed repo:
  - `vs-smart-profile --scan-root lib` (e.g., Flutter code)
  - `vs-smart-profile --scan-root web` (e.g., React/Node code)
- Force include/exclude stacks:
  - `vs-smart-profile --include flutter,node`
  - `vs-smart-profile --exclude java,cpp`
- Custom profile name:
  - `vs-smart-profile --profile-name "Flutter Focused"`

After running, import and assign the profile in VS Code:
- Profiles: Import Profile… → select `.vscode/smart-profile.code-profile`
- Profiles: Assign to Workspace…

VS Code remembers the assignment for this folder; other windows remain unaffected.

## uv (optional)
If you use `uv`, you can run without adding to PATH:
- `uvx --from D:/Tooling/VSCode vs-smart-profile --write-unwanted`

## Flags Reference
- `--workspace, -w <path>`: Root folder to operate on (default: current directory).
- `--scan-root <relpath>`: Only scan a subfolder (relative to `--workspace`) for detection.
- `--include <a,b,c>`: Force-enable only these stacks (overrides detection).
- `--exclude <a,b,c>`: Remove stacks from detection.
- `--write-unwanted`: Append disabled extension IDs to `.vscode/extensions.json.unwantedRecommendations`.
- `--profile-name <name>`: Name for the generated profile (default: `Smart Profile (auto – <folder>)`).

## Supported Stacks (current mapping)
- Flutter/Dart → `Dart-Code.dart-code`, `Dart-Code.flutter`
- Node/JS/TS → `dbaeumer.vscode-eslint`, `esbenp.prettier-vscode`
- Python → `ms-python.python`
- Go → `golang.go`
- Rust → `rust-lang.rust-analyzer`
- Java → `redhat.java`, `vscjava.vscode-java-pack`
- C# → `ms-dotnettools.csharp`
- C++/CMake → `ms-vscode.cpptools`, `twxs.cmake`, `ms-vscode.cmake-tools`
- Qt → `seanwu.vscode-qt-tools`
- SQL → `mtxr.sqltools`, `alexcvzz.vscode-sqlite`

You can extend this list by editing `EXT_MAP` in your global `smart_profile.py` and re-running the command.

## Mixed Repo Scenarios
- Top-level window for everything:
  - `vs-smart-profile` (detects both `/lib` Flutter and `/web` React; enables both sets).
- Focused Flutter window:
  - `vs-smart-profile --scan-root lib --include flutter --exclude node,java,cpp`
- Focused Web window:
  - `vs-smart-profile --scan-root web --include node`
- Best isolation: open `lib/` and `web/` in separate VS Code windows and run/assign profiles in each.

## Verify and Troubleshoot
- Verify detection: The CLI prints `Detected: ...` with stacks found.
- Verify in VS Code: Extensions view shows enabled/disabled states matching the active profile.
- If the profile doesn’t “stick”: Ensure you “Assign to Workspace…” after importing.
- Rollback: Switch profiles in VS Code or delete `.vscode/smart-profile.code-profile` and reopen the window.

## Design Choices
- Profiles over global toggles to avoid side effects across windows.
- Workspace files (`.vscode/*`) for repo-local behavior like quieting recommendations and hiding irrelevant command suggestions.
- No network or installs; purely declarative enable/disable lists.

