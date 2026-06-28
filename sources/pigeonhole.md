# The Pigeonhole Principle

*Lecture notes — combinatorics, week 3.*

## 1. The statement

If you put `n` objects into `k` boxes and `n > k`, then some box holds at least two
objects. More sharply: if `n` objects go into `k` boxes, then some box holds at least
`⌈n/k⌉` objects. This is the **pigeonhole principle** (Dirichlet's box principle, 1834).

It looks trivial. It is trivial. Its power is entirely in *recognizing the boxes*: almost
every clever application is just a non-obvious choice of what the "boxes" and "objects" are.

The contrapositive is the engine of the proof: if *every* box held at most one object,
the total would be at most `k`, contradicting `n > k`.

## 2. The basic form and its proof

**Theorem (simple form).** A function `f : A → B` between finite sets with `|A| > |B|`
cannot be injective.

*Proof.* Suppose `f` were injective. Then `f` maps the `|A|` distinct elements of `A` to
`|A|` distinct elements of `B`, so `|B| ≥ |A|`. That contradicts `|A| > |B|`. Hence two
distinct elements `a ≠ a'` satisfy `f(a) = f(a')`. ∎

The whole proof is the contrapositive plus counting. The keystone is the single line
"injective ⟹ `|B| ≥ |A|`".

## 3. The strong form

**Theorem (strong form).** If `n` objects are placed in `k` boxes, some box contains at
least `⌈n/k⌉` objects.

*Proof.* If every box held at most `⌈n/k⌉ − 1` objects, the total would be at most
`k(⌈n/k⌉ − 1) < k · (n/k) = n`, a contradiction. ∎

Setting `n = k + 1` recovers the simple form: `⌈(k+1)/k⌉ = 2`.

## 4. Worked examples

**Socks.** A drawer holds black and brown socks. How many must you draw, in the dark, to
guarantee a matching pair? Boxes = the two colors; objects = drawn socks. With 3 socks in
2 color-boxes, some color has `⌈3/2⌉ = 2`. Answer: **3**.

**Birthdays.** Among any 13 people, two share a birth month. Boxes = 12 months; objects =
13 people. Since `13 > 12`, two collide.

**Acquaintances.** In any group of 6 people, three are mutual acquaintances or three are
mutual strangers. Fix a person `P`; of the other 5, by pigeonhole at least
`⌈5/2⌉ = 3` are all acquaintances of `P` or all strangers to `P`. Examining those 3
finishes the argument. (This is the Ramsey number `R(3,3) = 6`.)

## 5. A non-obvious application

**Theorem (Erdős–Szekeres, special case).** Any sequence of `n² + 1` distinct reals
contains a monotone subsequence of length `n + 1`.

*Proof idea.* Label each term `i` with the pair `(u_i, d_i)`: the length of the longest
increasing subsequence ending at `i`, and the longest decreasing one. If no monotone run
reaches `n + 1`, every label lives in the `n × n` grid `{1,…,n}²` — only `n²` boxes for
`n² + 1` terms. Two terms share a label; comparing them forces one of the two lengths to
grow, a contradiction. ∎

The recurring move: **build a function into a small label set, then count.** Define the
labels well and the pigeonhole does the rest.

## 6. Takeaways

- The principle is a one-line counting fact; the skill is choosing the boxes.
- Strong form `⌈n/k⌉` subsumes the simple form.
- Hard applications hide a clever map `objects → labels` into a set smaller than the domain.
