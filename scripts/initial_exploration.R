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