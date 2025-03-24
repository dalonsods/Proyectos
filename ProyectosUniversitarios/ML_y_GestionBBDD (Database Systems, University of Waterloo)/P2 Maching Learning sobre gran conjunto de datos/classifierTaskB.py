import pandas as pd
from sklearn.tree import DecisionTreeClassifier
from sklearn.model_selection import GridSearchCV
from sklearn.model_selection import StratifiedKFold
from sklearn.metrics import confusion_matrix, accuracy_score, recall_score, precision_score, f1_score
import numpy as np

# Load data from CSV
df = pd.read_csv('taskB.csv')

# Remove playerID as we won't use it to classify
df = df.drop(columns=['playerID'])

# Separate features (X) and class (y)
X = df.drop(columns=['class']).astype(float)
y = df['class'].astype(int)

# Define the Decision Tree model
dt = DecisionTreeClassifier(random_state=73)

# Define the possible values of hyperparameters to tune
param_grid = {
    'max_depth': [5, 10, 15, 20, 25, 35, 50, None],
    'min_samples_split': [2, 5, 10, 15, 20, 25],
    'min_samples_leaf': [1, 2, 4, 6, 8, 10, 15, 20],
    'criterion': ['gini', 'entropy']
}

# Define a Stratified KFold for external cross-validation
# We use n_splits = 5 to match the lab manual (80% train, 20% test)
outer_cv = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)

# List to store metrics
accuracies = []
recalls = []
precisions = []
f1_scores = []
confusion_matrices = []

# Start the external cross-validation process
for train_idx, test_idx in outer_cv.split(X, y):
    X_train, X_test = X.iloc[train_idx], X.iloc[test_idx]
    y_train, y_test = y.iloc[train_idx], y.iloc[test_idx]

    # Define internal cross-validation with GridSearchCV
    inner_cv = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)
    grid_search = GridSearchCV(estimator=dt, param_grid=param_grid, cv=inner_cv, scoring='balanced_accuracy', n_jobs=-1)

    # Fit the model with the training set
    grid_search.fit(X_train, y_train)

    # Get the best model from GridSearchCV
    best_model = grid_search.best_estimator_

    # Evaluate the model
    y_pred = best_model.predict(X_test)

    # Calculate relevant metrics
    accuracy = accuracy_score(y_test, y_pred)
    recall = recall_score(y_test, y_pred)
    precision = precision_score(y_test, y_pred)
    f1 = f1_score(y_test, y_pred)
    cm = confusion_matrix(y_test, y_pred)

    # Store the metrics
    accuracies.append(accuracy)
    recalls.append(recall)
    precisions.append(precision)
    f1_scores.append(f1)
    confusion_matrices.append(cm)

# Calculate the average metrics from the 5 folds
print(f"Accuracy: {np.mean(accuracies):.4f}")
print(f"Recall: {np.mean(recalls):.4f}")
print(f"Precision: {np.mean(precisions):.4f}")
print(f"F1 Score: {np.mean(f1_scores):.4f}")
print(f"Sum Confusion Matrix:\n {np.sum(confusion_matrices, axis=0)}")

# Write results to a text file
with open('resultsTaskB.txt', 'w') as f:
    f.write(f"Accuracy: {np.mean(accuracies):.4f}\n")
    f.write(f"Recall: {np.mean(recalls):.4f}\n")
    f.write(f"Precision: {np.mean(precisions):.4f}\n")
    f.write(f"F1 Score: {np.mean(f1_scores):.4f}\n")
    f.write(f"Sum Confusion Matrix:\n {np.sum(confusion_matrices, axis=0)}\n")
