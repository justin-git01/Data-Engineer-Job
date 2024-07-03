# Data Analysis on Salary of Data Engineers
---
## Overview

This project analyzes the salary trends and influencing factors for Data Engineers from 2020 to 2023. The analysis covers data preparation, exploratory data analysis, and regression modeling. The report is generated using Quarto, and the workflow is managed using the `targets` package. The package environment is managed with `renv`.

## Project Structure

- **data/**: Directory containing the raw data files.
- **scripts/**: Directory containing R scripts for data processing and analysis.
- **reports/**: Directory containing the Quarto report (`analysis.qmd`).
- **_targets.R**: Configuration file for the `targets` package.
- **renv/**: Directory containing the `renv` environment.
- **README.md**: This file.

## Dependencies

- R (version >= 4.0)
- `targets` package
- `renv` package
- `tidyverse` package
- `quarto` package
- Other packages as specified in the `renv.lock` file

## Setup Instructions

1. **Clone the Repository**

   ```sh
   git clone https://github.com/yourusername/data-engineer-salary-analysis.git
   cd data-engineer-salary-analysis
   ```

2. **Initialize the `renv` Environment**

   ```r
   # In R console
   renv::restore()
   ```

3. **Run the Workflow**

   Use the `targets` package to run the entire workflow:

   ```r
   # In R console
   library(targets)
   tar_make()
   ```

4. **Generate the Report**

   The Quarto report can be rendered using:

   ```sh
   quarto render reports/analysis.qmd
   ```

## Data Source

The data used in this analysis is sourced from [Kaggle: 2023 Data Scientists Salary](https://www.kaggle.com/datasets/henryshan/2023-data-scientists-salary), provided by Henry Shan.

## Analysis Summary

The report includes the following sections:

1. **Introduction**
2. **Initial Data Analysis**
   - Data format check
   - Missing values analysis
   - Filtering for Data Engineer roles
   - Re-grouping `company_location`
   - Filtering for full-time roles
3. **Exploratory Data Analysis (EDA)**
   - Summary statistics
   - Average salary trends
   - Salary trends by company location and experience level
4. **Regression Model**
   - Model specification and fitting
   - Coefficient interpretation
   - Statistical significance
   - Model fit and key takeaways
5. **Conclusion**

## Key Findings

- Significant upward trend in data engineer salaries from 2020 to 2023.
- Higher salaries for roles based in the United States.
- Experience level greatly impacts salary, with executive and senior-level positions earning the most.
