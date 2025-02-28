################################################
## LOAD LIBRARIES                             ##
################################################
################################################

library(optparse)
library(ggplot2)
library(RColorBrewer)
library(pheatmap)

################################################
################################################
## PARSE COMMAND-LINE PARAMETERS              ##
################################################
################################################
option_list <- list(
  make_option(c("-i", "--input_file"), type="character", default=NULL, metavar="path", help="Input sample file"),
  make_option(c("-g", "--geneFunctions_file"), type="character", default=NULL, metavar="path", help="Gene Functions file."),
  make_option(c("-a", "--annoData_file"), type="character", default=NULL, metavar="path", help="Annotation Data file."),
  make_option(c("-p", "--outprefix"), type="character", default='projectID', metavar="string", help="Output prefix.")
)


opt_parser <- OptionParser(option_list=option_list)
opt        <- parse_args(opt_parser)

sampleInput=opt$input_file
geneInput=opt$geneFunctions_file
annoInput=opt$annoData_file
outprefix=opt$outprefix

testing="Y"
if (testing == "Y"){
  sampleInput="sampleData.csv"
  geneInput="geneFunctions.csv"
  annoInput="annoData.csv"
  outprefix="test"
}


if (is.null(sampleInput)){
  print_help(opt_parser)
  stop("Please provide an input file.", call.=FALSE)
}

################################################
################################################
## READ IN FILES##
################################################
################################################
sampleData=read.csv(sampleInput,row.names=1)
annoData=read.csv(annoInput,row.names=1)
geneFunctions=read.csv(geneInput,row.names=1)

################################################
################################################
## Set colors##
################################################
################################################
annoColors <- list(
  gene_functions = c("Oxidative_phosphorylation" = "#F46D43",
                     "Cell_cycle" = "#708238",
                     "Immune_regulation" = "#9E0142",
                     "Signal_transduction" = "beige", 
                     "Transcription" = "violet"), 
  Group = c("Disease" = "darkgreen",
            "Control" = "blueviolet"),
  Lymphocyte_count = brewer.pal(5, 'PuBu')
)

################################################
################################################
## Create a basic heatmap##
################################################
################################################

basic_heatmap <-
pheatmap(sampleData, 
         scale = "none",        # Options: "none", "row", "column"
         clustering_distance_rows = "euclidean",  # Distance measure for rows
         clustering_distance_cols = "euclidean",  # Distance measure for columns
         clustering_method = "ward.D",           # Clustering method
         main = "Basic_heatmap",
         show_rownames = TRUE,
         show_colnames = TRUE
)

# Save a PDF
pdf(paste("basic_heatmap_", outprefix, ".pdf", sep=""), width = 10, height = 8)
print(basic_heatmap)
dev.off()

################################################
################################################
## Create a complex heatmap##
################################################
################################################

# Define custom labels for the legend
labels <- c("Low", "Medium", "High")
legend_colors <- brewer.pal(5, 'PuBu')

complex_heatmap <-
  pheatmap(sampleData, 
         scale = "none",        # Options: "none", "row", "column"
         clustering_distance_rows = "euclidean",  # Distance measure for rows
         clustering_distance_cols = "euclidean",  # Distance measure for columns
         clustering_method = "ward.D",           # Clustering method
         main = "Complex_heatmap",
         show_rownames = TRUE,
         show_colnames = TRUE,
         angle_col = 45,
         annotation_row = geneFunctions,
         annotation_col = annoData,
         annotation_colors = annoColors,
         annotation_names_row = FALSE,
         annotation_names_col = FALSE,
         breaks = c(-0.5, 0, 0.5, 1),
         color = legend_colors,
         legend_breaks = c(-0.5,0.25,1),
         legend_labels = c("Low","Medium","High"),
         annotation_legend = TRUE
)

pdf(paste("complex_heatmap_", outprefix, ".pdf", sep=""), width = 10, height = 8)
print(complex_heatmap)
dev.off()

