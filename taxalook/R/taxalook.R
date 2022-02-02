#' Country columns.
#' 
#' @author Andreas Scharmueller \email{andschar@@protonmail.com}
#' 
#' @noRd
#' 
country_col = function() {
  c("ad", "ae", "af", "ag", "ai", "al", "am", 
    "ao", "aq", "ar", "as", "at", "au", "aw", "ax", "az", "ba", "bb", 
    "bd", "be", "bf", "bg", "bh", "bi", "bj", "bl", "bm", "bn", "bo", 
    "bq", "br", "bs", "bt", "bv", "bw", "by", "bz", "ca", "cc", "cd", 
    "cf", "cg", "ch", "ci", "ck", "cl", "cm", "cn", "co", "cr", "cu", 
    "cv", "cw", "cx", "cy", "cz", "de", "dj", "dk", "dm", "do", "dz", 
    "ec", "ee", "eg", "eh", "er", "es", "et", "eu", "fi", "fj", "fk", 
    "fm", "fo", "fr", "ga", "gb", "gd", "ge", "gf", "gg", "gh", "gi", 
    "gl", "gm", "gn", "gp", "gq", "gr", "gs", "gt", "gu", "gw", "gy", 
    "hk", "hm", "hn", "hr", "ht", "hu", "id", "ie", "il", "im", "in", 
    "io", "iq", "ir", "is", "it", "je", "jm", "jo", "jp", "ke", "kg", 
    "kh", "ki", "km", "kn", "kp", "kr", "kw", "ky", "kz", "la", "lb", 
    "lc", "li", "lk", "lr", "ls", "lt", "lu", "lv", "ly", "ma", "mc", 
    "md", "me", "mf", "mg", "mh", "mk", "ml", "mm", "mn", "mo", "mp", 
    "mq", "mr", "ms", "mt", "mu", "mv", "mw", "mx", "my", "mz", "na", 
    "nc", "ne", "nf", "ng", "ni", "nl", "no", "np", "nr", "nu", "nz", 
    "om", "pa", "pe", "pf", "pg", "ph", "pk", "pl", "pm", "pn", "pr", 
    "ps", "pt", "pw", "py", "qa", "re", "ro", "rs", "ru", "rw", "sa", 
    "sb", "sc", "sd", "se", "sg", "sh", "si", "sj", "sk", "sl", "sm", 
    "sn", "so", "sr", "ss", "st", "sv", "sx", "sy", "sz", "tc", "td", 
    "tf", "tg", "th", "tj", "tk", "tl", "tm", "tn", "to", "tr", "tt", 
    "tv", "tw", "tz", "ua", "ug", "um", "us", "uy", "uz", "vc", "ve", 
    "vg", "vi", "vn", "vu", "wf", "ws", "xk", "ye", "yt", "za", "zm", 
    "zw", "zz")
}
#' Continent columns.
#' 
#' @author Andreas Scharmueller \email{andschar@@protonmail.com}
#' 
#' @noRd
#' 
continent_col = function() {
  c("africa", "asia", "europe", "america_north", 
    "america_south", "oceania")
}
#' Group columns.
#' 
#' @author Andreas Scharmueller \email{andschar@@protonmail.com}
#' 
#' @noRd 
#' 
group_col = function() {
  c("fungi", "algae", "macrophyte", "plant", 
    "invertebrate", "fish", "amphibia", "reptilia", "aves", "mammalia")
}
#' Habitat columns.
#' 
#' @noRd
#' 
habitat_col = function() {
  c("brack", "fresh", "marin", "terre")
}
#' ID columns.
#' 
#' @author Andreas Scharmueller \email{andschar@@protonmail.com}
#' 
#' @noRd
#' 
id_col = function() {
  c("gbif_id", "worms_id", "epa_species_number")
}
#' Taxonomy columns.
#' 
#' @author Andreas Scharmueller \email{andschar@@protonmail.com}
#' 
#' @noRd
#' 
taxonomy_col = function() {
  c("rank", "common_name", "latin_name", 
    "genus", "species", "family", "tax_order", "class", "superclass", 
    "subphylum_div", "phylum_division", "kingdom")
}
#' Download compressed database.
#' 
#' @author Andreas Scharmueller \email{andschar@@protonmail.com}
#' 
#' @noRd
#' 
fl_download = function() {
  tmp = file.path(tempdir(), 'taxalook.rds')
  if (!file.exists(tmp)) {
    message('Downloading data..')
    qurl = 'https://zenodo.org/record/5948864/files/taxalook.rds'
    utils::download.file(qurl, 
                         destfile = tmp,
                         quiet = TRUE)
  }
  readRDS(tmp)
}

#' Query the taxa lookup up database.
#' 
#' @import data.table
#' 
#' @param tax character vector; Which taxa should be returned?
#' @param tax_match Should \code{tax} names be matched exactly or by pattern?
#' Can be one of fuzzy (default) or exact.
#' @param tl_id integer vector; Should a specific taxalook id entry be returned?
#' @param taxonomy logical; Should taxonomic information be returned?
#' @param id logical; Should identifiers for other databases be returned?
#' @param group logical; Should ecological groups be returned?
#' @param habitat logical; Should habitat information be returned?
#' @param continent logical; Should continental occurrence information be returned?
#' @param country logical; Should country occurrence information be returned?
#'
#' @return Returns a list of three data.tables (filtered data base query results, aggregated data base query results, meta information)
#' 
#' @author Andreas Scharmueller \email{andschar@@protonmail.com}
#' 
#' @export
#' 
#' @examples 
#' tl_query(tax = 'Oncorhynchus', group = TRUE)
#' tl_query(tax = c('Daphnia', 'Perla'), habitat = TRUE, tax_match = 'exact')
#' tl_query(tax = 'quercus', country = TRUE, id = TRUE)
#'
tl_query = function(tax = NULL,
                    tax_match = 'fuzzy',
                    tl_id = NULL,
                    taxonomy = FALSE,
                    id = FALSE,
                    group = FALSE,
                    habitat = FALSE,
                    continent = FALSE,
                    country = FALSE) {
  # to avoid NOTE in R CMD check --as-cran
  tl_id = NULL
  # checks
  if (!is.null(tax) && !is.null(tl_id)) {
    stop('Please provide only one of tax or tl_id.')
  }
  if (is.null(tax) && is.null(tl_id)) {
    message('No taxon or tl_id supplied. All entries are returned.')
  }
  tax_match = match.arg(tax_match, choices = c('fuzzy', 'exact'))
  # data
  dat = fl_download()
  # select columns
  col = c('tl_id', 'taxon')
  if (taxonomy) { col = c(col, taxonomy_col()) }
  if (id) { col = c(col, id_col()) }
  if (group) { col = c(col, group_col()) }
  if (habitat) { col = c(col, habitat_col()) }
  if (continent) { col = c(col, continent_col()) }
  if (country) { col = c(col, country_col()) }
  out = dat[ , .SD, .SDcols = col ]
  # filter rows
  if (!is.null(tax)) {
    if (tax_match == 'exact') {
      out = out[out[ , Reduce(`|`, lapply(.SD, `%in%`, tax)) ]]
    }
    if (tax_match == 'fuzzy') {
      out = out[out[ , Reduce(`|`, lapply(.SD, `%ilike%`, paste0(tax, collapse = '|'))) ]]  
    }
  } else if (!is.null(tl_id)) {
    out = out[ tl_id %in% tl_id ]
  }
  return(out)
}
