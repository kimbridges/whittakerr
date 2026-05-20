# Sources and Attribution for Bundled Data

The whittakerr package ships with two bundled datasets:

- `Whittaker_biomes` — a data frame of polygon vertices defining the nine biomes in Whittaker's diagram (775 rows, 4 columns: temp_c, precp_cm, biome_id, biome).
- `Ricklefs_colors` — a named character vector of hex color values, one per biome, defining the categorical palette used in Ricklefs's textbook figure.

Both datasets are vendored from the `plotbiomes` R package by Valentin Ștefan and Sam Levin. The original digitization traces back to Figure 5.5 in Ricklefs's *The Economy of Nature*.

## Citations

Two sources must be cited whenever this package's bundled data is used in documentation or publication:

### plotbiomes (immediate source)

> Ștefan, V. & Levin, S. (2018). plotbiomes: R package for plotting Whittaker biomes with ggplot2. v1.0.0. Zenodo. https://doi.org/10.5281/zenodo.7145245

Repository: https://github.com/valentinitnelav/plotbiomes

The `Whittaker_biomes` data frame and the `Ricklefs_colors` named vector in this package are direct vendoring of the .rda objects of the same name in plotbiomes, downloaded from the plotbiomes GitHub repository (master branch).

### Ricklefs 2008 (underlying scientific source)

> Ricklefs, R. E. (2008). *The Economy of Nature* (6th ed.). W. H. Freeman and Company.

The biome diagram and its categorical structure originate in Ricklefs's textbook, Chapter 5 ("Biological Communities, The biome concept"), Figure 5.5. Whittaker's original diagram is the deeper source; Ricklefs's textbook presentation is the rendering that plotbiomes digitized and that this package now ships.

## Digitization protocol

Per the plotbiomes documentation:

- The biome polygon vertices were digitized by hand from a high-resolution scan of Figure 5.5 in Ricklefs (2008).
- The color values were extracted from the PostScript export of the same figure.
- The biome names match Ricklefs's labels.

The whittakerr package does NOT re-digitize. It bundles the plotbiomes outputs as project-local CSVs (in `data-raw/`) and as R objects (in `data/`).

## Attribution commitment

Any documentation, publication, or derivative work that uses `Whittaker_biomes` or `Ricklefs_colors` should cite BOTH plotbiomes (the immediate source) AND Ricklefs 2008 (the underlying scientific source). The plotbiomes citation gives proper credit for the digitization labor; the Ricklefs citation gives proper credit for the scientific work that the digitization represents.

The whittakerr Quarto Document follows this commitment in its References appendix.

## Update protocol

If plotbiomes releases an updated version of the Whittaker_biomes or Ricklefs_colors data, the whittakerr package should re-run `data-raw/build_biome_data.R` to pull the new versions and rebuild the package data. The script downloads from the plotbiomes GitHub master branch, so it always pulls the current version on rerun.

Reruns are idempotent: the script overwrites `data-raw/whittaker_biomes.csv`, `data-raw/ricklefs_colors.csv`, `data/Whittaker_biomes.rda`, and `data/Ricklefs_colors.rda` each time.
