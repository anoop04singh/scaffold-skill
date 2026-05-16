# Scaffold

Turn research papers into implementation-ready engineering plans and starter code.

## One-liner

Upload a paper PDF -> Scaffold extracts the core protocol/algorithm -> gives you a roadmap + starter scaffold in your target language.

## Problem It Solves

Going from reading a technical paper to writing the first reliable line of code is hard.  
Scaffold bridges that gap with implementation-focused output, not just summaries.

## What Scaffold Generates

For a given paper, Scaffold returns:

1. Core Contribution
2. Key Primitives
3. Dependency Map
4. Protocol Steps
5. Pseudocode
6. Starter Scaffold
7. Implementation Roadmap
8. Risks and Validation
9. Clarifying Assumptions

## Repo Structure

```text
.
├─ .claude/
│  └─ skills/
│     └─ scaffold/
│        ├─ SKILL.md
│        ├─ template.md
│        ├─ README.md
│        └─ examples/
│           └─ sample-output.md
├─ assets/
│  └─ scaffold-demo.gif
├─ downloads/
│  └─ scaffold-skill.zip
├─ index.html
├─ styles.css
├─ script.js
└─ README.md
```

## Install Scaffold Skill

### Path A: Claude Desktop (ZIP Upload)

1. Download `downloads/scaffold-skill.zip` (or the release ZIP).
2. Open Claude Desktop.
3. Go to `Customize` -> `Create Skill`.
4. Drop ZIP into `Upload Skill`.

### Path B: Manual Install

1. Unzip the skill package.
2. Copy `scaffold` folder to:
   - `~/.claude/skills/scaffold/` (personal), or
   - `.claude/skills/scaffold/` (project-local)

## Run Commands (in Claude)

```bash
/scaffold
/scaffold python
/scaffold rust
/scaffold solidity
/scaffold typescript
```

Optional second argument for focus:

```bash
/scaffold rust performance
/scaffold solidity security
```

## Landing Page

This repo includes a responsive landing page with:

- Download CTA for the skill ZIP
- Quick setup instructions (both install paths)
- Immersive demo GIF section
- Smooth reveal and scrolling animations
- Mobile-friendly layout

Open locally:

```bash
index.html
```

## Author

Made with ❤️ by anoop
