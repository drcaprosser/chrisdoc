devtools::document()
devtools::install()

# devtools::install()
source("dev/render_example.R")

devtools::build_readme()
# usethis::use_version("dev")

# usethis::use_version("minor")
# usethis::use_version("patch")
