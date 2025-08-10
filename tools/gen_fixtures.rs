use std::fs::{self, File};
use std::io::Write;
use std::path::{Path, PathBuf};

// Lightweight deterministic RNG (no external deps)
struct Rng(u64);
impl Rng {
    fn new(seed: u64) -> Self { Self(seed) }
    fn next_u32(&mut self) -> u32 {
        // LCG parameters from Numerical Recipes
        self.0 = self.0.wrapping_mul(1664525).wrapping_add(1013904223);
        (self.0 >> 16) as u32
    }
    fn choose<'a>(&mut self, items: &'a [&'a str]) -> &'a str {
        let idx = (self.next_u32() as usize) % items.len();
        items[idx]
    }
    fn ident(&mut self, prefix: &str) -> String {
        let n = self.next_u32() % 10_000;
        format!("{prefix}_{n}")
    }
}

fn ensure_dir(p: &Path) {
    if let Some(parent) = p.parent() { let _ = fs::create_dir_all(parent); }
}

fn write_file(path: &Path, contents: &str) {
    ensure_dir(path);
    let mut f = File::create(path).expect("create file");
    f.write_all(contents.as_bytes()).expect("write file");
}

fn gen_region_comment(ext: &str, name: &str) -> String {
    let marker = format!("<r:{name}>");
    match ext {
        "py" => format!("# {}\n", marker),
        "rs" | "ts" | "tsx" | "js" | "jsx" | "go" | "java" | "dart" => format!("// {}\n", marker),
        _ => format!("// {}\n", marker),
    }
}

fn gen_python_file(mut rng: Rng) -> String {
    let mut s = String::new();
    s.push_str("# Generated Python sample\n");
    s.push_str(&gen_region_comment("py", "alpha"));
    s.push_str("import os\nfrom sys import path as sys_path\n\n");
    for _ in 0..3 { s.push_str(&format!("def {}():\n    return 42\n\n", rng.ident("func"))); }
    s.push_str(&format!("class {}:\n    def __init__(self):\n        self.x = 1\n    def {}(self):\n        return self.x\n\n", rng.ident("Class"), rng.ident("method")));
    s.push_str(&gen_region_comment("py", "omega"));
    s
}

fn gen_rust_file(mut rng: Rng) -> String {
    let mut s = String::new();
    s.push_str(&gen_region_comment("rs", "alpha"));
    s.push_str("use std::fmt;\n\n");
    for _ in 0..2 { s.push_str(&format!("fn {}() -> i32 {{ 1 }}\n", rng.ident("func"))); }
    s.push_str(&format!("struct {} {{ a: i32 }}\n", rng.ident("Thing")));
    s.push_str("impl fmt::Debug for Thing_0 { fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result { write!(f, \"Thing\") } }\n");
    s.push_str(&gen_region_comment("rs", "omega"));
    s
}

fn gen_ts_file(mut rng: Rng) -> String {
    let mut s = String::new();
    s.push_str(&gen_region_comment("ts", "alpha"));
    s.push_str("import fs from 'fs';\n\n");
    for _ in 0..3 { s.push_str(&format!("function {}() {{ return 1; }}\n", rng.ident("func"))); }
    s.push_str(&format!("class {} {{ constructor() {{}} {}() {{ return 2; }} }}\n", rng.ident("Clazz"), rng.ident("method")));
    s.push_str(&gen_region_comment("ts", "omega"));
    s
}

fn gen_go_file(mut rng: Rng) -> String {
    let mut s = String::new();
    s.push_str("package main\n\nimport \"fmt\"\n\n");
    s.push_str(&gen_region_comment("go", "alpha"));
    for _ in 0..2 { s.push_str(&format!("func {}() int {{ return 1 }}\n", rng.ident("Func"))); }
    s.push_str(&format!("type {} struct {{ A int }}\n", rng.ident("Type")));
    s.push_str("func main(){ fmt.Println(1) }\n");
    s
}

fn gen_java_file(mut rng: Rng) -> String {
    let mut s = String::new();
    s.push_str("package com.example;\n\n");
    s.push_str(&gen_region_comment("java", "alpha"));
    let cls = rng.ident("Class");
    s.push_str(&format!("public class {} {{\n    public {}() {{}}\n    public void {}() {{}}\n}}\n", cls, cls, rng.ident("method")));
    s
}

fn gen_dart_file(mut rng: Rng) -> String {
    let mut s = String::new();
    s.push_str(&gen_region_comment("dart", "alpha"));
    s.push_str("import 'dart:math';\n\n");
    s.push_str(&format!("class {} {{ {}(){{}} }}\n", rng.ident("Class"), rng.ident("ctor")));
    for _ in 0..2 { s.push_str(&format!("{}() {{ return 0; }}\n", rng.ident("func"))); }
    s
}

fn main() {
    // Simple CLI: gen-fixtures [--out examples/generated] [--per-lang 50] [--seed 1]
    let mut out_dir = PathBuf::from("examples/generated");
    let mut per_lang: usize = 50;
    let mut seed: u64 = 1;

    let mut args = std::env::args().skip(1);
    while let Some(arg) = args.next() {
        match arg.as_str() {
            "--out" => if let Some(v) = args.next() { out_dir = PathBuf::from(v); },
            "--per-lang" => if let Some(v) = args.next() { per_lang = v.parse().unwrap_or(per_lang); },
            "--seed" => if let Some(v) = args.next() { seed = v.parse().unwrap_or(seed); },
            _ => {},
        }
    }

    let langs = ["python", "rust", "ts", "go", "java", "dart"];
    for (i, lang) in langs.iter().enumerate() {
        let lang_dir = out_dir.join(lang);
        let _ = fs::create_dir_all(&lang_dir);
        for j in 0..per_lang {
            let mut rng = Rng::new(seed.wrapping_add((i as u64) << 32 | j as u64));
            let (fname, contents) = match *lang {
                "python" => (format!("file_{}.py", j), gen_python_file(rng)),
                "rust" => (format!("file_{}.rs", j), gen_rust_file(rng)),
                "ts" => (format!("file_{}.ts", j), gen_ts_file(rng)),
                "go" => (format!("file_{}.go", j), gen_go_file(rng)),
                "java" => (format!("File{}.java", j), gen_java_file(rng)),
                "dart" => (format!("file_{}.dart", j), gen_dart_file(rng)),
                _ => unreachable!(),
            };
            write_file(&lang_dir.join(fname), &contents);
        }
    }

    println!("Generated fixtures at {}", out_dir.display());
}

