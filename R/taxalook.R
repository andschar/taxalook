#' Country columns.
#' 
#' @author Andreas Scharmueller \email{andschar@@proton.me}
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
#' @author Andreas Scharmueller \email{andschar@@proton.me}
#' 
#' @noRd
#' 
continent_col = function() {
  c("africa", "asia", "europe", "america_north", 
    "america_south", "oceania")
}

#' Group columns.
#' 
#' @author Andreas Scharmueller \email{andschar@@proton.me}
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
#' @author Andreas Scharmueller \email{andschar@@proton.me}
#' 
#' @noRd
#' 
id_col = function() {
  c("gbif_id", "worms_id", "epa_species_number")
}

#' Taxonomy columns.
#' 
#' @author Andreas Scharmueller \email{andschar@@proton.me}
#' 
#' @noRd
#' 
taxonomy_col = function() {
  c("rank", "common_name", "latin_name", 
    "genus", "species", "family", "tax_order", "class", "superclass", 
    "subphylum_div", "phylum_division", "kingdom")
}

#' Trophic level columns.
#' 
#' @author Andreas Scharmueller \email{andschar@@proton.me}
#' 
#' @noRd
#' 
trophic_lvl_col = function() {
  c("autotroph", "heterotroph")
}

#' Download compressed database.
#' 
#' @author Andreas Scharmueller \email{andschar@@proton.me}
#' 
#' @noRd
#' 
fl_download = function(force_download) {
  destfile_gz = file.path(tempdir(), 'taxalook.sqlite3.gz')
  destfile = file.path(tempdir(), 'taxalook.sqlite3')
  if (!file.exists(destfile_gz) && !file.exists(destfile) || force_download) {
    message('Downloading data..')
    # HACK this has to done, because doi.org is the only permanent link between versions
    qurl_permanent = 'https://doi.org/10.5281/zenodo.5948863'
    req = httr::GET(qurl_permanent)
    cont = httr::content(req, as = 'text')
    qurl = regmatches(cont, regexpr('https://zenodo.org/records/[0-9]+/files/taxalook.sqlite3.gz', cont))
    utils::download.file(qurl,
                         destfile = destfile_gz,
                         quiet = TRUE)
    R.utils::gunzip(destfile_gz, destname = destfile)
  }
  
  return(destfile)
}

#' Read compressed database.
#'
#' @author Andreas Scharmueller \email{andschar@@proton.me}
#'
#' @noRd
#'
fl_read = function(fl) {
  con = DBI::dbConnect(RSQLite::SQLite(), fl)
  q = "SELECT *
       FROM tl_id
       LEFT JOIN tl_continent USING (tl_id)
       LEFT JOIN tl_country USING (tl_id)
       LEFT JOIN tl_group USING (tl_id)
       LEFT JOIN tl_habitat USING (tl_id)
       LEFT JOIN tl_taxonomy USING (tl_id)
       LEFT JOIN tl_trophic_lvl USING (tl_id)"
  out = DBI::dbGetQuery(con, q)
  data.table::setDT(out)
  DBI::dbDisconnect(con)
  
  return(out)
}

#' Query the taxa lookup up database.
#' 
#' @import data.table
#' 
#' @param query character vector; Which taxa should be returned?
#' @param query_match Should \code{query} names be matched exactly or by pattern?
#' Can be one of exact (default) or fuzzy.
#' @param from Which column should be used for matching? Can be one of:
#' 'tl_id', 'gbif_id', 'ncbi_id', 'worms_id' or 'epa_species_number'.
#' If NULL (default), queries are matched against all columns (for taxa names).
#' @param what What should be returned? Can be one or multiple of 'id' (default),
#' 'continent', 'country', 'group', 'habitat', 'taxonomy' or 'trophic_lvl'.
#' @param force_download Force download anyway? Helpful if downloaded file is corrupt.
#'
#' @return Returns a data.table.
#' 
#' @author Andreas Scharmueller \email{andschar@@proton.me}
#' 
#' @export
#' 
#' @examples 
#' tl_query(query = 'Oncorhynchus', what = 'group')
#' tl_query(query = c('Daphnia', 'Perla'), what = 'habitat', query_match = 'exact')
#' tl_query(query = 'quercus', query_match = 'fuzzy', what = c('continent'))
#'
tl_query = function(query = NULL,
                    query_match = 'exact',
                    from = NULL,
                    what = 'id',
                    force_download = FALSE) {
  # checks
  if (is.null(query)) {
    message('No query supplied. All entries are returned.')
  }
  query_match = match.arg(query_match,
                          choices = c('exact', 'fuzzy'))
  if (!is.null(from)) {
    from = match.arg(from,
                     choices = c(NULL,
                                 'epa_species_number',
                                 'gbif_id',
                                 'tl_id',
                                 'worms_id'))
  }
  what = match.arg(what,
                   choices = c('id',
                               'continent',
                               'country',
                               'group',
                               'habitat',
                               'taxonomy',
                               'trophic_lvl'),
                   several.ok = TRUE)
  # data
  fl = fl_download(force_download = force_download)
  dat = fl_read(fl = fl)
  # filter rows
  if (!is.null(query)) {
    if (!is.null(from)) {
      if (from == 'epa_species_number') {
        dat = dat[epa_species_number == query]
      }
      if (from == 'gbif_id') {
        dat = dat[gbif_id == query]
      }
      if (from == 'tl_id') {
        dat = dat[tl_id == query]
      }
      if (from == 'worms_id') {
        dat = dat[worms_id == query]
      }
    } else {
      if (query_match == 'exact') {
        dat = dat[dat[, Reduce(`|`, lapply(.SD, `%in%`, query))]]
      }
      if (query_match == 'fuzzy') {
        dat = dat[dat[, Reduce(`|`, lapply(.SD, `%ilike%`, paste0(query, collapse = '|')))]]
      }
    }
  }
  # select columns
  col = c('tl_id')
  if ('continent' %in% what) { col = c(col, continent_col()) }
  if ('country' %in% what) { col = c(col, country_col()) }
  if ('group' %in% what) { col = c(col, group_col()) }
  if ('habitat' %in% what) { col = c(col, habitat_col()) }
  if ('id' %in% what) { col = c(col, id_col()) }
  if ('taxonomy' %in% what) { col = c(col, taxonomy_col()) }
  if ('trophic_lvl' %in% what) { col = c(col, trophic_lvl_col()) }
  dat = dat[ , .SD, .SDcols = col ]
  
  return(dat)
}
