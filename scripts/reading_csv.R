
# STEP 1 - READ DATA FROM XLSX

# Adjust the path to your Excel file
data <- read_excel("dataset_rdd.xlsx")

# Check that columns are correct
str(data)
# Expected columns: score, treatment, renewed
