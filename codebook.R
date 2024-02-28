# Codebook

# link to data: 
  # UNICEF: https://data.unicef.org/resources/dataset/delivery-care/
  # World Bank: https://databank.worldbank.org/reports.aspx?source=2&series=SH.STA.MMRT&country=#

# *** PREPARING DATASET *** ----

# load packages ----
library(tidyverse)
library(readxl)
library(knitr)

# load data ----
anc1 = read_xlsx('anc1.xlsx')
anc4 = read_xlsx('anc4.xlsx')
csec = read_xlsx('csec.xlsx')
instdel = read_xlsx('instdel.xlsx')
sab = read_xlsx('sab.xlsx')
pncmom = read_xlsx('pncmom.xlsx')
pncnb = read_xlsx('pncnb.xlsx')
mmr = read_csv('WB_MMR_2014.csv')

# standardize variable names ----
anc1 =
  anc1 %>%
  rename_with(
    ~ tolower(names(anc1))
  )

anc4 =
  anc4 %>%
  rename_with(
    ~ tolower(names(anc4))
  )

csec =
  csec %>%
  rename_with(
    ~ tolower(names(csec))
  )

instdel =
  instdel %>%
  rename_with(
    ~ tolower(names(instdel))
  )

sab =
  sab %>%
  rename_with(
    ~ tolower(names(sab))
  )

pncmom =
  pncmom %>%
  rename_with(
    ~ tolower(names(pncmom))
  )

pncnb =
  pncnb %>%
  rename_with(
    ~ tolower(names(pncnb))
  )

# prepare UNICEF data ----

# pncnb
pncnb_new = pncnb %>%
  filter(year == '2014') %>%
  select(country, region, income_group, year, national)

pncnb_new = 
  pncnb_new %>%
  rename(pncnb = national)

# pncmom
pncmom_new = pncmom %>%
  filter(year == '2014') %>%
  select(country, region, income_group, year, national)

pncmom_new = 
  pncmom_new %>%
  rename(pncmom = national)

# sab
sab_new = sab %>%
  filter(year == '2014') %>%
  select(country, region, income_group, year, national)

sab_new = 
  sab_new %>%
  rename(sab = national)

# csec
csec_new = csec %>%
  filter(year == '2014') %>%
  select(country, region, income_group, year, national)

csec_new = 
  csec_new %>%
  rename(csec = national)

# anc1
anc1_new = anc1 %>%
  filter(year == '2014') %>%
  select(country, region, income_group, year, national)

anc1_new = 
  anc1_new %>%
  rename(anc1 = national)

# anc4
anc4_new = anc4 %>%
  filter(year == '2014') %>%
  select(country, region, income_group, year, national)

anc4_new = 
  anc4_new %>%
  rename(anc4 = national)

# instdel
instdel_new = instdel %>%
  filter(year == '2014') %>%
  select(country, region, income_group, year, national)

instdel_new = 
  instdel_new %>%
  rename(instdel = national)


# merge
unicef = full_join(anc1_new, anc4_new)
unicef = full_join(unicef, instdel_new)
unicef = full_join(unicef, csec_new)
unicef = full_join(unicef, sab_new)
unicef = full_join(unicef, pncmom_new)
unicef = full_join(unicef, pncnb_new)

unicef[50, 1] = "Bolivia"
unicef[15, 1] = "Kyrgyz Republic"
unicef[27, 2] = "Eastern Europe and Central Asia"


# prepare World Bank data ----
wb = mmr %>%
  select("Country Name", "2014 [YR2014]")

wb = wb %>%
  rename(country = `Country Name`,
         mmr = `2014 [YR2014]`)

wb = wb %>%
  mutate(mmr = na_if(mmr, '..'))

wb[45, 1] = "Democratic Republic of the Congo"
wb[59, 1] = "Egypt"
wb[199, 1] = "Turkey"


# merge UNICEF and World Bank data ----
df = left_join(unicef, wb)


# fix mmr class ----
summary(df)
class(df$mmr)

df$mmr = as.numeric(df$mmr)

# create mmr categories variable ----
summarize(df,
          `very low` = quantile(mmr,0.2,na.rm=T),
          low = quantile(mmr,0.4,na.rm=T),
          average = quantile(mmr,0.6,na.rm=T),
          high = quantile(mmr,0.8,na.rm=T),
          `very high` = quantile(mmr,1,na.rm=T))

df = df %>%
  mutate(mmr_cat = case_when(between(mmr,0,8.6) ~ 'Very low',
                   between(mmr,8.6,30.4) ~ 'Low',
                   between(mmr,30.4,102) ~ 'Middle',
                   between(mmr,102,319) ~ 'High',
                   between(mmr,319,785) ~ 'Very high'))

# fix factor variables ----

  # mmr_cat
fct_count(df$mmr_cat)

df = df %>%
  mutate(mmr_group = fct_relevel(mmr_cat,
                                'Very low', 'Low', 'Middle', 'High', 'Very high'))

levels(df$mmr_group)

  # income_group
fct_count(df$income_group)

df = df %>%
  mutate(income_group = fct_relevel(income_group,
                                     'Low income', 'Lower middle income', 
                                     'Upper middle income', 'High income'))

levels(df$income_group)


# select & reorder variables ----
df_ordered = df %>%
  select(country, region, income_group, 
         anc1, anc4, instdel, csec, sab, pncmom, pncnb, 
         mmr, mmr_group)

# alphabetize observations ----
df_alph <- df_ordered[order(df_ordered$country),]

# clean variable names ----
df_clean = df_alph %>%
  rename(facility = instdel,
         sba = sab)

summary(df_clean)





# *** SAVING DATASET *** ----

# final data as a .csv file
write_csv(df_clean, 'maternal_health_2014.csv')

# final data as an .rdata file
save(df_clean, file = 'maternal_health_2014.rdata')










# *** CODEBOOK *** ----
# should be public facing (real name for the codebook)
  # do readme file that explains that this is for an assignment/parameters of the assignment

# Describe project
# Methodology

## Country ----
# Variable name: country
# Variable type: character
# Description: Name of the country

# Countries included: Afghanistan, Austria, Bangladesh, Benin, Bolivia, Brazil, Bulgaria, Cambodia, 
# Cameroon, Chile, China, Costa Rica, Croatia, Cuba, Cyprus, Democratic Republic of the Congo,
# Dominican Republic, Ecuador, Egypt, El Salvador, Estonia, Eswatini, Ethiopia, Finland, Georgia,
# Germany, Ghana, Guinea-Bissau, Guyana, India, Ireland, Japan, Kenya, Kosovo, Kuwait,
# Kyrgyz Republic, Latvia, Lesotho, Malawi, Malaysia, Mexico, Mongolia, Nepal, New Zealand,
# Norway, Oman, Pakistan, Peru, Poland, Portugal, Romania, Samoa, Sao Tome and Principe, Senegal,
# Serbia, Singapore, South Africa, Sri Lanka, State of Palestine, Sudan, Togo, Turkey, 
# Uzbekistan, Viet Nam, Zambia, Zimbabwe

df_clean$country

## Region ----
# Variable name: region
# Variable type: character
# Description: UNICEF reporting region

# Regions included: East Asia and Pacific, Eastern Europe and Central Asia, Eastern and Southern
# Africa, Latin America and the Caribbean, Middle East and North Africa, South Asia, West and
# Central Africa, Western Europe, Not Classified

count(df_clean, region) %>%
  mutate(values = row_number(),
         labels = as_factor(region),
         freq = n,
         .keep = 'none') %>%
  kable()

## Income Group ----
# Variable name: income_group
# Variable type: factor
# Description: World Bank Income Group (2020)

count(df_clean, income_group) %>%
  mutate(values = row_number(),
         labels = as_factor(income_group),
         freq = n,
         .keep = 'none') %>%
  kable()

## Antenatal Care Coverage (at least one visit) ----
# Variable name: anc1
# Variable type: numeric
# Description: Percentage of women (age 15–49) attended at least once 
  # during pregnancy by skilled health personnel.

summarize(df_clean,
          n = n(),
          min = min(anc1, na.rm = T),
          max = max(anc1, na.rm = T),
          median = median(anc1, na.rm = T),
          mean = mean(anc1, na.rm = T)) %>%
  kable(digits = 1L)

## Antenatal Care Coverage (at least four visits) ----
# Variable name: anc4
# Variable type: numeric
# Description: Percentage of women (age 15–49) attended at least four times 
# during pregnancy by any provider.

summarize(df_clean,
          min = min(anc4, na.rm = T),
          max = max(anc4, na.rm = T),
          median = median(anc4, na.rm = T),
          mean = mean(anc4, na.rm = T),
          n = n()) %>%
  kable(digits = 1L)

## Delivered in a Health Facility ----
# Variable name: facility
# Variable type: numeric
# Description: Percentage of deliveries in a health facility.

summarize(df_clean,
          min = min(facility, na.rm = T),
          max = max(facility, na.rm = T),
          median = median(facility, na.rm = T),
          mean = mean(facility, na.rm = T),
          n = n()) %>%
  kable(digits = 1L)

## Delivered via Caesarean Section ----
# Variable name: csec
# Variable type: numeric
# Description: Percentage of deliveries by Caesarian section.

summarize(df_clean,
          min = min(csec, na.rm = T),
          max = max(csec, na.rm = T),
          median = median(csec, na.rm = T),
          mean = mean(csec, na.rm = T),
          n = n()) %>%
  kable(digits = 1L)

## Delivery Assisted by a Skilled Birth Attendant ----
# Variable name: sba
# Variable type: numeric
# Description: Percentage of births delivered by a skilled health personnel 
  # (typically doctor, midwife and.or nurse)

summarize(df_clean,
          min = min(sba, na.rm = T),
          max = max(sba, na.rm = T),
          median = median(sba, na.rm = T),
          mean = mean(sba, na.rm = T),
          n = n()) %>%
  kable(digits = 1L)

## Post-natal Check Up for Mothers ----
# Variable name: pncmom
# Variable type: numeric
# Description: Percentage of women (age 15–49) who received postnatal care within 2 days after birth.

summarize(df_clean,
          min = min(pncmom, na.rm = T),
          max = max(pncmom, na.rm = T),
          median = median(pncmom, na.rm = T),
          mean = mean(pncmom, na.rm = T),
          n = n()) %>%
  kable(digits = 1L)

## Post-natal Check Up for Newborns ----
# Variable name: pncnb
# Variable type: numeric
# Description: Percentage of newborns who have a postnatal contact with a health provider 
  # within 2 days of delivery. 

summarize(df_clean,
          min = min(pncnb, na.rm = T),
          max = max(pncnb, na.rm = T),
          median = median(pncnb, na.rm = T),
          mean = mean(pncnb, na.rm = T),
          n = n()) %>%
  kable(digits = 1L)

## Maternal Mortality Ratio ----
# Variable name: mmr
# Variable type: numeric
# Description: Number of maternal deaths per 100,000 live births.

summarize(df_clean,
          min = min(mmr, na.rm = T),
          max = max(mmr, na.rm = T),
          median = median(mmr, na.rm = T),
          mean = mean(mmr, na.rm = T),
          n = n()) %>%
  kable(digits = 1L)

## Maternal Mortality Ratio Grouping ----
# Variable name: mmr_group
# Variable type: factor
# Description: Quintile groupings of maternal mortality ratio based on the MMRs in the dataset.

count(df_clean, mmr_group) %>%
  mutate(values = row_number(),
         labels = as_factor(mmr_group),
         freq = n,
         .keep = 'none') %>%
  kable()


