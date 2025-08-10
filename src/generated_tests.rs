#[cfg(test)]
mod tests {
    use std::fs::{self, File};
    use std::io::Write;
    use std::path::{Path, PathBuf};
    use crate::adapters::registry;
    use crate::fs_scan::scan_paths;
    use crate::checker::{check_paths, CheckResult};

    struct Rng(u64);
    impl Rng {
        fn new(seed: u64) -> Self { Self(seed) }
        fn next_u32(&mut self) -> u32 {
            self.0 = self.0.wrapping_mul(1664525).wrapping_add(1013904223);
            (self.0 >> 16) as u32
        }
        fn ident(&mut self, prefix: &str) -> String {
            let n = self.next_u32() % 10_000;
            format!("{prefix}_{n}")
        }
    }

    fn ensure_dir(p: &Path) { if let Some(parent) = p.parent() { let _ = fs::create_dir_all(parent); } }
    fn write_file(path: &Path, contents: &str) { ensure_dir(path); let mut f = File::create(path).unwrap(); f.write_all(contents.as_bytes()).unwrap(); }

    fn rc(ext: &str, name: &str) -> String {
        let m = format!("<r:{name}>");
        match ext { "py" => format!("# {}\n", m), _ => format!("// {}\n", m) }
    }

    fn py(mut r: Rng) -> String {
        let mut s = String::new();
        s.push_str(&rc("py", "alpha"));
        s.push_str("import os\n\n");
        s.push_str(&format!("def {}():\n    return 1\n\n", r.ident("f")));
        s.push_str(&format!("class {}:\n    def {}(self):\n        return 2\n", r.ident("C"), r.ident("m")));
        s
    }
    fn rs(mut r: Rng) -> String {
        let mut s = String::new(); s.push_str(&rc("rs", "alpha"));
        s.push_str(&format!("fn {}()->i32{{1}}\nstruct {}{{a:i32}}\n", r.ident("f"), r.ident("S"))); s
    }
    fn ts(mut r: Rng) -> String {
        let mut s = String::new(); s.push_str(&rc("ts", "alpha"));
        s.push_str(&format!("function {}(){{return 1}}\nclass {}{{ {}(){{}} }}\n", r.ident("f"), r.ident("C"), r.ident("m"))); s
    }
    fn go(mut r: Rng) -> String {
        let mut s = String::new(); s.push_str("package main\n\n"); s.push_str(&rc("go", "alpha"));
        s.push_str(&format!("func {}() int {{ return 1 }}\n", r.ident("F"))); s
    }
    fn java(mut r: Rng) -> String {
        let mut s = String::new(); s.push_str("package t;\n\n"); s.push_str(&rc("java", "alpha"));
        s.push_str(&format!("public class {} {{ public void {}() {{}} }}\n", r.ident("C"), r.ident("m"))); s
    }
    fn dart(mut r: Rng) -> String {
        let mut s = String::new(); s.push_str(&rc("dart", "alpha"));
        s.push_str(&format!("class {} {{ {}(){{}} }}\n{}(){{}}\n", r.ident("C"), r.ident("ctor"), r.ident("f"))); s
    }

    fn generate_repo(root: &Path, per_lang: usize, seed: u64) -> usize {
        let langs = ["python", "rust", "ts", "go", "java", "dart"];
        let mut total = 0usize;
        for (i, lang) in langs.iter().enumerate() {
            for j in 0..per_lang {
                let mut rng = Rng::new(seed.wrapping_add((i as u64) << 32 | j as u64));
                let (name, contents) = match *lang {
                    "python" => (format!("{}.py", rng.ident("file")), py(rng)),
                    "rust" => (format!("{}.rs", rng.ident("file")), rs(rng)),
                    "ts" => (format!("{}.ts", rng.ident("file")), ts(rng)),
                    "go" => (format!("{}.go", rng.ident("file")), go(rng)),
                    "java" => (format!("{}.java", rng.ident("File")), java(rng)),
                    "dart" => (format!("{}.dart", rng.ident("file")), dart(rng)),
                    _ => unreachable!(),
                };
                let path = root.join(lang).join(name);
                write_file(&path, &contents);
                total += 1;
            }
        }
        total
    }

    #[test]
    fn scan_then_check_on_generated_repo() {
        // Create a dedicated temp dir
        let root = std::env::temp_dir().join(format!("agentmap_gen_{}", std::process::id()));
        if root.exists() { let _ = fs::remove_dir_all(&root); }
        fs::create_dir_all(&root).unwrap();

        let total = generate_repo(&root, 5, 1234);
        assert!(total > 0);

        let adapters = registry::all().expect("adapters");

        // Scan and write sidecars
        let edited = scan_paths(vec![root.clone()], &adapters, true).expect("scan");
        assert!(edited > 0, "Expected sidecars to be created");

        // Now check should report valid files for supported languages
        let summary = check_paths(vec![root.clone()], &adapters).expect("check");
        assert_eq!(summary.invalid, 0, "No invalid sidecars");
        assert_eq!(summary.outdated, 0, "No outdated sidecars");
                               
        // Sanity: some valid files detected (unsupported ones are skipped as valid)
        assert!(summary.valid >= total, "At least as many valids as files");

        // Clean up
        let _ = fs::remove_dir_all(&root);
    }
}

