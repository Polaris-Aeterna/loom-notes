# Spine Analysis Guide — how to find the one idea

A **spine** is the single most powerful organizing idea in a source: the thing that, once you
see it, reorganizes everything else around itself. Loom notes are built on a spine, not on the
source's table of contents. This guide teaches you to *find* it and to *score your confidence*.

> A chapter reorganized around its spine teaches far better than a faithful transcript. Your
> first job, before writing a single line of LaTeX, is to name the spine and justify it.

---

## 1. The five spine patterns

Most sources fit one of these. Name the pattern in `metadata.json` (`spine.pattern`).

### `single-theorem` — one result the rest orbits
There is a central theorem; definitions set it up, corollaries fall out of it, examples
illustrate it, and harder results are variations on it.
- **Tell:** everything in the source is *upstream* (machinery for) or *downstream* (consequences
  of) one statement.
- **Example:** Pigeonhole — one counting fact; the strong form, Ramsey `R(3,3)`, and
  Erdős–Szekeres are all "choose the boxes well, then count." Spine subtitle: *"Choose the boxes,
  then count."*

### `engine-list` — a toolbox indexed by when to use each tool
The material is a set of methods, each for a different situation. The spine is the *selection
table*: structure → tool.
- **Tell:** the source keeps saying "another way to…", "when X holds, use…".
- **Example:** concentration of measure as "8 engines"; numerical integration methods.
- **Loom move:** the front-page master table *is* the spine, with a `\trigger` per engine.

### `binary-opposition` — an idea and its mirror / dual
Two poles in tension or duality drive the whole topic; understanding one half tells you the other.
- **Tell:** primal/dual, syntax/semantics, time/frequency, local/global, upper/lower bound.
- **Example:** Fourier — a function and its transform; everything is "what does operation X on one
  side do to the other?"

### `organizing-dictionary` — a translation between two worlds
A correspondence maps objects on one side to objects on the other; the topic is reading the
dictionary in both directions.
- **Tell:** "corresponds to", "is the same as", an explicit table of analogies.
- **Example:** algebraic geometry's algebra ↔ geometry dictionary (ideals ↔ varieties).
- **Loom move:** the cheat-table has two columns; blank a few cells as the `\fillin`.

### `linear-narrative` — a genuine sequence
Sometimes the source order *is* the best order: a construction built in necessary steps, or a
historical/derivational arc where each step needs the last.
- **Tell:** you cannot reorder without breaking dependencies.
- **Caution:** this is the **fallback**, not the default. Only choose it after the other four
  genuinely fail. "I couldn't find a better shape" is a low-confidence spine.

---

## 2. Diagnostic questions

Ask these of the source, in order:

1. **Who is the protagonist?** What object/result is on stage the most? What does the source keep
   coming back to?
2. **What single idea must survive if I forget everything else?** If a student remembers exactly
   one sentence a year later, which sentence makes the rest re-derivable?
3. **Do the later sections orbit it?** Take your candidate and check: does each remaining section
   become "a setup for", "a consequence of", or "an instance of" it? If yes → strong spine. If the
   sections feel unrelated to your candidate → wrong candidate.
4. **Which pattern (§1) does that shape match?** Name it.
5. **Can I write the spine as one subtitle line?** If you can't compress it to a `\loomcover`
   subtitle, it's not sharp enough yet.

---

## 3. Choosing among candidates — three criteria

You will often have 2–3 candidates. Pick the one that maximizes:

- **Coverage** — how much of the source does this idea explain or organize? A spine that touches
  every section beats one that explains half.
- **Predictive power** — does holding the spine let you *guess what comes next*? A good spine
  makes the corollaries feel inevitable.
- **Teaching impact** — does building the notes around it *reorganize* the material into a better
  story, or does it just re-label the existing order? Prefer the spine that changes the shape.

When two candidates tie, prefer the **more concrete** one (a specific theorem over a vague theme)
and the one that yields a cleaner **front-page master table**.

---

## 4. Confidence rubric (the `confidence` field, 0–1)

Score how cleanly one spine dominates:

| score | situation |
|---|---|
| **0.9–1.0** | One spine obviously dominates; every section orbits it; the subtitle writes itself. |
| **0.75–0.89** | Clear winner, but one or two sections sit awkwardly under it. |
| **0.55–0.74** | Two plausible spines; you picked one on coverage/teaching impact, but the other is defensible. |
| **0.4–0.54** | The material is genuinely a list with no dominant idea; you imposed a `linear-narrative` or weak `engine-list` spine. |
| **< 0.4** | You could not find an organizing idea. Re-read; consider asking the user. Do not ship this silently. |

Write the score and a one-paragraph `reasoning` into `metadata.json`. The reasoning should name
the runner-up spine and say why the winner beat it.

---

## 5. Worked example (the bundled sample)

Source: [`sources/pigeonhole.md`](../../sources/pigeonhole.md).

- **Protagonist:** the pigeonhole principle itself (every section is it, sharpened or applied).
- **One surviving sentence:** "If `n > k` objects go in `k` boxes, some box has ≥ `⌈n/k⌉` — so
  the only skill is choosing the boxes."
- **Do sections orbit it?** Simple form = special case; strong form = the sharp version; examples
  and Erdős–Szekeres = "choose the boxes/labels, then count." Yes, all of it.
- **Pattern:** `single-theorem`.
- **Runner-up:** an `engine-list` of "tricks" — rejected: the tricks aren't different tools, they're
  the *same* tool with different box choices, so single-theorem has higher coverage and teaching
  impact.
- **Confidence:** ~0.9. Subtitle: *"Choose the boxes, then count."*

This is exactly what the generated `output/pigeonhole-principle/metadata.json` records.
