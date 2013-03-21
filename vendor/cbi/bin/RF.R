# Rscript RF.R input_file data_file output_file
# if output_file is empty, print to standard output
library("randomForest")
args <- commandArgs(TRUE)
submit <- read.table(args[1])
submit <- as.matrix(submit)
load(args[2])
vote <- predict(RF_tfbs,submit,type="prob",norm.votes=TRUE)
if (is.na(args[3])) vote_fn <- "" else vote_fn <- args[3]
write.table(vote,vote_fn,quote=FALSE,sep='\t',col.names=FALSE,row.names=FALSE)
