---
inclusion: fileMatch
fileMatchPattern: ["**/*.ts", "**/*.tsx", "**/*.js"]
---

# Code Standards

## Naming
- Functions: `camelCase`, verb-first (`getUserById`, `validateInput`)
- Classes: `PascalCase`
- Constants: `UPPER_SNAKE_CASE`
- Files: `kebab-case.ts`

## Functions
- Max 20 lines per function
- Single responsibility — one function does one thing
- Always handle errors explicitly (no silent catches)

## TypeScript
- No `any` — use `unknown` and narrow types
- Prefer `interface` over `type` for object shapes
- Always type function return values

## Tests
- Every public function needs at least one test
- Test file lives next to source: `user.ts` → `user.test.ts`
- Test names: `should <do something> when <condition>`
