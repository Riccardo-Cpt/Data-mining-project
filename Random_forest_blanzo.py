#load dataframe
import pandas as pd

df = pd.read_csv("Z-scores_merged.csv")

#rename rows of dataframe as column X (that is the name of the genes)
df = df.rename(dict(zip(df.index, df['X'])))
#remove column X to have an only numeric dataset
df = df.iloc[:,2:]


#dictionary to store race of all the patients (1 = asian, 0 = white)
import numpy as np
import pandas as pd
ref = pd.read_csv("TCGA_expression_log2cpm.csv")
ref = ref.iloc[:,1:]
ref

race = {}
# asian =1, white = 0
for i in range(len(ref.columns)):
    if ref.iloc[0,i] == "asian":
        race[ref.columns[i]] = 1
    elif ref.iloc[0,i] == "white":
        race[ref.columns[i]] = 0
    else:
        raise(TypeError("aaaaaa"))
    
for i in range(len(df.columns)):
    if df.columns[i] not in race:
        race[df.columns[i]] = 1

#convert the dictionary into dataframe to add it as new column in dataframe in the next step
dfObj = pd.DataFrame.from_dict(race, orient='index')
dfObj 

#Random forest implementation
from sklearn.model_selection import train_test_split

#I added the previously obtained dataset defining if patient is asian or white as a new column to the dataframe
# to do so I needed to transpose the dataframe
df2 = df.transpose()
df2["race"] = dfObj

print(df.shape)
#print(df2["race"].value_counts())
print(df2.shape)

#to abtain indexes for asian or white patients in the dataframe
asian = np.where(df2.race == 1)[0].tolist()
white = np.where(df2.race == 0)[0].tolist()
print(len(asian), len(white))

# Get train and test set (70/30)
x=df3[df3.columns[0:len(df3.columns)-1]]  # x è un dataset che comprende tutti i geni e i loro valori numerici
# quindi non comprende la colonna ["race"]

#y è un dataset composto solo dalla colonna ["race"]
y=df3[df3.columns[-1]]  # Labels, same as taking df3["race"]

#Funzione figa che splitta in automatico il dataset date le features (race in questo caso)
X_train, X_test, y_train, y_test = train_test_split(x, y, test_size=0.3) # 70% training and 30% test


from sklearn.ensemble import RandomForestClassifier
#900 trees, con bootstrap
clf=RandomForestClassifier(n_estimators=900,bootstrap=True)

#Train the model using the training sets 
clf.fit(X_train,y_train)

# Predict features of test set
y_pred=clf.predict(X_test)

y_pred
print(np.unique(y_pred,return_counts=True)) # 0 = white, 1 = asian
count_race(X_test) # only to check if classifier prediction is similar to n° of asian and white in test dataset

#Import scikit-learn metrics module for accuracy calculation
from sklearn import metrics
# Model Accuracy, how often is the classifier correct?
print("Accuracy:",metrics.accuracy_score(y_test, y_pred))
# Model Accuracy, how often is the classifier correct?
print("Accuracy:",metrics.accuracy_score(y_test, y_pred))

#Fatto girare un po' di volte ed era sempre sopra il 95%
