# 03_NER (named entity recognition)
# with the "entity" package: https://github.com/trinker/entity

# if (!require("pacman")) install.packages("pacman")
# pacman::p_load_gh("trinker/entity")

library(entity)

# write a sentence with places
my_sentence <- "I arrived in Rio de Janeiro after having visited New York, Italy and France"

# find the locations in the sentence
location_entity(my_sentence)

# try other sentences
my_sentence <- "Sono arrivato a Rio de Janeiro dopo aver visitato New York, l'Italia e la Francia"
location_entity(my_sentence)

my_sentence <- "..."
location_entity(my_sentence)
