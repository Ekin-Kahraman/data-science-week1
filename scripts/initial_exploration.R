# Week 1: Initial Data Exploration ====
# Author: Ekin Kahraman
# Date: 2026-02-19

# Load packages ====
library(tidyverse)
library(here)
library(naniar)
library(janitor)
library(skimr)

# Load data ====
mosquito_egg_raw <- read_csv(here("data", "mosquito_egg_data.csv"),
                             name_repair = janitor::make_clean_names)

# Basic overview ====
glimpse(mosquito_egg_raw)
summary(mosquito_egg_raw)
skim(mosquito_egg_raw)

# React table====
view(mosquito_egg_raw)

# Counts by site and treatment====
mosquito_egg_raw |> 
  group_by(site, treatment) |> 
  summarise(n = n())

# Observations ====
# - What biological system is this?
#  Mosquito egg-laying behaviour under pesticide treatment at three field sites (The metadata also stated this in the coursebook)


# - What's being measured?
#  Eggs laid and eggs hatched per female across four dose treatments

# - How many observations?
# 205 rows, 9 variables

# - Anything surprising?
# Negative body mass value (e.g -92.997339 mg, -56.814978, -87.161492) which is impossible
# A collection date in January 2024 (row 82), outside the study period
# eggs_laid has a minimum of 0 which could be fine just something that looked weird

# - Any obvious problems?
# Site names have inconsistent formatting (Site_A, Site A, site_a, Site-A)
# Treatment names have are inconsistent in their capitals (another formatting issue) - (Control, control, HIGH_DOSE)
# Collector has typos (Garci, Smyth) and 13 missing values
# 15 missing body_mass_mg, 16 missing eggs_laid, 17 missing eggs_hatched

# FIX 1: Inconsistent string formatting in site, treatment, and collector ====

# Show the problem:
mosquito_egg_raw |> distinct(site)
mosquito_egg_raw |> distinct(treatment)
mosquito_egg_raw |> distinct(collector)

# Fix it:
mosquito_egg_data_step1 <- mosquito_egg_raw |>
  mutate(
    site = str_to_lower(site),
    site = str_replace(site, "[ -]", "_"),
    treatment = str_to_lower(treatment),
    treatment = str_replace(treatment, " ", "_"),
    collector = case_when(
      collector == "Garci" ~ "Garcia",
      collector == "Smyth" ~ "Smith",
      .default = collector
    )
  )

# Verify it worked:
mosquito_egg_data_step1 |> distinct(site)
mosquito_egg_data_step1 |> distinct(treatment)
mosquito_egg_data_step1 |> distinct(collector)

# What changed and why it matters:
# Standardised site from 12 variants to 3 (site_a, site_b, site_c).
# Standardised treatment from 12 variants to 4 (control, low_dose, medium_dose, high_dose).
# Fixed collector typos (Garci -> Garcia, Smyth -> Smith).
# Without this fix, grouped analyses would treat the same site or treatment as separate groups.
#


# FIX 2: Negative body mass values  ====

# Show the problem:
mosquito_egg_data_step1 |> filter(body_mass_mg < 0)

# Fix it:
mosquito_egg_data_step2 <- mosquito_egg_data_step1 |>
  mutate(
    body_mass_mg = if_else(body_mass_mg < 0, NA, body_mass_mg)
  )

# Verify it worked:
mosquito_egg_data_step2 |> filter(body_mass_mg < 0)
mosquito_egg_data_step2 |> summary()

# What changed and why it matters:
# Converted negative body mass values to NA. Body mass cannot be negative so these
# are data entry errors. Converting to NA rather than removing rows preserves the
# other variables for those observations.
#