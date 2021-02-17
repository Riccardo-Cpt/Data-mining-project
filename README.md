# Data-mining-project

**Goal**
Given Asian and White Colorectal cancer patiens gene expression profiles, the aim of the project was to find the main differences between cancer in the two ethnicities.

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
12 over these 300 genes revealed cancer specific by querying 
