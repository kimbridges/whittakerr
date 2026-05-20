# Whittaker Notes

Overall, this should be a set of tools that allow a person to examine one or many sites relative to the Whittaker biome classification.

The classification system is based on annual temperature and precipitation data. Whittaker drew polygons in the temperature vs precipitation plot with each polygon representing a different biome.

This is a simple conceptual tool as the biome names are familiar and they can be matched, quite easily, to the type of vegetation one observes.

# Document Structure

The product is envisioned as a Document. This means that there are separate chapters and that the format is a set of qmd files. The files are rendered to HTML and moved to the kimbridges-documents section of the website.

The chapters might be:

**History of Biome Identification.** This includes some notes on Robert Whittaker and his contributions. Whittaker made a number of significant contributions to biology (e.g., his five kingdom’s view changed how we thought about the highest level of biological classification. His biome classification was similarly ground breaking. It is another very useful conceptual tool. Showing a Whittaker diagram at the start is likely important.

**Getting Started.** If tools are created, they need to be loaded. Basic libraries. If Sitemaps is used, there needs to be an explanation of getting an API code, storing it and using it.

**Retrieving Climate data.** This includes historical averages, current data, future forecasts with climate change. Consider if this is a tool as there are other places it might be used. There is a service that provides data based on geographic coordinates (at different scales, such as 2.5 minutes).

**Basic Whittaker Diagrams.** Different color designations. Place single points on a diagram. There is an R function that creates Whittaker diagrams. Is it possible to extract the data so there is more independence in building and analyzing Whittaker diagrams. If so, this might be another tool.

**Retrieving Biome Information.** This gives the name of the biome when supplied with the basic climate data.

**Biome Characteristics.** The area of each biome in the diagram. There might be other things. This part isn’t conceptually clear yet.

**Transitions.** This might be a good place for a discussion. Geographic transitions: The importance of being on a dividing line between biomes. This is a type of ecotone and one might expect higher diversities. Temporal transitions: these may decrease diversity as species are unable to adapt to the changes. This is more than temperature tolerance, for example, but it may be disruptions in phenological triggers.

# Example Driven Demonstrations

As usual, the document should have plenty of examples that show how to use the code. Ideally, the examples are focused on a specific problem or situation.

Botanical Gardens. For a set of gardens, such as those in California, what is the range of biomes in which they are placed? How will this classification change with climate change? Are some gardens more susceptible than other gardens?

Comparing distant places. Sites in Southern California compared to those in South Africa. Japan and the State of Washington.

Biomes shown on maps. Color coded biomes placed as dots on a map. Show a longitudinal gradient of biomes, such as Japan or across Europe. The Sitemaps package would be a good tool for this.

# Style

This should be very similar to the other Documents.

