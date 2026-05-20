# Chapter: What Is a Biome? — Ideation Notes
_Captured 2026-05-13. Working title; final title to be set when drafting begins._

## Status
Ideation complete. Structural outline and prose drafting deferred to a future
session. The five threads below are the substantive backbone; the key
formulations Kim flagged are preserved verbatim so they don't decay between
sessions.

## Placement
Chapter 2 — between History (Ch 1, drafted) and Getting Started. History
tells how the concept evolved; this chapter crystallizes what the concept now
is, before the technical chapters begin. Renumbering of the existing Chapter
Status table in proj_whittakerr.md deferred until placement is confirmed.

## The Five Threads (in development order)

### 1. Categories as priors (epistemic function)
A category licenses inference. Knowing the biome category gives a prior
distribution over secondary variables — vegetation height, dominant growth
forms, NPP, leaf area index, fire regime, species composition. The Bayesian
framing is more rigorous than metaphorical: the two climate axes feed the
category, and the category in turn underwrites useful claims about everything
else. This is the implicit promise of `name_biome()` in the tool — a point in
T×P space becomes an interpretable ecological unit.

### 2. Categories as compression (the right grain)
Whittaker's roughly nine biomes is a compression choice, not a discovery. Too
few categories and the scheme does no inferential work; too many and the
structure is as fragmented as the raw data. This is the bias-variance
tradeoff applied to classification, the same intuition behind Rosch's
basic-level categories and minimum description length. Categories pay for
themselves only at the right grain.

**Display-constraint extension (added 2026-05-13).** The right grain has a
further constraint that wasn't in the original discussion: the resolution of
the map on which the categories are to be displayed. Too many categories and
the visual encoding fails — a world map at standard page size can support
roughly ten distinguishable fills, not thirty. The Whittaker diagram and the
Whittaker map therefore co-constrain each other: category count must satisfy
both statistical / cognitive criteria and the visual-display criterion of
the intended map. See `design_classification_to_mapping.md` Thread 1 for the
full elaboration. This may become a named fifth thread in the final chapter,
or fold into this thread as a kind of compression specifically driven by
display.

### 3. Categories tied to descriptor space
Granularity is tied to dimensionality, not just to a Goldilocks number. With
only T and P, Whittaker's nine-ish buckets are about as many as the two axes
can support without becoming arbitrary. A three-axis system (seasonality,
soil, fire return interval) would support more categories without
overwhelming, because each would do more inferential work. This previews why
later chapters reach beyond the diagram.

### 4. Function over identity (the spine)
The load-bearing choice. Whittaker classified by vegetation structure — life
forms — rather than by taxonomy or floristic composition. This makes
convergent evolution visible. The Amazon, Congo, and Borneo share almost no
species but are unmistakably the same biome. Taxonomic or floristic
classifiers (Braun-Blanquet and the European phytosociological tradition)
would treat them as three radically different places; only a life-form
classifier sees them as one thing — and that one thing is what climate has
selected for. Raunkiaer's 1934 life-form scheme (phanerophytes through
therophytes, classified by perennating bud position) is the deeper ancestor.
Functional ecology and plant functional types in modern DGVMs are the
contemporary descendants. The whole shift in ecology toward
function-over-identity is foreshadowed here.

### 5. Why these axes — ecology, intuition, lived experience
Ecology's working definition — organisms in relation to their environment —
is what the Whittaker diagram renders as a two-dimensional plot. T and P axes
are the environment; biome labels are the organism response. (Kim flagged
this as the essence-of-ecology statement.) In the late 1940s and 1950s,
ecology was consolidating itself against older traditions of plant geography
and natural history; producing a unified diagram that made the
climate-vegetation relationship legible at a glance was a major act of
disciplinary self-definition.

The choice of T and P specifically is also why the diagram endures
pedagogically. These are the two environmental variables every human has
direct sensory experience of — we have no intuition for NPP or LAI, but
everyone knows cold and warm, wet and dry. Kim's example: a Northwest
resident saying "I'm comfortable here because it's wet and has nice seasons"
is locating themselves on a Whittaker diagram without knowing it. The
categories aren't abstract because the axes aren't abstract. This is also
why the diagram is such a successful teaching tool: a non-ecologist can place
themselves on it and immediately see why their environment looks the way it
does.

### Closing note — the gradient ecologist who drew categories
Whittaker's earlier Smoky Mountains work championed continuous gradients
against Clements's discrete community types. The biome diagram is in tension
with that — categorical biomes are a pragmatic compression of a fundamentally
continuous response surface, drawn by someone who knew exactly what he was
simplifying. That self-aware compression closes the loop back to threads 1
and 2: categories are useful fictions; that doesn't make them less valuable,
but it does mean they earn their keep by what they let us infer.

## Key formulations to preserve verbatim

Kim's essence-of-ecology sentence (the chapter's spine):
> "The Whittaker diagram renders [ecology] as a two-dimensional plot.
> T and P axes are the environment; biome labels are the organism response."

Gemini quotes Kim flagged as seeds:
> "Without the category, a data point — like a specific vegetation height or
> a rainfall millimeter — is just an isolated number in a vacuum. The category
> provides the 'prior' in a Bayesian sense, giving us the necessary context
> to interpret what that number actually means for the ecosystem as a whole."

> "Categories are the light that allows us to see structure in the darkness.
> Whittaker's struggle was essentially an attempt to find the most efficient
> 'labels' to illuminate that void without over-complicating the picture. He
> knew that if he created too many categories, the 'context' would become as
> fragmented and overwhelming as the raw data itself."

Note on voice: Gemini's prose runs literary. The chapter should state the
rigorous version first and use the lyrical register sparingly as punctuation,
not as the primary mode.

## Provisional structure
- **Opening** — ecology as organisms-in-environment; the biome diagram as the
  discipline's foundational claim rendered visual.
- **Middle** — the four conceptual threads in order: priors → compression →
  descriptor space → function-over-identity (the spine).
- **Closing turn** — why the axes are intuitive (people relate to T and P);
  the gradient-ecologist-who-drew-categories acknowledgement; categories as
  useful fictions earned by what they let us infer.

## Open questions for the drafting session
- Final title. "What Is a Biome?" is the working title; alternatives ("Why
  Biomes," "The Idea of a Biome," "Reading the Diagram") to be considered.
- How much to develop the real-vs-useful-fiction question — a paragraph or a
  full section?
- Whether to include a Hawaii example (elevational biome stacking — multiple
  biomes within short distances on a single island) as a Kim-specific anchor.
- Cross-references to History (Ch 1) for the "Classification as Art" and
  "Product versus Process" threads, which now have somewhere to land rather
  than ending where History leaves them.

## Next session — resumption checklist
1. Re-read this file.
2. Re-read the History chapter (Ch 1) to align voice and cross-references.
3. Decide the final title.
4. Draft section by section, preserving the key formulations verbatim.
5. After drafting, update proj_whittakerr.md Chapter Status table to insert
   the new chapter at position 2 and renumber the rest.

Target length when drafted: ~1,500–2,500 words.
