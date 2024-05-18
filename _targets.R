library(targets)
library(tarchetypes)

tar_option_set(packages = c("dplyr", "ggplot2", "knitr"))

# End this file with a list of target objects.
list(
  tar_target(file, "ds_salaries.csv", format = "file"),
  tar_target(data, read.csv(file)),
  tar_quarto(analysis, "analysis.qmd"),
  tar_target(sum_full_data, summary(data)),
  tar_target(data_fac, mutate(data, across(where(is.character), as.factor))),
  tar_target(de_data, filter(data_fac, job_title == "Data Engineer")),
  tar_target(sum_de_data, summary(de_data)),
  tar_target(missing_de_data, kable(colSums(is.na(de_data)), label = "Missing values for de_data", col.names = c("Variable", "Number of missing values"))),
  tar_target(de_data_experience, de_data |>
               mutate(
                 experience = case_when(
                   experience_level == "EN" ~ "Junior",
                   experience_level == "MI" ~ "Mid-Level",
                   experience_level == "SE" ~ "Senior",
                   TRUE ~ "Director"
                 )) |>
               select(-experience_level)),
  tar_target(de_data_location, de_data_experience |>
               mutate(
                 company_loc = case_when(
                   company_location == "US" ~ "US",
                   TRUE ~ "Other"
                 )) |>
                select(-company_location)),
  tar_target(de_data_clean, de_data_location |> filter(employment_type == "FT")),
  tar_target(salary_trend_plot, de_data_clean |>
               group_by(work_year) |>
               summarize(average_salary = mean(salary_in_usd), .groups = 'drop') |>
               ggplot(aes(x = work_year, y = average_salary)) +
               geom_line(color = "blue") +
               geom_point() +
               labs(
                 title = "Average Salary over Years",
                 x = "Work Year",
                 y = "Average Salary"
               ) +
               theme_minimal()),
 tar_target(salary_experience_plot, de_data_clean |>
              group_by(work_year, experience) |>
              summarize(average_salary = mean(salary_in_usd), .groups = 'drop') |>
              ggplot(aes(x = work_year, y = average_salary, color = experience)) +
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
              ggplot(aes(x = work_year, y = average_salary, color = company_loc)) +
              geom_line() +
              geom_point() +
              labs(
                title = "Average Salary over Years by Company Location",
                x = "Work Year",
                y = "Average Salary",
                color = "Company Location"
              ) +
              theme_minimal()),
 tar_target(lm_mod, lm(salary_in_usd ~ work_year + experience + company_loc, data = de_data_location)),
 tar_target(summary_lm, summary(lm_mod))
 
)
