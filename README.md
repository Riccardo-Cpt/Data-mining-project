# Data-mining-project

**Goal**

Given Asian and White Colorectal cancer patiens gene expression profiles, the aim of the project was to find the main differences between cancer in the two ethnicities.

**Data**
We used 3 datasets:
  *TCGA (RNA-seq), divided in 246 White and 25 Asian patients
  *GEO (RNA-seq), (GSE154548) with 40 Korean patients
  *GEO (Affymetrix), (GSE101896) with 90 Japanese patients

**Preprocessing** 

Initial PCA and boxplot of the three merged datasets:
<p float="left">
  <img src="https://github.com/Riccardo-Cpt/Images/blob/main/Initial_PCA.png" width="500" /> 
  <img src="https://github.com/Riccardo-Cpt/Images/blob/main/Initial_boxplot.png" width="500" />
</p>

Feature engineering:
* Merge two RNAseq datasets --> use t-test to remove rows with noise
* ComBAT package to normalize the batch effect between 2 datasets
* Add Affymetrix dataset to the previous RNAseq dataset obtained from previous steps
* Apply comBAT again to remove batch between two datasets
* Remove features where variance is too high 

<p float="left">
  <img src="https://github.com/Riccardo-Cpt/Images/blob/main/PCA_after.png" width="500" /> 
  <img src="https://github.com/Riccardo-Cpt/Images/blob/main/Boxplot_after.png" width="500" />
</p>

Mutual information to keep most relevant features only (300) --> random forest accuracy around 90%, no presence of overfitting for a specific dataset observed, meaning they are relevant in the discrimination between Asian and White ethnicities

**Cancer genes**

12 over these 300 genes revealed cancer specific by querying Oncogene database. Gene ontology and EnrichR databases revealed they belong to Nothch signalling pathway, regulating many downstream activities in the cell. From literature they regulate regulated cell death in case of cancer.

<img src="https://github.com/Riccardo-Cpt/Images/blob/main/Cancer_genes.png" width="600" /> 

Using boxplot to plot those genes and comparing expression in Asian VS White patients it is clearly visible higher level of expression in the latter group. Higher level of expression could possibly mean more subsceptibility towards the tumor. This hypothesis it's in line with the higher mortality rate in White populations with respect to Asian

<img src="https://github.com/Riccardo-Cpt/Images/blob/main/Notch_genes.png" width="720" />

