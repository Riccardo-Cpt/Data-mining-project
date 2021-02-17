# Data-mining-project
Merge 3 datasets, features engineering

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


![alt text](https://github.com/Riccardo-Cpt/Modelling-project/blob/master/Fig2A_merged.jpg?raw=true)
![alt text](https://github.com/Riccardo-Cpt/Modelling-project/blob/master/Fig2A_merged.jpg?raw=true)
