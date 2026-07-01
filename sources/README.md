# sources/

Drop your raw study material here, then ask Claude Code to turn it into Loom notes.

- Accepted: **Markdown (`.md`)**, **plain text (`.txt`)**, **PDF (`.pdf`)**.
- One topic per file works best (a chapter, a lecture, a paper section).
- You do **not** pick the organizing idea. Claude Code reads the file and
  auto-identifies the *spine* (see [`skill/reference/spine-analysis.md`](../skill/reference/spine-analysis.md)).

Then say, e.g.:

> Make Loom notes from `sources/pigeonhole.md`.

Claude Code writes a finished notebook to `output/<notebook-name>/`. See the
[README](../README.md#automated-notebooks-sources--output) for the full flow and
[`skill/reference/authoring.md`](../skill/reference/authoring.md) for the syntax it follows.

Sources are tracked in git; generated PDFs under `output/` are not.
