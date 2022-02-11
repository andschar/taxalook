# Taxa Lookup

Taxa Lookup (`{taxalook}`) is a database and repository containing tabular information on
species including their places of occurrence (e.g. countries, continents), their
natural habitats (e.g. freshwater) they are occurring in and other information.

## Usage

You can use the R-package `{taxalook}` to query the database directly from
R __OR__ you can download the data from its [Zenodo-Repository](https://zenodo.org/record/5948864).

### From R

#### Installation

```r
remotes::install_github('andschar/taxalook')
```

#### Example

You can query one or multiple taxa (or even all the taxa in the database by
not supplying a string) and you can add specific information on the taxa
depending on your requirements (e.g. `habitat = TRUE`).

```r
require(taxalook)

tax = c('Pimephales promelas', 'Daphnia magna')

tl_query(tax) # Only taxalook identifier and taxon name
tl_query(tax, taxonomy = TRUE) # Adding taxonomy
tl_query(tax, id = TRUE) # Adding identifiers from other databases
tl_query(tax, group = TRUE) # Adding convenient grouping information
tl_query(tax, habitat = TRUE) # Adding habitat information
tl_query(tax, continent = TRUE) # Adding continent occurrence information
tl_query(tax, country = TRUE) # Adding country occurrence information
```

### Raw Data only

All the data tables are stored in the sub-directory __data__ as tab-separated
(i.e. .tsv) and non-quoted files.

| table            | description |
|:-----------------|:------------|
| tl_continent     | On which continent does a taxon occur ? |
| tl_country       | In which country does a taxon occur ? |
| tl_group         | To which group (e.g. algae, invertebrate) does a taxon belong to ? |
| tl_habitat       | In which habitat does a taxon occur ? |
| tl_id            | Table containing identifiers from other databases (e.g. GBIF, WORMS) |
| tl_taxonomy      | Taxonomic classification |

The tables can be merged via the unique key column `tl_id`.

## Contribute

The information here is by no means complete and users are highly encouraged to
contribute information to this database. Missing entries, wrong
entries, more detailed information, you name it. Please signal issues via the [Issue](https://github.com/andschar/taxalook/issues) tracker.

