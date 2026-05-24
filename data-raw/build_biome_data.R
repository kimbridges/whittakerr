## ============================================================
## data-raw/build_biome_data.R
##
## Maintainer script. Builds the whittakerr package's bundled
## data from upstream source (the plotbiomes R package by
## Stefan & Levin 2018, which itself digitized from Ricklefs
## 2008, The Economy of Nature, Figure 5.5).
##
## Runs the full cycle:
##   1. Download the upstream .rda files from plotbiomes on
##      GitHub.
##   2. Write project-local CSVs to
##      data-raw/whittaker_biomes.csv and
##      data-raw/ricklefs_colors.csv. These are the
##      human-readable source-of-truth, retained for
##      maintainer reference and diffing against upstream.
##   3. Read the CSVs back as canonical R objects.
##   4. Save as package data via usethis::use_data(), which
##      writes data/Whittaker_biomes.rda and
##      data/Ricklefs_colors.rda. These are the .rda files
##      the installed package ships.
##
## After running, the package data is current. Both
## representations (CSVs and .rda) point to the same upstream
## numbers and are kept in sync by this one script.
##
## ATTRIBUTION (see data/SOURCES.md for the full block):
##
##   Stefan, V. & Levin, S. (2018). plotbiomes: R package for
##   plotting Whittaker biomes with ggplot2. v1.0.0. Zenodo.
##   https://doi.org/10.5281/zenodo.7145245
##
##   Ricklefs, R. E. (2008). The Economy of Nature, 6th ed.
##   W. H. Freeman and Company.
##
## Usage (from R, working directory = package root):
##
##   source("data-raw/build_biome_data.R")
##
## Reruns are idempotent.
##
## ============================================================

## Output paths for the CSV source-of-truth. These live in
## data-raw/ alongside this script. The .rda files for the
## installed package go to data/ via usethis::use_data() below.
bio_csv <- "data-raw/whittaker_biomes.csv"
col_csv <- "data-raw/ricklefs_colors.csv"

## Ensure data-raw/ exists.
dir.create("data-raw", showWarnings = FALSE, recursive = TRUE)

## Source .rda URLs on GitHub (master branch).
url_bio <- paste0("https://github.com/valentinitnelav/",
                  "plotbiomes/raw/master/data/Whittaker_biomes.rda")
url_col <- paste0("https://github.com/valentinitnelav/",
                  "plotbiomes/raw/master/data/Ricklefs_colors.rda")

## Download to temp paths.
rda_bio <- tempfile(fileext = ".rda")
rda_col <- tempfile(fileext = ".rda")

cat("Downloading Whittaker_biomes.rda from plotbiomes ...\n")
utils::download.file(url_bio, destfile = rda_bio, mode = "wb", quiet = TRUE)

cat("Downloading Ricklefs_colors.rda from plotbiomes ...\n")
utils::download.file(url_col, destfile = rda_col, mode = "wb", quiet = TRUE)

## Load into temporary environments.
env_bio <- new.env()
env_col <- new.env()
load(rda_bio, envir = env_bio)
load(rda_col, envir = env_col)

Whittaker_biomes <- env_bio$Whittaker_biomes
Ricklefs_colors  <- env_col$Ricklefs_colors

## Sanity check.
cat("\n--- Sanity check ---\n")
cat("Whittaker_biomes dimensions: ",
    paste(dim(Whittaker_biomes), collapse = " x "), "\n")
cat("Whittaker_biomes columns:    ",
    paste(names(Whittaker_biomes), collapse = ", "), "\n")
cat("Ricklefs_colors length:      ",
    length(Ricklefs_colors), "\n")
cat("Ricklefs_colors names:\n")
for (nm in names(Ricklefs_colors)){
  cat("   ", nm, " = ", Ricklefs_colors[[nm]], "\n", sep = "")
}
cat("--------------------\n\n")

## Write CSVs (the human-readable source-of-truth).
utils::write.csv(Whittaker_biomes,
                 file       = bio_csv,
                 row.names  = FALSE)

utils::write.csv(
  data.frame(
    biome = names(Ricklefs_colors),
    color = unname(Ricklefs_colors),
    stringsAsFactors = FALSE
  ),
  file      = col_csv,
  row.names = FALSE
)

cat("Wrote CSVs:\n")
cat("   ", bio_csv, "\n")
cat("   ", col_csv, "\n\n")

## Save as package data (.rda in data/, the convention for R
## packages with LazyData: true). This makes Whittaker_biomes
## and Ricklefs_colors available to package users after
## library(whittakerr).
##
## Requires: usethis. Install via install.packages("usethis")
## if not already present.

if (!requireNamespace("usethis", quietly = TRUE)) {
  stop("Package 'usethis' is required for this build step. Install via install.packages('usethis').")
}

cat("Writing package data via usethis::use_data() ...\n")
usethis::use_data(Whittaker_biomes, overwrite = TRUE)
usethis::use_data(Ricklefs_colors,  overwrite = TRUE)

## --- Build the multi-palette dataset -------------------------
##
## biome_palettes holds one color palette per column, keyed by
## biome: ricklefs (the iconic palette, identical to
## Ricklefs_colors) and cvd (Paul Tol's muted qualitative
## scheme, for color-vision-deficiency safety). Grayscale and
## custom palette columns will be added later. The
## source-of-truth is data-raw/biome_palettes.csv.

pal_csv        <- "data-raw/biome_palettes.csv"
biome_palettes <- utils::read.csv(pal_csv, stringsAsFactors = FALSE)

## Sanity check: the ricklefs column must match Ricklefs_colors.
rick_expected <- Ricklefs_colors[biome_palettes$biome]
if (any(is.na(rick_expected)) ||
    !all(biome_palettes$ricklefs == rick_expected)) {
  stop("biome_palettes.csv biome/ricklefs columns do not match Ricklefs_colors.")
}

cat("Writing biome_palettes via usethis::use_data() ...\n")
usethis::use_data(biome_palettes, overwrite = TRUE)

## --- Build the biome abbreviation table ----------------------
##
## biome_abbrev maps each biome's full name to a short
## CamelCase abbreviation that fits as a label inside a
## Whittaker diagram or a biome map, where the full names are
## too long. It also carries optional hand-set label
## coordinates (label_temp, label_precp) for biomes whose
## diagram centroid sits poorly. Source-of-truth:
## data-raw/biome_abbrev.csv.

abbrev_csv   <- "data-raw/biome_abbrev.csv"
biome_abbrev <- utils::read.csv(abbrev_csv, stringsAsFactors = FALSE)

## Sanity check: the biome column must list exactly the nine
## biomes in Ricklefs_colors.
if (!setequal(biome_abbrev$biome, names(Ricklefs_colors))) {
  stop("biome_abbrev.csv biome column does not match the nine biomes in Ricklefs_colors.")
}

cat("Writing biome_abbrev via usethis::use_data() ...\n")
usethis::use_data(biome_abbrev, overwrite = TRUE)

## Clean up.
unlink(c(rda_bio, rda_col))
rm(env_bio, env_col, rda_bio, rda_col,
   url_bio, url_col, pal_csv, rick_expected, abbrev_csv,
   Whittaker_biomes, Ricklefs_colors, biome_palettes,
   biome_abbrev)

cat("\nDone. Package data is now current.\n")
cat("CSVs are at: ", bio_csv, ", ", col_csv, "\n", sep = "")
cat("Package data (.rda) is at: data/Whittaker_biomes.rda, data/Ricklefs_colors.rda, data/biome_palettes.rda, data/biome_abbrev.rda\n")
