// <r:imports>
import { readFileSync } from 'fs';

// <r:func>
export function hello(name: string): string {
  return `Hello, ${name}`;
}

// <r:class>
export class Greeter {
  greet(name: string) { return hello(name); }
}
