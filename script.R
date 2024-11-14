### TALIS ASPIRE LINK CHECKER ###

# This R project contains the script to take a .csv file and check the links.
# Created by Lara Skelly, last updated 2024-03-19, 10:08.

# Note that the .csv title needs to be changed to reflect the correct list.
# Secondly, the necessary column heading needs to be change to be one word, lowercase.

################################################################################

# Load libraries
library(httr)

# Read in .csv into a dataframe
full_list <- read.csv("all_list_items_2024_03_19.csv")

# Remove empty or NA URLs
full_list <- full_list[!is.na(full_list$web_address) & full_list$web_address != "", ]

# Function to check if a link is working
check_link <- function(link, counter) {
  response <- try(GET(link), silent = TRUE)
  if (!inherits(response, "try-error")) {
    status <- status_code(response)
  } else {
    status <- NA  # Return NA if there was an error accessing the link
  }
  print(paste("URL:", counter, "- Status:", status))
  return(status)
}

# Check each link
results <- sapply(seq_along(full_list$web_address), function(i) {
  check_link(full_list$web_address[i], i)
})

# Add results to dataframe
full_list$status_code <- results

write.csv(full_list, file = "all_list_items_links_checked.csv", row.names = FALSE, col.names = TRUE)