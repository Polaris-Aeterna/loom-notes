# sources/

Drop your raw study material here, then ask Claude Code to turn it into Loom notes.

- Accepted: **Markdown (`.md`)**, **plain text (`.txt`)**, **PDF (`.pdf`)**.
- One topic per file works best (a chapter, a lecture, a paper section).
- You do **not** pick the organizing idea. Claude Code reads the file and
  auto-identifies the *spine* (see [`SPINE-ANALYSIS-GUIDE.md`](../SPINE-ANALYSIS-GUIDE.md)).

Then say, e.g.:

> Make Loom notes from `sources/pigeonhole.md`.

Claude Code writes a finished notebook to `output/<notebook-name>/`. See
[`WORKFLOW.md`](../WORKFLOW.md) for the full flow and
[`.claude-instructions.md`](../.claude-instructions.md) for the syntax it follows.

Sources are tracked in git; generated PDFs under `output/` are not.
