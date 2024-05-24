library(targets)
library(tarchetypes)

tar_option_set(packages = c("dplyr", "ggplot2", "knitr"))

# End this file with a list of target objects.
list(
  tar_target(file, "ds_salaries.csv", format = "file"),
  tar_target(data, read.csv(file)),
  tar_quarto(analysis, "analysis.qmd"),
  tar_target(data_class, kable(data.frame(sapply(data, class)), booktabs = TRUE, caption = "Date format check", col.names = c("Variable", "Class"))),
  tar_target(data_fac_work_year, data |> mutate(work_year = as.factor(work_year))), 
  tar_target(data_fac, mutate(data_fac_work_year, across(where(is.character), as.factor))),
  tar_target(missing_data_fac, kable(colSums(is.na(data_fac)), label = "Missing values", col.names = c("Variable", "Number of missing values"))),
  tar_target(data_engineer_roles, data_fac[grep("Data Engineer", data_fac$job_title), ]),
  tar_target(unique_job_title, unique(data_engineer_roles$job_title)),
  tar_target(de_data, filter(data_fac, job_title == "Data Engineer")),
  tar_target(de_data_location, de_data |>
               mutate(
                 company_loc = as.factor(case_when(
                   company_location == "US" ~ "US",
                   TRUE ~ "Other"
                 ))) |>
                select(-company_location)),
  tar_target(de_data_clean, de_data_location |> filter(employment_type == "FT")),
  tar_target(data_for_sum_stat, de_data_clean |> select(-c(job_title, employment_type))),
  tar_target(numerical_dat, data_for_sum_stat[, sapply(data_for_sum_stat, is.numeric)]),
  tar_target(sum_numeric, summary(numerical_dat)),
  tar_target(factor_dat, data_for_sum_stat[, sapply(data_for_sum_stat, is.factor)]),
  tar_target(sum_factor, summary(factor_dat)),
  tar_target(sum_de_data, summary(de_data_clean)),
  tar_target(salary_trend_plot, de_data_clean |>
               group_by(work_year) |>
               summarize(average_salary = mean(salary_in_usd), .groups = 'drop') |>
               ggplot(aes(x = work_year, y = average_salary)) +
               geom_line(color = "blue", group = 1) +
               geom_point() +
               labs(
                 title = "Average Salary over Years",
                 x = "Work Year",
                 y = "Average Salary"
               ) +
               theme_minimal()),
 tar_target(salary_experience_plot, de_data_clean |>
              group_by(work_year, experience_level) |>
              summarize(average_salary = mean(salary_in_usd), .groups = 'drop') |>
              ggplot(aes(x = work_year, y = average_salary, color = experience_level, group = experience_level)) +
              geom_line() +
              geom_point() +
              labs(
                title = "Average Salary over Years by Experience Level",
                x = "Work Year",
                y = "Average Salary",
                color = "Experience Level"
              ) +
              theme_minimal()),
 tar_target(salary_company_loc_plot, de_data_clean |>
              group_by(work_year, company_loc) |>
              summarize(average_salary = mean(salary_in_usd), .groups = 'drop') |>
              ggplot(aes(x = work_year, y = average_salary, color = company_loc, group = company_loc)) +
              geom_line() +
              geom_point() +
              labs(
                title = "Average Salary over Years by Company Location",
                x = "Work Year",
                y = "Average Salary",
                color = "Company Location"
              ) +
              theme_minimal()),
 tar_target(lm_mod, lm(salary_in_usd ~ work_year + experience_level + company_loc, data = de_data_clean)),
 tar_target(summary_lm, summary(lm_mod))
 
)
