#############################Try combat################################
library(limma)
library(dplyr)
library(edgeR)

library("genefilter")
library("BiocParallel")
library("sva")


########################################################################
setwd("/home/riccardo/Desktop/Data mining/")
geo = read.csv("GSE154548_expression_rnaseq.csv")
rownames(geo) = geo$ensembl_gene_id
geo$X = geo$ensembl_gene_id
geo = geo[,2:dim(geo)[2]]

tcga = read.csv("OrderedTCGA_ensmbl.csv") #log_tcga, 9 asian, 246 white
tcga = tcga[2:dim(tcga)[1],]
X = tcga$X
tcga = tcga[,2:dim(tcga)[2]]
tcga = mutate_all(tcga, function(x) as.numeric(as.character(x)))
rownames(tcga) = X; colSums(2^(tcga)-1) #verify cpm

##keeping only asian
a_tcga = tcga[,1:9]


a_tcga$X = X

#rimuovere la colonna X per far girare
#colSums(2^(geo)) #X30_HTseq_res_star = 1,7kk e X7_HTseq_res_star 0,78kk

#new asian
new_a = read.csv("TCGA_asian_only_log2cpm.csv")
new_a = new_a[3:dim(new_a)[1],]

df = merge(new_a, a_tcga, by = "X") 
rownames(df) = df$X
X = df$X
df = df[,2:dim(df)[2]]
df = mutate_all(df, function(x) as.numeric(as.character(x)))

boxplot(df, outline = F)

df$X = X
#####adding koreans
df2 = merge(df, geo, by = "X") #25, 40
rownames(df2) = df2$X
df2 = df2[,2:dim(df2)[2]]

library("genefilter")
mat_df2 = as.matrix(df2)
f = as.factor(c(rep("A",25), rep("B", 40)))
ttest = rowttests(mat_df2, f) 
keep = which(p.adjust(ttest$p.value, method = "BH")<0.01)
df2 = df2[keep,]
boxplot(df2, outline = F)

X = rownames(df2) 
df2$X = X

#adding white tcga
tcga = read.csv("OrderedTCGA_ensmbl.csv")
tcga = tcga[,c(1,11:dim(tcga)[2])] #to keep only white patients
X = tcga$X
tcga = tcga[2:dim(tcga)[1], 2:dim(tcga)[2]]
tcga = mutate_all(tcga, function(x) as.numeric(as.character(x)))

boxplot(tcga, outline = F)

tcga$X = X[2:length(X)]

df3 = merge(tcga, df2, by = "X")
X = df3$X

df3 = df3[,2:dim(df3)[2]]
df3 <- mutate_all(df3, function(x) as.numeric(as.character(x)))
rownames(df3) = X


medians=apply(df3,2,median)
to_plot=sweep(df3,2,medians,"-")

boxplot(to_plot, outline = F)


setwd("/home/riccardo/Desktop/Data mining/Normalization_trial/")
batch = c(rep("A",271), rep("B",40))
df4 = ComBat(df3,batch) 
write.csv(df4,"246W_65A.csv")

df4 = read.csv("246W_65A.csv")
rownames(df4) = df4$X
df4 = df4[,2:dim(df4)[2]]


boxplot(df4, outline = F)
x = rowVars(df4)
mean(x) #avg variance = 0.27
df4.2 = df4[which(x > 0.001),]
boxplot(df4.2, outline = F)

####affymetrix
affy = read.csv("/home/riccardo/Desktop/Data mining/GSE101896_expression_microarray.csv")
X = affy$ensembl_gene_id
affy = affy[,2:dim(affy)[2]]
affy$X = X

df4.2$X = rownames(df4.2)

df5 = merge(df4.2,affy, by = "X")
rownames(df5)=df5$X
df5 = df5[,2:dim(df5)[2]]
boxplot(df5, outline = F)

medians=apply(df5,2,median)
df5.2=sweep(df5,2,medians,"-")

boxplot(df5.2, outline = F)

batch = c(rep("A",311), rep("B",90))
df5.3 = ComBat(df5.2,batch)
write.csv(df5.3,"246w_65a_90affy.csv")

df5.3 = read.csv("246w_65a_90affy.csv")
rownames(df5.3) = df5.3$X
df5.3 = df5.3[,2:dim(df5.3)[2]]

boxplot(df5.3, outline = F)
boxplot(df5.3,
        xlab="Sample",ylab="Signal",
        axes=F, outline = F)
axis(1,labels=1:ncol(df9),at=1:ncol(df9))
axis(2)
box()

#Filtering
fac = factor(c(rep("W",246), rep("A",155)))
p_val = rowttests(as.matrix(df5.3),fac)
X = which(p.adjust(p_val$p.value)>0.05)

df5.4 = df5.3[X,]

write.csv(df5.4, "W246_A65_A90.csv")
#PCA
library("GEOquery")

pca <- prcomp(t(df5.4))
summary(pca)
screeplot(pca)

grpcol <- c(rep("green",246), rep("orange",65), rep("blue",91))
plot(pca$x[,4], pca$x[,2], xlab="PCA1", ylab="PCA2", main="PCA for components 1&2", type="p", pch=10, col=grpcol)
text(pca$x[,1], pca$x[,2], rownames(pca$data), cex=0.75)

k <- 2
kmeans_result <- kmeans(t(df5.4), k)
table(kmeans_result$cluster)
library(useful)
plot(kmeans_result, data=t(df5.4))