## 1. Overview

The _Household Finance Lab_ (HFL) is a public research enterprise whose goal is

- To publish high-quality, objective estimates of household finance facts, so as to push public discussion and policy debate towards views that concord with empirics.
- To produce meaningful academic research related to household finance that pushes social science discussions towards empirical fidelity
- To provide Queens College students with hands-on real world experiences to learn and practice analysis, research enterprise management, and mass communications by creating and operating a real public interest research organization.

_**The Snapshot Series.**_ The _Empirical Snapshot_ is the HFL's primary public-facing publication. Each installment presents a single, clearly bounded empirical finding from the data, written for an educated non-specialist reader.

**Governing format constraint:** Submissions should fill and be confined to the model presented in this [[0722_99netw.pdf|example of PDF report]]. The HTML version on the site will present [as presented here](https://hhfinance.commons.gc.cuny.edu/2026/07/12/wealth-after-the-crisis-one-percent-vs-median/).

**Before using Snapshot 001 as a template, read §9.** It has five specific content deviations from this guide's rules — copy its layout, not those five choices.

---

## 2. Reader Model

Your reader is an educated non-specialist: a journalist, policy staffer, foundation program officer, or academically literate layperson. Write for high intelligence and sophistication. Avoid jargon. Define any technical term on first use or substitute a plain equivalent.

---

## 3. Page Layout

The snapshot uses a **two-column layout** within a one-page format:

- **Full-width header zone:** Publication badge flush left + date flush right; headline below spanning full width; author name and institution below headline.
- **Left column (text):** All prose components in sequence — deck, lead paragraph, Context, Findings, Implication, About the Author.
- **Right column (figure):** One chart or visualization. The figure zone may begin as high as the lead paragraph and run through the footer — it is not required to start at the Findings section. Size it to fill the column without crowding the author box or footer.
- **Full-width footer:** License (CC BY-NC-SA 4.0) flush left; dataset name and reference page link flush right; rule above.

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

Context's target was widened from an earlier draft (100–130) to match what actually holds a page: Snapshot 001's Context runs ~162 words and the page fits fine. The total-body ceiling is the binding constraint — hold Context, Findings, and Implication to it in combination, not each in isolation. `snapshot-template.Rmd`'s inline word-count comments match this table (as of the `hflsnap` 0.1.0 template) — if you copied a `.Rmd` from an older project, check its comments still say 130–165 / 150–175 / 75–100 before trusting them.

The sequence is fixed. It follows the **inverted pyramid** (journalism) and **progressive disclosure** (instructional design): lead with the finding, then provide the stakes, then the evidence, then the inference. Do not reorder.

---

## 5. Production Workflow

### 5.1 How the System Works

Snapshots are written in **R Markdown** and rendered with a standalone LaTeX template. Everything the layout needs is a set of plain files, not an installed dependency graph:

|Item|Purpose|
|---|---|
|`snapshots.tex`|The one-page LaTeX template (Pandoc → XeLaTeX). Do not edit.|
|`fonts/`|Bundled fonts: Bricolage Grotesque, Archivo, Spline Sans Mono.|
|`default.csl`|Citation style, if the snapshot cites sources.|
|`snapshot-template.Rmd`|Starter file with the full annotated YAML header.|

A LaTeX template can only produce a PDF, so the WordPress companion HTML is a second Pandoc pass over the already-knitted Markdown (`<file>.knit.md`), not a separate output flag.

**Getting these files into a new project — two options:**

- **Recommended: the `hflsnap` package.** Install it once (§5.2), then run `hflsnap::hfl_use()` in any new project folder to copy `snapshots.tex`, `fonts/`, `default.csl`, and a starter `snapshot.Rmd` into place, and use `hflsnap::render_snapshot("snapshot.Rmd")` to knit both outputs in one call.
- **Manual.** Copy the same four items by hand from an existing snapshot project (§5.3) and `source("render-snapshot.R")` to render.

Either way, the resulting `.Rmd` is a plain `rmarkdown::pdf_document` — `hflsnap` does not define a custom output format. A collaborator who receives your project folder can knit it with plain rmarkdown, without `hflsnap` installed, as long as the copied support files travel with it.

**A note on `hfwgtex`.** An earlier version of this pipeline used a now-retired package by that name (installed via `devtools::install_github`, with a `hfwgtex::snapshot_pdf` output format that emitted `wordpress: html` directly as part of the knit). `hflsnap` is a different, current package — it ships files and a thin rendering wrapper, not a custom output format. If you find guidance elsewhere referencing `hfwgtex`, `hfwg_use()`, or `wordpress:` YAML flags, it describes the old system. Ignore it.

### 5.2 One-Time Setup

`hflsnap` lives in the `hflsnap/` subdirectory of this repo (`github.com/jncohen/empirical-snapshots`), not as its own repo. Install it from there:

```r
install.packages("devtools")     # if not already installed
devtools::install_github("jncohen/empirical-snapshots", subdir = "hflsnap")
```

**Updating.** Re-running the same `install_github()` call always pulls whatever is on `main` — there's no version to bump on your end. If you want to pin to a specific commit or tag (e.g. after a breaking change to `hfl_use()`), install with `ref = "<commit-sha-or-tag>"` instead.

**Offline / no GitHub access:** install from the tarball checked into the repo root instead:

```r
devtools::install_local("hflsnap_0.1.0.tar.gz")
```

This is a point-in-time snapshot of the package, not a substitute for pulling from GitHub — it won't include changes made after that tarball was committed.

You also need:
- **Pandoc**, bundled with RStudio.
- **A TeX distribution.** If you don't have one:
    ```r
    install.packages("tinytex")
    tinytex::install_tinytex()
    ```
    TinyTeX is recommended — it auto-downloads any missing LaTeX packages on first compile.

### 5.3 Project Setup

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

### 5.4 The Snapshot YAML Header

Below is the annotated header, matched to the fields `snapshot-template.Rmd` and `snapshots.tex` actually read:

```yaml
---
# ── DOCUMENT IDENTITY ──────────────────────────────────────────────
title: "Finding headline here — include a number and direction"
  # 10–14 words; states the finding, not the topic (see §6.1)
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
  # renders at ~95% width. Match the chart background to the sheet
  # color (#EFEDE6) so it doesn't read as a white panel. Let this
  # caption field do the labelling — drop title/subtitle/caption from
  # the ggplot itself, or they duplicate the caption beneath the plate.

# ── ABOUT THE AUTHOR ────────────────────────────────────────────────
snapshot_byline_name: "Your Full Name"
snapshot_byline_title: "Research Associate, HFL"
snapshot_byline_link: "hhfinance.commons.gc.cuny.edu"
# snapshot_byline_affiliation: "Queens College, City Univ. of New York"
# snapshot_byline_bio: "One sentence describing your research focus."
# snapshot_author_image: "images/author.png"   # else a monogram disc is drawn

# ── FOOTER / PROVENANCE ─────────────────────────────────────────────
snapshot_switch_section: 3
  # The body section (1-indexed: Context=1, Finding=2, Implication=3)
  # at which the left column switches to run under the figure. Keep
  # three sections, or move this if you change the structure.
snapshot_license: "cc-by-nc-sa-4.0"
  # Other options: cc-by-4.0, cc0-1.0, all-rights-reserved
snapshot_data_note: "Data: Survey of Consumer Finances <hhfinance.commons.gc.cuny.edu/scf>"
snapshot_code_url: "github.com/jncohen/your-repo-name"

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
    keep_tex: false
    keep_md: true        # required: .knit.md feeds the WordPress companion
---
```

After the closing `---`, write the Snapshot body in standard R Markdown. Anything before the first `#` heading becomes the lead paragraph. Use `# Context`, `# Finding`, `# Implication` as section headings, and `**bold text**` for Finding block sub-headings.

### 5.5 Rendering

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

The HTML is deliberately body-only (no `<head>`, no CSS) — WordPress's synced pattern supplies the styling. There is no separate checklist file; follow the publishing steps in §5.6 directly.

On the first render, TinyTeX may auto-download missing LaTeX packages — this takes a minute once, then packages are cached.

**Page fitting.** After the first render, inspect the PDF. If the left column ends early or the page feels underfilled, increase `snapshot_feature_height` in small increments and re-render. If the author box or footer looks crowded, reduce it. The goal is a full, balanced one-page layout. Do not use the height field to compensate for a chart with excessive internal whitespace — redesign the chart first. Do not add `\LaTeX` commands to override spacing, margins, or fonts in `snapshots.tex`.

### 5.6 Publishing to the HFL WordPress Site

The HFL WordPress site is at `hhfinance.commons.gc.cuny.edu` on CUNY Academic Commons. As a Contributor, you can create and submit Snapshot posts for review; a site editor publishes them.

**Step-by-step:**

1. **Log in** at `hhfinance.commons.gc.cuny.edu/wp-admin` using your CUNY Academic Commons credentials.
2. **Create a new Snapshot post.** In the left sidebar, go to **Snapshots → Add New** (not Posts — Snapshots are a separate content type on this site).
3. **Enter the headline** in the Title field. This is the finding headline from your YAML `title` field.
4. **Paste the companion HTML.** Open `your-file-wordpress.html` in a text editor. In the WordPress editor, switch to the **Text** (HTML) tab — not the Visual tab — and paste the full contents. Switch back to Visual to verify the layout rendered correctly.
5. **Upload the figure** as a media item (**Media → Add New**) if it is not already in the site's media library. Then set it as the **Featured Image** in the right sidebar of the post editor.
6. **Add metadata.** Set the appropriate category (e.g., "Wealth," "Debt," "Income") and any relevant tags.
7. **Submit for review.** Click **Submit for Review** (not Publish — Contributors cannot publish directly). The site editor will review and publish the post.

There is no auto-generated checklist file to walk through this — this section is the checklist. Keep it open during your first upload.

---

## 6. Component Specifications

### 6.1 Headline

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

### 6.2 Deck

The deck is the YAML `abstract` field. It renders as a **bolded 1–2 sentence statement** at the top of the left column, above the lead paragraph. A reader who sees only the deck should know the direction and magnitude of the finding.

The deck is not the lead paragraph. It is shorter, typographically bolder, and written to stand alone if stripped of all context. No hedges, no footnotes, no methods language.

**Strong deck example** (from Snapshot 001): _"Both the median and 99th percentile lost wealth after the 2008 crisis. Both recovered, but the 99th percentile recovered faster."_ This works because it states a complete finding in two sentences with no wasted words.

### 6.3 Lead Paragraph

The lead paragraph is the first paragraph of the `.Rmd` body (before any section heading). It answers four questions **in this order**: _What happened? How large is it? Who is affected? Why does it matter?_

The lead must contain the key quantitative values. Do not open with context, methodology, caveats, or literature review. Opening with caveats signals low confidence and trains readers to discount findings before they have seen them.

The lead is the primary unit readers share or quote. Write it so it stands alone without the rest of the document.

### 6.4 Context Block

Marked with a `# Context` heading in the `.Rmd`. Two paragraphs that explain why this finding matters to someone outside academia.

**What to include:**

- A real-world debate or public concern where this finding is directly germane
- Stakes: what turns on knowing this fact
- If relevant, a brief reference to prior literature or public discourse that establishes why the question exists

**What to exclude:**

- Dataset descriptions. Methods belong in the footer and the HFL dataset reference pages.
- Procedural framing: "In this snapshot, we examine..." states what you are doing, not why it matters. Cut it.
- Parochial framing: if the finding is national in scope, frame it nationally. A local example may appear as one illustration, not as the primary context.

### 6.5 Finding Block

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

**Sub-heading format:** The sub-heading states the sub-finding, not a topic. "Top-End Wealth Recovered Faster" is a finding. "Comparing Groups" is a topic.

### 6.6 Implication Block

Marked with a `# Implication` heading. One paragraph (75–100 words) stating what the finding suggests practitioners, policymakers, or researchers should consider. Use conditional language: "suggests," "may warrant," "raises questions about."

Do not overreach. Restrict to what the data can support.

|✗ Overreach|✓ Implication|
|---|---|
|"This proves systemic bias in the financial system."|"The timing gap raises questions about whether recovery-period programs reached median-wealth households as effectively as high-wealth households."|
|"We need legislation to address this immediately."|"Households whose retirement security depends on home equity or liquid savings may have faced greater long-run consequences from delayed recovery than top-end wealth data alone suggest."|

**A strong implication block does two things:** it states the conditional inference, and it **names who is concretely affected and how**. Restating the finding in slightly different words is not an implication.

### 6.7 About the Author

Controlled by the `snapshot_byline_*` YAML fields — not written in the body. Required; not optional. Renders at the bottom of the left column, above the footer rule.

The About the Author block is part of HFL's brand-building function. It converts a public-facing document into a credentialing artifact for the contributing researcher.

### 6.8 Footer

Controlled by `snapshot_license` and `snapshot_data_note` YAML fields. Rendered automatically. Update `snapshot_data_note` for whichever dataset this Snapshot uses — do not leave it as the default placeholder.

---

## 7. Figure Design

### 7.1 Placement and Sizing

One figure per snapshot. The figure is specified in the `snapshot_feature` YAML field; it does not appear in the body text. `snapshots.tex` places it in the right column, and it may start as high as the top of the column (see §3).

`snapshot_feature_height` controls the height of the figure zone (default `"4.3in"`). After the first render, adjust it to fill the page — lower it if the sheet spills, raise it if the page looks underfilled. Treat this as a normal production step, not an error condition.

### 7.2 Core Design Principles

- **Finding title, not topic title.** The figure title states the finding. "Top-End Wealth Recovered Faster After the Financial Crisis" ✓. "Net Worth by Percentile, 2007–2022" ✗.
- **Data-ink ratio.** Remove gridlines unless necessary for reading values; remove background colors; label data directly on the chart rather than using a legend wherever possible.
- **Match the sheet background.** Set `theme(plot.background = element_rect(fill = "#EFEDE6", colour = NA))` so the figure doesn't read as a white panel dropped onto the page.
- **Aspect ratio.** Landscape figures (~3:2) fill the column best; a 3:4 portrait renders at ~95% width. Design for whichever orientation the data calls for — do not force a landscape chart into a portrait canvas or vice versa.
- **Readable at 50% zoom.** All labels and axis text must remain legible at half size, simulating how the figure appears embedded in a blog post.
- **Caption.** Every figure carries a complete caption in `snapshot_feature_caption` including: (1) what is shown, (2) data source, (3) sample definition, (4) year(s), (5) relevant notes. Let the caption do the labelling — drop title/subtitle/caption text from the ggplot itself, or they duplicate the caption beneath the plate.

---

## 8. Typography and Layout

Typography is controlled by `snapshots.tex` and should not be changed for Snapshots. The following describes the output for reference:

- **Typeface:** Bricolage Grotesque for display, Archivo for body/UI text, Spline Sans Mono for labels
- **Body size:** tight single spacing; compact blog masthead styling
- **Column layout:** two columns
- **Section headers:** rendered automatically from `#` headings in the body
- **Bold emphasis:** reserved for the deck (automatic) and Finding block sub-headings; use sparingly elsewhere — at most one emphasis phrase per 100 words of body text

Do not add `\LaTeX` commands to override spacing, margins, or fonts. If the page does not fill correctly, adjust `snapshot_feature_height` or edit the prose length.

---

## 9. Known Deviations in Snapshot 001

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

## 10. Common Failure Modes

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

---

## 11. Pre-Release Checklist

**YAML and setup**

- [ ] `title` states the finding; includes a number or comparison; active voice; no colon split
- [ ] `abstract` (deck) is 25–35 words; states finding and direction; stands alone without context
- [ ] `snapshot_feature` points to a figure export sized correctly for its aspect ratio (see §7.2)
- [ ] `snapshot_feature_caption` is complete: what is shown, source, sample definition, year(s), notes
- [ ] `snapshot_byline_*` fields all populated
- [ ] `snapshot_data_note` updated for this Snapshot's dataset (not left as placeholder)
- [ ] `snapshot_code_url` points to the replication repository

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
- [ ] Figure readable at 50% zoom
- [ ] Bold used structurally (sub-headings) plus maximum one emphasis bold per 100 body words
- [ ] No causal language unless research design warrants it
- [ ] No jargon without plain-language definition on first use

**Publication**

- [ ] Post submitted to WordPress as Snapshot post type (not regular post)
- [ ] Featured image uploaded and set
- [ ] Post categories and tags added
- [ ] Submitted for editor review
- [ ] PDF deposited to CUNY Academic Works after publication

---

_Household Finance Lab | Queens College, CUNY_ _Style Guide Version 3.3 — July 2026_
