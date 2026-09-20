# HFL Empirical Snapshots — Writing and Production Guide

> **This is the collaborator copy**, kept in the code repo for people who clone
> it. The canonical version lives in the HFL memo library as
> `Empirical Snapshots Writing Guide.md`; if the two disagree, that one governs.

---

## 1. Overview

The _Household Finance Lab_ (HFL) is a public research enterprise whose goal is

- To publish high-quality, objective estimates of household finance facts, so as to push public discussion and policy debate towards views that concord with empirics.
- To produce meaningful academic research related to household finance that pushes social science discussions towards empirical fidelity
- To provide Queens College students with hands-on real world experiences to learn and practice analysis, research enterprise management, and mass communications by creating and operating a real public interest research organization.

_**The Snapshot Series.**_ The _Empirical Snapshot_ is the HFL's primary public-facing publication. Each installment presents a single, clearly bounded empirical finding from the data, written for an educated non-specialist reader.

**Governing format constraint:** Submissions should fill and be confined to the model presented in [`0722_99netw.pdf`](0722_99netw.pdf), the reference PDF in this repo. The HTML version on the site will present [as presented here](https://hhfinance.commons.gc.cuny.edu/2026/07/12/wealth-after-the-crisis-one-percent-vs-median/).

**Before using Snapshot 001 as a template, read §10.** It has five specific content deviations from this guide's rules — copy its layout, not those five choices.

---

## 2. Reader Model

Your reader is an educated non-specialist: a journalist, policy staffer, foundation program officer, or academically literate layperson. Write for high intelligence and sophistication. Avoid jargon. Define any technical term on first use or substitute a plain equivalent.

---

## 3. Page Layout

The snapshot uses a **two-column layout** within a one-page format:

- **Full-width header zone:** Publication badge flush left + date flush right; headline below spanning full width; author name and institution below headline.
- **Left column (text):** All prose components in sequence — deck, lead paragraph, Context, Findings, Implication, About the Author.
- **Right column (figure):** One chart or visualization. The figure zone may begin as high as the lead paragraph and run through the footer — it is not required to start at the Findings section. Size it to fill the column without crowding the author box or footer.
- **Full-width footer:** Rule above. Dataset name, reference page link and code URL flush left; the license tile flush right. The license appears once, in the tile — not on the left as well.

The figure must not bleed into the text column. The text column carries all prose; the right column carries only the figure and its caption.

---

## 4. Document Components

### Component Sequence and Word Budgets

|Component|Target|Function|
|---|---|---|
|**Headline**|10–14 words|States the finding|
|**Deck**|25–35 words|1–2 sentences: finding + direction, typographically bold|
|**Lead paragraph**|50–70 words|What, how large, who, why it matters|
|**Context block**|130–165 words|Stakes and debate setup; 2 paragraphs|
|**Finding block**|150–175 words|Pattern description; 2–3 bold sub-points|
|**Implication block**|75–100 words|Conditional implications; develops practical meaning|
|**Total body**|~450–530 words|Constrained by one-page fit|

Context's target was widened from an earlier draft (100–130) to match what actually holds a page: Snapshot 001's Context runs ~162 words and the page fits fine. The total-body ceiling is the binding constraint — hold Context, Findings, and Implication to it in combination, not each in isolation. `snapshot-template.Rmd`'s inline word-count comments match this table (as of the `hflsnap` 0.2.0 template) — if you copied a `.Rmd` from an older project, check its comments still say 130–165 / 150–175 / 75–100 before trusting them.

The sequence is fixed. It follows the **inverted pyramid** (journalism) and **progressive disclosure** (instructional design): lead with the finding, then provide the stakes, then the evidence, then the inference. Do not reorder.

---

## 5. Data and Estimation Conventions

The rules below govern the analysis behind a Snapshot. They exist because the
series publishes single numbers to a lay audience: a number that is wrong, or
right about something other than what the text claims, is not recoverable by
good writing.

### 5.1 Variable Selection

- **Prefer the Federal Reserve summary-extract variables** for standard concepts — `edn_inst`, `networth`, `income`, `install`. They are built by the Fed's own code from the raw survey items and are documented in the Bulletin macro.
- **Raw `x`-variables answer narrower questions than their names suggest.** `x7805` is the amount originally borrowed on the household's *first* education loan — not the balance owed, and not the total across loans. Read the codebook entry for any raw variable before using it, and record in a code comment what it measures.
- If a summary variable exists for the concept, using a raw variable instead needs a stated reason.

### 5.2 Dollar Units

- Summary-extract dollar variables arrive **already adjusted to 2022 dollars**. Raw `x`-variables are in survey-year dollars.
- State the dollar year in the body text and in the figure caption.
- Never compare unadjusted dollars across survey years. Between 2010 and 2022 the adjustment factor is 1.37 — large enough to invent or erase a trend on its own.
- `scf_deflate()` converts estimates back to nominal survey-year dollars. Applying it to a summary variable that is already in 2022 dollars, or applying it twice, compounds the error silently.

### 5.3 Sample Size

- Compute the **unweighted number of observations behind every published cell** and keep it in the code output, even though it does not appear on the sheet.
- **Floor: 25 unweighted observations.** Below that, do not break the group out. Fold it into a residual category, drop it, or report it explicitly as indicative.
- A group that clears the floor in one year but not the other cannot anchor a claim about change.

### 5.4 Comparability Across Years

- Check the public-file coding before comparing a category across waves. Asian respondents are combined into the residual category in the older public files, so "Asian" and "Other" do not mean the same thing in 2010 as in 2022.
- The same caution applies to top-coding, age bands, and any question that changed wording or answer options between waves.

### 5.5 Reproducibility of Numbers

- **No typed estimates.** Every figure in the prose comes from inline R reading the same objects that produce the chart, and the chart's data frame is built from those objects too.
- Hand-entering values is how a measurement error survives to the PDF: the prose, the chart, and the code all agree because they were all typed from the same wrong source.

### 5.6 Validation

- Before release, check at least one aggregate from the analysis against a **published benchmark** — the Fed's historical tables, a Bulletin figure, or a published estimate from a Reserve Bank — and name the benchmark in a code comment.
- A mismatch is not always an error, but it must be explained before the Snapshot goes out.

### 5.7 What to Report

- A conditional mean — "average among borrowers" — moves for two reasons: the amounts change, or the set of people holding the item changes. **Report the incidence alongside it.** The composition shift is often the more interesting finding.
- For skewed variables, check the median as well as the mean. If the mean moves while the median does not, the movement sits in the tail and the text should say so.
- Compute standard errors for every published estimate. They do not appear on the sheet, but they decide which verbs the prose is entitled to (see §7.5).

---

## 6. Production Workflow

### 6.1 How the System Works

Snapshots are written in **R Markdown** and rendered with a standalone LaTeX template. Everything the layout needs is a set of plain files, not an installed dependency graph:

|Item|Purpose|
|---|---|
|`snapshots.tex`|The one-page LaTeX template (Pandoc → XeLaTeX). Do not edit.|
|`fonts/`|Bundled fonts: Bricolage Grotesque, Archivo, Spline Sans Mono.|
|`default.csl`|Citation style, if the snapshot cites sources.|
|`snapshot-template.Rmd`|Starter file with the full annotated YAML header.|

A LaTeX template can only produce a PDF, so the WordPress companion HTML is a second Pandoc pass over the already-knitted Markdown (`<file>.knit.md`), not a separate output flag.

**Getting these files into a new project — two options:**

- **Recommended: the `hflsnap` package.** Install it once (§6.2), then run `hflsnap::hfl_use()` in any new project folder to copy `snapshots.tex`, `fonts/`, `default.csl`, and a starter `snapshot.Rmd` into place, and use `hflsnap::render_snapshot("snapshot.Rmd")` to knit both outputs in one call.
- **Manual.** Copy the same four items by hand from an existing snapshot project (§6.3) and `source("render-snapshot.R")` to render.

Either way, the resulting `.Rmd` is a plain `rmarkdown::pdf_document` — `hflsnap` does not define a custom output format. A collaborator who receives your project folder can knit it with plain rmarkdown, without `hflsnap` installed, as long as the copied support files travel with it.

**A note on `hfwgtex`.** An earlier version of this pipeline used a now-retired package by that name (installed via `devtools::install_github`, with a `hfwgtex::snapshot_pdf` output format that emitted `wordpress: html` directly as part of the knit). `hflsnap` is a different, current package — it ships files and a thin rendering wrapper, not a custom output format. If you find guidance elsewhere referencing `hfwgtex`, `hfwg_use()`, or `wordpress:` YAML flags, it describes the old system. Ignore it.

### 6.2 One-Time Setup

`hflsnap` lives in the `hflsnap/` subdirectory of this repo (`github.com/jncohen/empirical-snapshots`), not as its own repo. Install it from there:

```r
install.packages("devtools")     # if not already installed
devtools::install_github("jncohen/empirical-snapshots", subdir = "hflsnap")
```

**Updating.** Re-running the same `install_github()` call always pulls whatever is on `main` — there's no version to bump on your end. If you want to pin to a specific commit or tag (e.g. after a breaking change to `hfl_use()`), install with `ref = "<commit-sha-or-tag>"` instead.

**Offline / no GitHub access:** install from the tarball checked into the repo root instead:

```r
devtools::install_local("hflsnap_0.2.0.tar.gz")
```

This is a point-in-time snapshot of the package, not a substitute for pulling from GitHub — it won't include changes made after that tarball was committed. **Rebuild it (`R CMD build hflsnap`) whenever you change anything under `hflsnap/`**, or the offline path silently ships an older package than the source tree.

You also need:
- **Pandoc**, bundled with RStudio.
- **A TeX distribution.** If you don't have one:
    ```r
    install.packages("tinytex")
    tinytex::install_tinytex()
    ```
    TinyTeX is recommended — it auto-downloads any missing LaTeX packages on first compile.

### 6.3 Project Setup

For each new Snapshot:

```r
dir.create("my-snapshot")
setwd("my-snapshot")
hflsnap::hfl_use()
```

This writes:

```
my-snapshot/
├── snapshot.Rmd          ← starter file — rename it and start writing
├── snapshots.tex         ← copied, do not edit
├── default.csl           ← copied
├── fonts/                ← copied
└── figures/              ← create this yourself for your exported chart(s)
```

If you'd rather not install the package, copy the same four items by hand from an existing snapshot project and start from `snapshot-template.Rmd`, not a blank file — it has the full annotated YAML header and section scaffolding described below.

**Loading data.** Point `scf_load()` at the data directory — `scf_load(2022, data_directory = scf_dir)` — rather than `setwd()`ing into it. A `setwd()` inside a chunk is reset by knitr when that chunk ends, so later chunks write their output somewhere other than where you expected. Starter files inherited from older projects may also carry `rm(list=ls())`, `gc()`, or an `hfwgtex::hfwg_use()` call at the top; delete all three.


### 6.4 The Snapshot YAML Header

Below is the annotated header, matched to the fields `snapshot-template.Rmd` and `snapshots.tex` actually read:

```yaml
---
# ── DOCUMENT IDENTITY ──────────────────────────────────────────────
title: "Finding headline here — include a number and direction"
  # 10–14 words; states the finding, not the topic (see §7.1)
author: "Your Full Name"
date: "`r format(Sys.Date(), '%d %b %Y')`"

snapshot: true

# ── SERIES IDENTITY (utility bar across the top) ───────────────────
snapshot_label: "Empirical Snapshot"
snapshot_number: "002"            # increment for each new Snapshot
snapshot_topic: "Topic"           # e.g. "Net Worth", "Debt", "Income"
snapshot_util_left: "Queens College · CUNY"
# snapshot_util_right: "SCF 2022"   # optional; adds "· SCF 2022" at far right

# ── DECK ────────────────────────────────────────────────────────────
abstract: |
  25–35 words stating the finding and its direction. Renders as the
  bold lead statement at the top of the left column. Do NOT use this
  field for methods or caveats.

# ── FEATURED VISUALIZATION ──────────────────────────────────────────
snapshot_feature: "figures/your-figure.png"
snapshot_feature_label: "Fig. 1"
snapshot_feature_caption: |
  What is shown; data source; sample definition; year(s); notes.
# snapshot_feature_height: "4.3in"   # default cap; lower it if the sheet spills.
  # The plate is capped by height AND width, whichever binds first.
  # Landscape figures (~3:2) fill the column best; a 3:4 portrait
  # renders at ~95% width. Do NOT hardcode a background — export both
  # variants in one call with hflsnap::hfl_save_figure() and point this
  # field at the bone file (see §8.4). Add hflsnap::hfl_watermark() as
  # the LAST element of the ggplot chain (see §8.3). Let this caption
  # field do the labelling — drop title/subtitle from the ggplot
  # itself, or they duplicate the caption beneath the plate.

# ── ABOUT THE AUTHOR ────────────────────────────────────────────────
snapshot_byline_name: "Your Full Name"
snapshot_byline_title: "Research Associate, HFL"
snapshot_byline_affiliation: "City University of New York, Queens College"
snapshot_byline_link: "hhfinance.commons.gc.cuny.edu"
  # title, affiliation and bio each render on their own line. Do not put
  # a "\n" inside one field to fake a break — LaTeX reads it as a space.
# snapshot_byline_bio: "One sentence describing your research focus."
# snapshot_author_image: "images/author.png"   # else a monogram disc is drawn

# ── FOOTER / PROVENANCE ─────────────────────────────────────────────
snapshot_switch_section: 3
  # The body section (1-indexed: Context=1, Finding=2, Implication=3)
  # at which the left column switches to run under the figure. Keep
  # three sections, or move this if you change the structure.
snapshot_license: "cc-by-4.0"
  # HFL house license. CC BY permits commercial reuse with attribution --
  # deliberate, so journalists and other commercial outlets can republish
  # without seeking permission. Do not narrow it without an editor's say-so.
  # Other keys the template recognises: cc-by-sa-4.0, cc-by-nc-4.0,
  # cc-by-nc-sa-4.0, cc0-1.0, all-rights-reserved, none
snapshot_data_note: "Data: Survey of Consumer Finances <hhfinance.commons.gc.cuny.edu/scf>"
snapshot_code_url: "github.com/jncohen/your-repo-name"

# ── BIBLIOGRAPHY (only if the snapshot cites sources) ───────────────
# bibliography: snapshots.bib
# csl: default.csl
  # Both are plain Pandoc fields. `snapshots.tex` carries the CSL macros
  # and `default.csl` is copied by hfl_use(), so citations render on the
  # sheet without further setup. Omit both lines if you cite nothing.

# ── TYPOGRAPHY (leave unset) ─────────────────────────────────────────
# fontset/accent are intentionally NOT set here: the snapshot layout
# supplies the HFL faces (Bricolage / Archivo / Spline Sans Mono) and
# defaults the accent to vermilion E5402A. Setting either field
# overrides that default — don't, unless the editor asks you to.
fontpath: fonts/
numbersections: false
doublespace: false
linenumbers: false
maincolumns: 1

# ── OUTPUT ──────────────────────────────────────────────────────────
output:
  rmarkdown::pdf_document:
    template: snapshots.tex
    latex_engine: xelatex
    keep_tex: true       # as shipped; leaves a .tex alongside the PDF for debugging
    keep_md: true        # required: .knit.md feeds the WordPress companion
---
```

After the closing `---`, write the Snapshot body in standard R Markdown. Anything before the first `#` heading becomes the lead paragraph. Use `# Context`, `# Finding`, `# Implication` as section headings, and `**bold text**` for Finding block sub-headings.

**Other fields `snapshots.tex` reads.** None are needed for a standard Snapshot; the defaults are what hold the page. Set one only for a specific reason.

|Field|Default|What it does|
|---|---|---|
|`snapshot_tiles`|`["<license>"]`|The small tiles at the bottom right of the footer. Supply a list to override; doing so replaces the license tile rather than adding to it.|
|`snapshot_license_text`|unset|Free-text license string, overriding `snapshot_license` entirely. Use only for a license the key list doesn't cover.|
|`snapshot_author_initials`|`"JC"`|Initials in the monogram disc when no `snapshot_author_image` is given. **Set this if you are not Joe Cohen** — the default is hardcoded and will otherwise print the wrong initials.|
|`snapshot_wordmark_size`|`15pt`|Masthead wordmark; the HF square scales with it.|
|`snapshot_title_size`|`21pt`|Headline size.|
|`snapshot_lede_size`|`8.8pt`|Deck size.|
|`snapshot_body_size`|`8.4pt`|Body size.|
|`snapshot_body_leading`|`11.7pt`|Body leading.|

The five type-scale fields exist for one purpose: recovering a page that will not fit after the prose is already as tight as it should be. Reach for `snapshot_feature_height` first (§8.1), then cut words, and only then adjust type. `snapshot-template.Rmd` shows smaller sample values (8.4 / 8.0 / 11.2) in its commented block — those are illustrations of tightening, not the defaults.

### 6.5 Rendering

From the R console, in the project folder:

```r
hflsnap::render_snapshot("your-file.Rmd")
```

(Or, without the package: `source("render-snapshot.R")` then `render_snapshot("your-file.Rmd")` — same logic, copied into your project instead of installed.)

This knits the PDF, then runs a second Pandoc pass over the resulting `your-file.knit.md` to produce the WordPress companion. It writes two files:

|File|Purpose|
|---|---|
|`your-file.pdf`|The formatted one-page Snapshot|
|`your-file-wordpress.html`|Body-only HTML to paste into the WordPress editor|

The HTML is deliberately body-only (no `<head>`, no CSS) — WordPress's synced pattern supplies the styling. There is no separate checklist file; follow the publishing steps in §6.6 directly.

On the first render, TinyTeX may auto-download missing LaTeX packages — this takes a minute once, then packages are cached.

**Page fitting.** After the first render, inspect the PDF. If the left column ends early or the page feels underfilled, increase `snapshot_feature_height` in small increments and re-render. If the author box or footer looks crowded, reduce it. The goal is a full, balanced one-page layout. Do not use the height field to compensate for a chart with excessive internal whitespace — redesign the chart first. Do not add `\LaTeX` commands to override spacing, margins, or fonts in `snapshots.tex`.

### 6.6 Publishing to the HFL WordPress Site

The HFL WordPress site is at `hhfinance.commons.gc.cuny.edu` on CUNY Academic Commons. As a Contributor, you can create and submit Snapshot posts for review; a site editor publishes them.

**Arrange the author account first.** The post's author field lists site users only. A Staff Members profile is a directory entry, not a login, and cannot be credited as author. A student contributor needs a CUNY Academic Commons account added to the site under **Users → Add Existing User** (role: Author or Contributor) before the Snapshot is ready to publish — not after.

**Step-by-step:**

1. **Log in** at `hhfinance.commons.gc.cuny.edu/wp-admin` using your CUNY Academic Commons credentials.
2. **Create a new post** under **Posts → Add Post**. Snapshots are regular posts. The separate "Snapshot" content type was retired in September 2026; any instruction to use "Snapshots → Add New" is out of date.
3. **Enter the headline** in the Title field, and shorten the slug if the headline is long.
4. **Tick the Snapshots category** in the sidebar. This is the switch that makes the post a Snapshot: it produces the dated URL (`/YYYY/MM/DD/slug/`) and brings up the Snapshot field panel below the editor.
5. **Fill the HFL Snapshot panel:** Eyebrow ("Empirical Snapshot · No. 00N"); Deck; up to four stat figure-and-label pairs; Source caption (dataset · years); Report PDF (upload the PDF under **Media → Add New** first, then paste its URL); Source code URL; Figure image.
6. **Set the Featured Image** to the white figure variant. This is the chart that renders beside the text.
7. **Add the body.** Open `<your-file>-wordpress.html`, and paste its contents into the editor's code view. *(Provisional, pending the layout decision: the pasted prose has to sit inside the Snapshot shell rather than alone on the page. Until the shell is settled, insert the "HFL Snapshot Body" pattern and put the prose in its slots.)*
8. **Add tags**, then **Submit for Review**. Contributors cannot publish directly; the site editor publishes.

There is no auto-generated checklist file to walk through this — this section is the checklist. Keep it open during your first upload.

---

## 7. Component Specifications

### 7.1 Headline

The headline states the **finding**, not the topic. It is the most important sentence in the document for discoverability and social sharing. It goes in the YAML `title` field.

|✗ Topic (weak)|✓ Finding (strong)|
|---|---|
|"Wealth Accumulation After the 2008 Crisis: One Percent vs. Median Households"|"Top-End Wealth Recovered Three Years Faster Than Median Households After the 2008 Financial Crisis"|
|"New Data on American Household Debt"|"Lower-Income Households Carry Credit Card Debt at Three Times the Rate of Upper-Income Households"|
|"Retirement Savings Inequality"|"The Median Black Household Holds One-Tenth the Retirement Assets of the Median White Household"|

**Rules:**

- Include at least one number or comparative term
- Active voice; no nominalizations
- No jargon; no hedging phrases ("may suggest," "could indicate")
- Do not split topic from finding with a colon — merge them into a single finding statement

A/B evidence from social media experiments consistently shows that finding headlines outperform topic headlines on click-through and sharing rates. The headline is the only element that travels in social sharing contexts; it must carry the finding on its own.

### 7.2 Deck

The deck is the YAML `abstract` field. It renders as a **bolded 1–2 sentence statement** at the top of the left column, above the lead paragraph. A reader who sees only the deck should know the direction and magnitude of the finding.

The deck is not the lead paragraph. It is shorter, typographically bolder, and written to stand alone if stripped of all context. No hedges, no footnotes, no methods language.

**Strong deck example** (from Snapshot 001): _"Both the median and 99th percentile lost wealth after the 2008 crisis. Both recovered, but the 99th percentile recovered faster."_ This works because it states a complete finding in two sentences with no wasted words.

### 7.3 Lead Paragraph

The lead paragraph is the first paragraph of the `.Rmd` body (before any section heading). It answers four questions **in this order**: _What happened? How large is it? Who is affected? Why does it matter?_

The lead must contain the key quantitative values. Do not open with context, methodology, caveats, or literature review. Opening with caveats signals low confidence and trains readers to discount findings before they have seen them.

The lead is the primary unit readers share or quote. Write it so it stands alone without the rest of the document.

### 7.4 Context Block

Marked with a `# Context` heading in the `.Rmd`. Two paragraphs that explain why this finding matters to someone outside academia.

**What to include:**

- A real-world debate or public concern where this finding is directly germane
- Stakes: what turns on knowing this fact
- If relevant, a brief reference to prior literature or public discourse that establishes why the question exists

**What to exclude:**

- Dataset descriptions. Methods belong in the footer and the HFL dataset reference pages.
- Procedural framing: "In this snapshot, we examine..." states what you are doing, not why it matters. Cut it.
- Parochial framing: if the finding is national in scope, frame it nationally. A local example may appear as one illustration, not as the primary context.

### 7.5 Finding Block

Marked with a `# Finding` heading. Two to three short paragraphs, each introduced by a **bold sub-heading** (`**Sub-heading text.**`) that states the sub-finding in plain English.

**Four rules:**

1. **Open with the pattern, not the procedure.** Do not begin with "The figure shows..." or "The figure to the right depicts..." These describe the chart, not the data. Begin with what the data show.
    
    |✗ Procedure|✓ Pattern|
    |---|---|
    |"The figure to the right depicts changes in median and top percentile household net worth across each survey year between 2007 and 2022."|"Both wealth groups fell sharply after the 2008 crisis and required years to recover."|
    
2. **State results in plain numbers.** Use actual values: percentages, medians, ratios, differences. Do not use vague quantifiers. Readers remember numbers; they discard adjectives.
    
3. **Provide exactly one comparison anchor.** Raw numbers are often uninterpretable without a reference point. Provide one — a comparison group, a historical value, or a threshold. More than one anchor creates split attention; fewer leaves the number floating.
    
4. **Acknowledge uncertainty in plain language.** Do not use p-values, confidence interval notation, or "statistically significant." Instead:
    
    - "This estimate is reliable to within ±2 percentage points."
    - "The pattern is consistent across survey waves, though the gap is larger at the extremes than in the middle of the distribution."
    - "Top-percentile estimates from household surveys carry meaningful sampling variance; treat these values as approximate."

    When the estimates cannot be told apart from sampling variation, the verbs carry that: *appear to*, *suggest*, *point toward*. One plain sentence should say why — small subgroup samples, wide spread — placed where the reader meets the numbers rather than buried at the end. Do not hedge the Finding block and then state an unhedged conclusion in the Implication block.

**Sub-heading format:** The sub-heading states the sub-finding, not a topic. "Top-End Wealth Recovered Faster" is a finding. "Comparing Groups" is a topic.

### 7.6 Implication Block

Marked with a `# Implication` heading. One paragraph (75–100 words) stating what the finding suggests practitioners, policymakers, or researchers should consider. Use conditional language: "suggests," "may warrant," "raises questions about."

Do not overreach. Restrict to what the data can support.

|✗ Overreach|✓ Implication|
|---|---|
|"This proves systemic bias in the financial system."|"The timing gap raises questions about whether recovery-period programs reached median-wealth households as effectively as high-wealth households."|
|"We need legislation to address this immediately."|"Households whose retirement security depends on home equity or liquid savings may have faced greater long-run consequences from delayed recovery than top-end wealth data alone suggest."|

**A strong implication block does two things:** it states the conditional inference, and it **names who is concretely affected and how**. Restating the finding in slightly different words is not an implication.

### 7.7 About the Author

Controlled by the `snapshot_byline_*` YAML fields — not written in the body. Required; not optional. Renders at the bottom of the left column, above the footer rule.

The block stacks one item per line, beside the portrait or monogram disc:

```
Joseph Nathan Cohen                  ← snapshot_byline_name
Associate Professor of Sociology     ← snapshot_byline_title
City University of New York,         ← snapshot_byline_affiliation
  Queens College
One sentence on research focus.      ← snapshot_byline_bio (optional)
jncohen.commons.gc.cuny.edu          ← snapshot_byline_link
```

Give each element its own field. Do not embed a `\n` inside one field to force a break: YAML turns it into a real newline, but LaTeX reads a bare newline as a space, so the line silently runs on.

The About the Author block is part of HFL's brand-building function. It converts a public-facing document into a credentialing artifact for the contributing researcher.

### 7.8 Footer

Rendered automatically from YAML. `snapshot_data_note` and `snapshot_code_url` set the left block; `snapshot_license` sets the tile at bottom right, which is the only place the license is printed. Update `snapshot_data_note` for whichever dataset this Snapshot uses — do not leave it as the default placeholder.

---

## 8. Figure Design

### 8.1 Placement and Sizing

One figure per snapshot. The figure is specified in the `snapshot_feature` YAML field; it does not appear in the body text. `snapshots.tex` places it in the right column, and it may start as high as the top of the column (see §3).

`snapshot_feature_height` controls the height of the figure zone (default `"4.3in"`). After the first render, adjust it to fill the page — lower it if the sheet spills, raise it if the page looks underfilled. Treat this as a normal production step, not an error condition.

### 8.2 Core Design Principles

- **Finding title, not topic title.** The figure title states the finding. "Top-End Wealth Recovered Faster After the Financial Crisis" ✓. "Net Worth by Percentile, 2007–2022" ✗.
- **Data-ink ratio.** Remove gridlines unless necessary for reading values; remove background colors; label data directly on the chart rather than using a legend wherever possible.
- **Export two background variants.** The sheet wants bone, the web wants white — see §8.4. Use `hflsnap::hfl_save_figure()`; do not hand-pick one background and use it for both.
- **Aspect ratio.** Landscape figures (~3:2) fill the column best; a 3:4 portrait renders at ~95% width. Design for whichever orientation the data calls for — do not force a landscape chart into a portrait canvas or vice versa.
- **Readable at 50% zoom.** All labels and axis text must remain legible at half size, simulating how the figure appears embedded in a blog post.
- **Title length.** A long title clips at the six-inch export width. Break it across two lines with `\n` rather than shrinking the type. Where value labels crowd each other, rotate them to vertical (`angle = 90, hjust = -0.1`) instead of reducing their size.
- **Caption.** Every figure carries a complete caption in `snapshot_feature_caption` including: (1) what is shown, (2) data source, (3) sample definition, (4) year(s), (5) relevant notes. Let the caption do the labelling — drop title/subtitle text from the ggplot itself, or they duplicate the caption beneath the plate.
- **Attribution footer.** Every figure carries the HFL footer, added with `hflsnap::hfl_watermark()` — see §8.3. Do not hand-roll it as a `labs(caption =)` string.

### 8.3 The Attribution Footer

A figure that leaves the sheet — screenshotted, pasted into a deck, saved off the website — must still say where it came from. The WordPress companion does not embed the figure, so the image circulating publicly is the PNG you upload by hand; a footer drawn by the LaTeX template would not travel with it. The footer therefore has to be baked into the PNG, which means it belongs in the plotting code.

Add it as the **last** element of the ggplot chain:

```r
library(hflsnap)
library(ragg)

fig <- ggplot(...) +
  ...
  theme_minimal(base_size = 11) +
  theme(...) +
  hfl_watermark()          # must follow theme(): it sets plot.caption
```

It renders two lines, flush left, in Spline Sans Mono at the sheet's footer grey:

```
HOUSEHOLD FINANCE LAB
DATA: SURVEY OF CONSUMER FINANCES
```

Change the second line for any Snapshot not built on the SCF:

```r
hfl_watermark(data_note = "Data: American Community Survey")
```

**Two rules that are easy to get wrong.**

- **Place it after any complete theme.** `hfl_watermark()` sets `plot.caption` and `plot.caption.position`. A complete theme that follows it (`theme_minimal()`, `theme_bw()`, and friends) resets both, and the footer silently reverts to panel-anchored and right-aligned — the one failure that defeats the whole point. A later `theme()` that styles `plot.caption` also overrides the type. A later `theme()` touching unrelated elements is harmless.
- **Save with the `ragg` device**, or the bundled font is ignored and the footer renders in the device default:

    ```r
    ggsave("figures/fig1.png", fig, width = 5, height = 3.4,
           dpi = 300, device = ragg::agg_png)
    ```

The footer is anchored to the image edge, not the plot panel, so it lands in the same position on every figure regardless of how wide the y-axis labels are. Do not reposition it per figure — uniformity across the series is the point.

**No license string in the footer.** The license is declared once, in `snapshot_license`, and rendered in the sheet footer. Repeating it on the image guarantees the two eventually disagree.

### 8.4 Two Background Variants

Export every figure twice:

| File | Background | Used for |
|---|---|---|
| `figures/fig1.png` | Bone `#EFEDE6` | The sheet — point `snapshot_feature` here |
| `figures/fig1-web.png` | White | WordPress, slides, republication |

`hflsnap::hfl_save_figure()` writes both from one call:

```r
hfl_save_figure(fig, "figures/fig1.png", width = 4.2, height = 5.6)
```

It sets each background, routes both through `ragg::agg_png` so the footer keeps its typeface, and creates the `figures/` directory if it is missing. It replaces a bare `ggsave()` call — do not use both.

**Why two.** Neither background serves both contexts, and the mismatch is the same size in each direction: a white figure on the bone sheet reads as a panel pasted onto the page, and a bone figure in a white article reads as a warm rectangle. Choosing one background does not remove the seam, it just decides which audience sees it. Exporting twice costs one function call and removes the decision from the author entirely.

Point `snapshot_feature` at the **bone** file. Upload the **white** file to WordPress, and send that one to anyone asking to republish the chart.

**One trap.** `ggsave(bg = ...)` cannot override a background set in the plot's theme. If `plot.background` is filled, the exported file carries that fill whatever `bg` says — a "white" export of a bone-themed plot comes out bone. `hfl_save_figure()` sets both; a hand-rolled `ggsave` has to change the theme as well as the device background.

---

## 9. Typography and Layout

Typography is controlled by `snapshots.tex` and should not be changed for Snapshots. The following describes the output for reference:

- **Typeface:** Bricolage Grotesque for display, Archivo for body/UI text, Spline Sans Mono for labels
- **Body size:** tight single spacing; compact blog masthead styling
- **Column layout:** two columns
- **Section headers:** rendered automatically from `#` headings in the body
- **Bold emphasis:** reserved for the deck (automatic) and Finding block sub-headings; use sparingly elsewhere — at most one emphasis phrase per 100 words of body text

Do not add `\LaTeX` commands to override spacing, margins, or fonts. If the page does not fill correctly, adjust `snapshot_feature_height` or edit the prose length.

---

## 10. Known Deviations in Snapshot 001

Snapshot 001 ("Wealth Accumulation After the 2008 Crisis") is the canonical reference for HFL layout, deck structure, figure placement, About the Author format, and footer. Use it as the layout template.

However, it has five specific deviations from the rules this guide specifies. Produce the canonical's layout while correcting these deficiencies:

|#|Element|What Snapshot 001 does|What it should do|
|---|---|---|---|
|1|**Headline**|Topic headline with colon: "Wealth Accumulation After the 2008 Crisis: One Percent vs. Median Households"|Finding headline with a number: "Top-End Wealth Recovered Three Years Faster Than Median Households After the 2008 Financial Crisis"|
|2|**Finding block opening**|"The figure to the right depicts changes in median and top percentile household net worth..." (procedure language)|Open with the pattern: "Both wealth groups fell sharply after the 2008 crisis and required years to recover."|
|3|**Uncertainty language**|None|One plain-language sentence: e.g., "Top-percentile estimates from household surveys carry meaningful sampling variance; treat these values as approximate."|
|4|**Implication depth**|Restates finding: "shared recovery with unequal timing"|Names who is affected and what the timing gap means: households relying on home equity or asset accumulation for retirement or other long-run financial plans|
|5|**Context framing**|Second paragraph pivots to NYC politics, limiting national audience|Frame the debate nationally; NYC may appear as one example but should not be the primary frame|

Items 1, 2, and 5 directly affect audience reach. Items 3 and 4 affect the depth of inference the document delivers.

---

## 11. Common Failure Modes

|Failure Mode|Description|Correction|
|---|---|---|
|**Topic headline**|Headline announces subject, not finding|Rewrite to include numbers and direction|
|**Colon headline**|"Topic: Finding" structure|Merge into a single finding statement|
|**Procedure opening**|Finding block begins with "The figure shows..."|Open with the pattern the data reveal|
|**Parochial framing**|Context anchored to a specific city or region when the finding is national|Reframe to national debate; local examples appear subordinately|
|**Hedge-leading**|Opening with caveats before the finding|Move caveats to footer or finding block|
|**Missing uncertainty**|Numbers reported with no acknowledgment of estimation uncertainty|Add one plain-language uncertainty statement|
|**Thin implication**|Implication restates finding without developing meaning|Name who is affected and what the finding implies for them concretely|
|**Procedural context**|Context block uses "In this snapshot, we examine..."|Cut; replace with stakes language|
|**Jargon creep**|Technical terms undefined for lay readers|Define on first use or substitute plain equivalent|
|**Figure as decoration**|Chart present but not doing analytic work|Remove or restructure the finding around it|
|**Implication inflation**|Claiming policy relevance the data cannot support|Restrict to descriptive inference; flag as warranting further research|
|**Missing comparator**|Numbers reported without reference point|Add one anchor; remove any additional ones|
|**Underfilled page**|Left column ends early; page looks sparse|Increase `snapshot_feature_height` in small increments and re-render|
|**Wrong variable**|A raw `x`-variable that measures something narrower than its name implies|Check the codebook entry; prefer the summary-extract variable (§5.1)|
|**Unadjusted dollars**|Survey-year dollars compared across waves|Use the summary variables' 2022 dollars, or convert deliberately (§5.2)|
|**Typed numbers**|Estimates hand-entered into the prose or the chart's data frame|Build both from the estimate objects; inline R in the text (§5.5)|
|**Thin cells**|A group published on fewer than 25 unweighted observations|Fold it in, drop it, or mark it indicative (§5.3)|
|**Conditional mean alone**|"Average among holders" reported without the share holding|Report the incidence beside it (§5.7)|
|**Overstated change**|Change language firmer than the samples support|Match the verbs to the evidence and state the small-sample caveat (§7.5)|

---

## 12. Pre-Release Checklist

**YAML and setup**

- [ ] `title` states the finding; includes a number or comparison; active voice; no colon split
- [ ] `abstract` (deck) is 25–35 words; states finding and direction; stands alone without context
- [ ] `snapshot_feature` points to a figure export sized correctly for its aspect ratio (see §8.2)
- [ ] `snapshot_feature_caption` is complete: what is shown, source, sample definition, year(s), notes
- [ ] `snapshot_byline_*` fields all populated
- [ ] `snapshot_data_note` updated for this Snapshot's dataset (not left as placeholder)
- [ ] `snapshot_code_url` points to the replication repository

**Analysis**

- [ ] Concept measured with the summary-extract variable, or a raw `x`-variable justified against the codebook in a comment (§5.1)
- [ ] Dollar year stated in text and caption; no unadjusted comparison across waves (§5.2)
- [ ] Unweighted n computed for every published cell; none below 25 (§5.3)
- [ ] Category definitions verified comparable across the years compared (§5.4)
- [ ] No typed estimates: prose, chart data and caption all read from the estimate objects (§5.5)
- [ ] At least one aggregate checked against a published benchmark, named in a comment (§5.6)
- [ ] Conditional means reported with incidence; median checked for skewed variables (§5.7)

**Content**

- [ ] Lead paragraph answers in order: what happened, how large, who is affected, why it matters
- [ ] Context block: 2 paragraphs; sets stakes without methods language; no "In this snapshot, we examine..."; national or appropriately broad frame
- [ ] Finding block: opens with pattern, not procedure; 2–3 bold sub-headings; plain numbers with exactly one anchor
- [ ] Uncertainty acknowledged in plain language (no p-values, no CI notation, no "statistically significant")
- [ ] Implication block: conditional language; names who is affected; develops practical meaning; not a policy prescription
- [ ] Total body within ~450–530 words (§4)

**Production**

- [ ] `hflsnap::render_snapshot("your-file.Rmd")` completes without errors; PDF fills to the bottom of the page
- [ ] `<your-file>-wordpress.html` produced successfully
- [ ] Figure carries the HFL attribution footer via `hfl_watermark()`, placed after any complete theme (§8.3)
- [ ] Figure exported with `hfl_save_figure()`; both `fig.png` (bone) and `fig-web.png` (white) exist (§8.4)
- [ ] `snapshot_feature` points at the **bone** variant, not the web one
- [ ] White variant uploaded to WordPress as the post image
- [ ] Figure readable at 50% zoom
- [ ] Bold used structurally (sub-headings) plus maximum one emphasis bold per 100 body words
- [ ] No causal language unless research design warrants it
- [ ] No jargon without plain-language definition on first use

**Publication**

- [ ] Post created under Posts with the **Snapshots** category ticked (not a separate post type)
- [ ] Author account exists on the site and the post is attributed to its author
- [ ] Snapshot field panel complete: eyebrow, deck, stats, source caption, Report PDF, Source code URL, Figure image
- [ ] Featured image uploaded and set
- [ ] Tags added
- [ ] Submitted for editor review
- [ ] PDF deposited to CUNY Academic Works after publication

---

_Household Finance Lab | Queens College, CUNY_ _Style Guide Version 3.6 — September 2026_
