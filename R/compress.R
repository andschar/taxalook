# Script to store compressed data to the R-package sub-directory

# setup -------------------------------------------------------------------
source('R/setup.R')

# data --------------------------------------------------------------------
fl_v = list.files(datadir,
                  pattern = '.tsv',
                  full.names = TRUE)
fl_v = fl_v[c(6,5,3,4,1,2)] # order
# read
l = lapply(fl_v, fread2)
names(l) = sub('.tsv', '', basename(fl_v), fixed = TRUE)
# merge
dat = Reduce(function(...) merge(..., by = 'tl_id'), l)

# write -------------------------------------------------------------------
saveRDS(dat, file.path(datadir, 'taxalook.rds'))
