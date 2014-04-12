#!/usr/bin/RScript

# plots a 3D VENN from precomputed data
# usage: 3Dvenn.R A-cnt AB-cnt AC-cnt 
#  ABC-cnt B-cnt BC-cnt C-nct
#  A-label B-label C-label 
#  Title (opt)

# counts are epected in the order
# "100","110","101","111","010","011","001"
# the order is arbitrary, from top to bottom and from left to right
# extra arguments: A-label B-label C-label Title (opt)
#
# example command:
# 3DVenn.R -T "4way-Venn" -o "4way.png"
#
# Stephane Plaisance VIB-BITS April-11-2014 v1.0

# required R-packages
# once only install.packages("grid")
# once only install.packages("optparse")
# once only install.packages("colorfulVennPlot")
suppressPackageStartupMessages(library("optparse"))
suppressPackageStartupMessages(library("grid"))
suppressPackageStartupMessages(library("colorfulVennPlot"))

#####################################
### Handle COMMAND LINE arguments ###
#####################################

# parameters
option_list <- list(
  make_option(c("-a", "--a.count"), type="integer", default=0,
              help="counts for A-only"),
  make_option(c("-b", "--b.count"), type="integer", default=0, 
              help="counts for B-only"),
  make_option(c("-c", "--c.count"), type="integer", default=0, 
              help="counts for C-only"),
  make_option(c("-d", "--ab.count"), type="integer", default=0, 
              help="counts for AB-intersect"),
  make_option(c("-e", "--ac.count"), type="integer", default=0, 
              help="counts for AC-intersect"),
  make_option(c("-f", "--bc.count"), type="integer", default=0, 
              help="counts for BC-intersect"),
  make_option(c("-i", "--abc.count"), type="integer", default=0, 
              help="counts for ABC-intersect"),
  make_option(c("-A", "--a.label"), type="character", default="A", 
              help="label for A"),  
  make_option(c("-B", "--b.label"), type="character", default="B", 
              help="label for B"), 
  make_option(c("-C", "--c.label"), type="character", default="C", 
              help="label for C"),
  make_option(c("-t", "--title"), type="character",
              help="Graph Title"),
  make_option(c("-o", "--file"), type="character", default="3Dvenn.png",
              help="file name for output [default: %default]"),
  make_option(c("-u", "--fill"), type="character", default="3",
              help="fill with 1:colors, 2:greys or 3:white [default: %default]")    
)

# PARSE OPTIONS
opt <- parse_args(OptionParser(option_list=option_list))

# check if arguments provided
if (length(opt) > 1) {
# do some operations based on user input

# colors (7)
ncol <- 7
my.colors <- rainbow(ncol)
my.greys <- rev(gray(0:32 / 32))[1:ncol]
my.whites <- rep("#FFFFFF", ncol)
my.fill <- ifelse( rep(opt$fill=="1", ncol), 
				my.colors, 
				(ifelse(rep(opt$fill=="2",ncol), my.greys, my.whites))
				)
				
# title
my.title <- ifelse(!is.null(opt$title), opt$title, "")

# plot
png(file = opt$file, bg = "transparent")
plot.new()

# "A..","AB.","A.C","ABC",".B.",".BC","..C"
y=c(opt$a.count, opt$ab.count, opt$ac.count, 
    opt$abc.count, opt$b.count, opt$bc.count, 
    opt$c.count)
names(y) <- c("100","110","101","111","010","011","001")
labels <- c(opt$a.label, opt$b.label, opt$c.label)
plot.new()
plotVenn3d(y, 
          labels,
          Colors=my.fill, 
          Title = my.title)

dev.off()
}