#!/usr/bin/env Rscript

rm( list=ls() )

library("optparse")

option_list <- list(

  # required args
  make_option(c("--counts"), type="character", default=NULL,
              help="input counts file", metavar="character"),
  make_option(c("--metadata"), type="character", default=NULL,
              help="input metadata file", metavar="character"),
  make_option(c("--group1"), type="character", default=NULL,
              help="label for group 1", metavar="character"),
  make_option(c("--group2"), type="character", default=NULL,
              help="label for group 2", metavar="character"),
  make_option(c("--significant_hits"), type="character", default=NULL,
              help="filename to use for significant hits", metavar="character"),
  make_option(c("--all_hits"), type="character", default=NULL,
              help="filename to use for all hits", metavar="character"),
  make_option(c("--normalised_counts"), type="character", default=NULL,
              help="filename to use for normalised counts", metavar="character"),

  # optional args
  make_option(c("--label"),
              type="character",
              default='condition',
              help="column label for treatment groups (default = 'condition')",
              metavar="character"),
  make_option(c("--alpha"),
              type="numeric",
              default=0.05,
              help="significance cutoff (default = 0.05)",
              metavar="numeric")
  )

opt_parser <- OptionParser(option_list=option_list)
opt <- parse_args(opt_parser)

print(opt$counts)
print(opt$metadata)
print(opt$group1)
print(opt$group2)
print(opt$significant_hits)
print(opt$all_hits)
print(opt$normalised_counts)
print(opt$label)
print(opt$alpha)


########## Analysis of miRNA DE using DESeq2 ########################################


# import modules
library( "DESeq2" )

#setwd("C:/Users/cow082/Desktop/120820_desktop_cleanup/cov2")

# load data and metadata
df <- read.csv( opt$counts, header=TRUE, row.names=1, check.names=FALSE)
md <- read.csv( opt$metadata, header=TRUE, row.names=1, stringsAsFactors=FALSE )

dim(df)
dim(md)

#barplot(colSums(df), log="y")

# force data to integers
df <- ceiling( df ) # { ceiling, floor, round }

# # remove columns (samples) with few reads
# keep <- colSums( df) > 10000
# df <- df[ ,keep ]
#
# # remove columns not in metadata
# keep <- intersect(rownames(md), colnames(df))
# df <- df[ ,keep ]
#
# # remove rows not in df
# md <- t(md)
# md <- md[ ,keep ]
# md <- t(md)

# remove rows (features/miRNAs) with all zeros
keep <- rowSums( df ) > 0
df <- df[ keep, ]

# calculate CPM
cpm <- apply(df, 2, function(x) (x/sum(x))*1000000)

# filter rows: at least 3 samples must have at least 1 cpm
keep <- rowSums( cpm >= 1 ) >= 3
df <- df[ keep, ]

dim(df)

# make sure this is true!!!!
all(rownames(md) == colnames(df))
# TRUE

######################################################################################

# construct a SummarizedExperiment object
dds <- DESeqDataSetFromMatrix(
  countData = df,
  colData = md,
  design = as.formula(
    paste("~", opt$label, sep = " ")
  )
)

# perform DE testing
dds <- DESeq( dds )     # test=c( "Wald", "LRT" ) # could be worth trying both options

# display results names
resultsNames( dds )

################################################################################

# display/save normalised/transformed data

# output normalised counts
norm_counts <- counts( dds, normalized=TRUE )
write.csv( norm_counts, file=opt$normalised_counts )

# # regularized-logarithm transformation (reduces dispersion in low count data using a Baysian model)
# rld <- rlog( dds )
# write.csv( assay( rld ), file="DESeq2_rld.csv" )
#
# # Variance stabilizing transformation
# vsd <- varianceStabilizingTransformation( dds, blind=TRUE )
# write.csv( assay( vsd), file="DESeq2_vsd.csv" )

################################################################################

# convert results to dataframe
res <- results( dds, contrast=c( opt$label, opt$group1, opt$group2 ))

write.csv( res, file=opt$all_hits )

# filter on FDR
sig <- res[ which( res$padj < opt$alpha ), ]

# sort on fold change (upregulated genes first) or padj (most significant first)
sig <- sig[ order( sig$log2FoldChange, decreasing=FALSE ), ]
sig <- sig[ order( sig$padj, decreasing=FALSE ), ]
write.csv( sig, file=opt$significant_hits )

# report the number of significant hits
dim(sig)[1]

up   <- sig[ which( sig$log2FoldChange > 0 ), ]
down <- sig[ which( sig$log2FoldChange < 0 ), ]

dim(up)[1]
dim(down)[1]

# get lists of gene ids
deseq_hits <- rownames( sig )

# print results
deseq_hits

# print one per line
cat( deseq_hits, sep="\n" )

sessionInfo()

###############################################################################
