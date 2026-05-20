# Chapter: Scale — the unstated dimension
_Captured 2026-05-15. Working title confirmed by Kim:
"Scale: the unstated dimension." Chapter status confirmed._

## Status
Chapter ideation. The chapter was elevated from a thread in
`design_classification_to_mapping.md` (Thread 10) to a full
chapter after Kim recognized scale as the framework
underlying the project's prior nine threads. Chapter form
confirmed; this file replaces "would justify a
chapter_scale_ideas.md file" from the parent design file's
Thread 10 with the actual ideation.

## Placement
Strong candidate for Chapter 3 — between "What Is a Biome?"
(Ch 2 candidate) and the technical retrieval chapters. The
reader has the biome concept; the Scale chapter then gives
the lens through which biome was constructed and through
which the rest of the document operates. Every subsequent
chapter embeds scale choices, and naming scale here lets
those choices be intelligible rather than implicit.

Alternative placement: BEFORE "What Is a Biome?", so scale
is named first and biome is then introduced as a
scale-bounded answer. Either works; the
biome-then-scale order is more pedagogically forgiving
because readers have a concrete example before the abstract
framing. Decision deferred to drafting.

## The Seven Threads

### 1. Scale as the unstated dimension (the opening)
Scale is in every ecological observation, every study
design, every map, every diagram — but it is rarely
articulated. Researchers make scale choices reflexively
based on what they're trained to study and what data they
can obtain, and the choices are visible in the design
but rarely defended in the prose. Modern landscape ecology
and macroecology (Wiens 1989, Levin 1992) made scale
central as a theoretical concept, but the typical paper
still treats its scale of analysis as given. This thread
sets up the chapter's premise: scale deserves explicit
treatment, and the rest of the chapter will show why.

### 2. The three scales (spatial, temporal, organizational)
Any ecological observation operates simultaneously at:

- **Spatial scale.** Microhabitat (cm) → habitat patch
  (m–km) → landscape (10s–100s km) → region (100s–1000s
  km) → continent → global.
- **Temporal scale.** Instant (seconds) → diurnal →
  seasonal → interannual → decadal → centennial →
  millennial → geological.
- **Organizational scale.** Individual → population →
  community → ecosystem → landscape → biome → biosphere.

These are partly independent. A study at landscape spatial
scale can be at seasonal temporal scale and community
organizational scale; another can be at the same spatial
scale but at decadal temporal scale and at population
organizational scale. The three-axis frame is what makes
scale choices analyzable rather than monolithic.

### 3. Whittaker's scale choices (the concrete grounding)
The Whittaker diagram is operating simultaneously at three
specific scales:

- **Spatial: regional to global.** Cell averages at 2.5'
  (~5 km cells); the diagram itself is built for global
  applicability.
- **Temporal: long-term annual mean.** BIO1 and BIO12
  averaged over 1970–2000. Discards seasonality, droughts,
  fires, decadal climate variability.
- **Organizational: biome.** Community-level vegetation
  type; not species, not whole ecosystems.

The diagram works precisely because the chosen scale is
large enough to reveal climate-vegetation relationships
across continents and small enough to keep a world map
legible. It is not a defect that within-biome heterogeneity
is averaged out — that averaging IS the scale choice. The
diagram is the answer to "what does global vegetation look
like as a function of climate, at the scale where this
question is coherent?"

**Concrete worked demonstration (added 2026-05-16).** The
first run of `map_biomes()` on Oahu produced a finding
that operationalizes this chapter's whole prescription
in a single figure. At 2.5' resolution (~5 km cells),
Oahu's biome map averages across the windward-leeward
climate gradient and shows essentially one biome
classification for the island. At 30 arcsec resolution
(~1 km cells), subtropical desert assignments appear at
Kaena Point and the lee of the Waianae Range — climate
envelopes that meet Whittaker's subtropical desert
polygon are present on Oahu, and the finer scale lets
them appear distinctly rather than averaging into wetter
neighbors.

The two outputs of the same data classification differ
not because the underlying climate differs but because
the *scale choice* differs. At one resolution Hawaii has
deserts; at another it doesn't. The chapter's central
prescription (name your scale, defend your scale, know
what your scale obscures) gets its strongest possible
case study: the same place, the same classifier, two
resolutions, two different ecological pictures. See
`background/chapter_mapping_ideas.md` "First worked
result" section.

### 4. The taxonomy parallel (Kim's contribution)
Taxonomists work with an explicit hierarchy of ranks —
domain, kingdom, phylum, class, order, family, genus,
species, with infraspecific subdivisions below. Choosing
which rank to operate at is a deliberate methodological
act, articulated in taxonomic vocabulary, defended in
papers. A taxonomist who works "at the family level" is
making a scale choice explicit in their language.

Ecologists make equally consequential scale choices but
rarely with the same explicit vocabulary. The chapter's
prescription: borrow the discipline of the taxonomic ranks
without copying their specific terms. Make scale explicit
the way taxonomy makes rank explicit.

### 5. Scale vocabulary — cartographic vs ecological (Kim's contribution)
Formal cartographic scale notation (1:10,000, 1:1,000,000)
is rigorous but not intuitive. Most readers can't translate
a ratio into a felt sense of "how big is the area I'm
looking at." Ecological vocabulary serves better because
the words already carry intuitive content. "Biome" is
intuitively continental; "ecosystem" is intuitively a
localized functional whole; "habitat" is intuitively where
one species lives; "community" is intuitively a set of
species sharing a place.

Proposed sidebar table for the chapter:

| Cartographic scale | Ecological term | What is visible |
|---|---|---|
| 1:10,000,000+ | Biome | Climate-vegetation patterns; continental distributions |
| 1:1,000,000 | Region / Ecoregion | Multi-biome mosaics; large climate gradients |
| 1:100,000 | Landscape | Habitat patches; mosaics; meta-communities |
| 1:10,000 | Ecosystem | Community + abiotic processes; energy and nutrient flow |
| 1:1,000 | Community | Species composition; co-occurrence |
| 1:100 | Population | Individual organisms; density |
| 1:10 | Microhabitat | Within-individual conditions; sub-organism processes |

(Ratios are illustrative, not strict.) The chapter's point
is that ecological vocabulary handles the same job as
cartographic scale ratios but with better intuitive uptake.
For an ecology document, ecological terms are the right
choice.

### 6. Researchers and scale awareness — the Goodall example
David Goodall is the chapter's biographical case study,
and the example carries unusual weight because Goodall
was **Kim's PhD advisor** (revealed 2026-05-15) in addition
to being Director of the US/IBP Desert Biome program where
Kim served as Asst. Director. The advisor relationship
preceded and contextualized the program relationship —
Goodall trained Kim, and then they worked together on a
major NSF undertaking. The intellectual descent is formal
and direct.

Goodall (1914–2018) was an Australian-born plant
ecologist, pioneer of statistical methods in vegetation
analysis, and prolific into his second century. After
running the Desert Biome program — explicitly a
biome-scale undertaking — Goodall moved his research
focus to ecosystem-scale work.

Kim's framing: "the scale to where David Goodall migrated
after running the Desert Biome." This is a real career-arc
about scale awareness developing through practice. A
researcher who has run a biome-scale program has felt the
limits of what biome-scale delivers — the way large-scale
averaging obscures within-biome variation, the way long
temporal averaging discards dynamics, the way
community-level work misses the abiotic processes that
ecosystem-scale work foregrounds. The migration to
ecosystem-scale isn't abandonment of biome-scale work;
it's an explicit scale choice made by a researcher who
now knows the tradeoffs from inside.

**The PhD-advisor fact changes how Kim's witness reads in
the chapter.** Not "I worked under a researcher who
migrated across scales" but "I watched my dissertation
advisor recalibrate across scales over time." The chapter
can quote Kim explicitly: "David Goodall, my PhD advisor,
migrated from biome-scale to ecosystem-scale work after
running the Desert Biome." That's the kind of first-person
grounding that gives the chapter its weight — the student
observing the teacher's intellectual evolution. Worth
preserving that framing in the eventual prose rather than
flattening it into a program-collaborator description.

### 7. Making scale explicit — the closing prescription
The chapter closes on the practical prescription: name your
scale. State the spatial extent and resolution of your
work, the temporal aggregation, the organizational level.
Borrow the taxonomic discipline without the taxonomic
vocabulary; use the ecological vocabulary that already
exists; treat scale as a first-class methodological
decision, not an inherited default.

For readers of the whittakerr document, the prescription
applies directly. Every chapter that follows embeds scale
choices: the climate retrieval at 2.5' or 30" (spatial
data scale); the annual-mean climate values (temporal
scale); the biome categorization (organizational scale);
the mapping decisions at world vs region (display scale).
Making the choices visible in this chapter lets the rest
of the document be intelligible as a coherent
scale-bounded enterprise rather than a series of arbitrary
technical choices.

## Key formulations to preserve verbatim

Kim's chapter-elevation moment:
> "I'd not seen the parallels to taxonomy until just now.
> It makes a lot of sense. This certainly elevates scale
> to the level of a chapter and your title, 'Scale: the
> unstated dimension' is perfect."

Kim's scale-vocabulary observation:
> "Map scale names (e.g., 1:1000) isn't very intuitive.
> Biome and ecosystem are, perhaps, the useful terms that
> people understand."

Kim's Goodall reference:
> "The scale to where David Goodall migrated after running
> the Desert Biome."

Kim's chapter-purpose framing:
> "A researcher needs to be aware of the scale at which
> they are working."

## Provisional structure

- **Opening (Thread 1)** — Scale as the unstated dimension.
  The chapter's premise.
- **Middle**
  - **Threads 2 + 3** — The three scales, and how
    Whittaker's diagram makes specific choices on each.
  - **Thread 4** — The taxonomy parallel; how taxonomists
    name their level and what that discipline offers.
  - **Thread 5** — Scale vocabulary. Cartographic vs
    ecological; the sidebar table; ecological terms as
    the right choice for ecological work.
  - **Thread 6** — Researchers and scale awareness. David
    Goodall's career arc as the worked example; Kim's
    witness as the grounding.
- **Closing (Thread 7)** — Making scale explicit. The
  prescription. Forward-looking: each subsequent chapter
  embeds scale choices that the reader can now see.

## Open questions

- Placement: after What Is a Biome? (current preference)
  or before it (alternative)?
- The sidebar table's cartographic ratios are
  illustrative; should they be tightened (using actual
  USGS / standard map series) or kept loose to focus on
  the ecological-vocabulary point?
- Should the chapter include a "scale-of-the-whittakerr-
  toolkit" explicit declaration (a paragraph stating
  exactly the spatial / temporal / organizational scale
  the toolkit operates at, as a worked example of the
  prescription)?
- How much of Goodall's biography to include? A paragraph?
  A sidebar? The full career arc?
- Does this chapter eventually replace the design file's
  Thread 10 entirely, or is the Thread 10 entry retained
  as the design-level summary that the chapter then
  expands?
- Could the chapter end with a small exercise — "name the
  scale at which you are working" — addressed to the
  reader as practitioner?

## Next session — drafting checklist

1. Re-read this file plus design_classification_to_mapping.md
   Thread 10.
2. Decide chapter placement (after vs before "What Is a
   Biome?").
3. Confirm sidebar table contents.
4. Draft section by section, preserving Kim's verbatim
   formulations and the Goodall biographical grounding.
5. Cross-reference forward to each subsequent chapter's
   scale choices.
6. Consider whether to include the
   "scale-of-the-whittakerr-toolkit" explicit declaration
   as the chapter's closing example.

Estimated length when drafted: ~1,800–2,500 words plus
the cartographic-vs-ecological vocabulary table plus the
Goodall biographical paragraph or sidebar.
