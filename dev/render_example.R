# dev/render_example.R

# Ensure package is loaded (so your template is available)
devtools::load_all(quiet = TRUE)

# Paths
rmd_in   <- here::here("dev", "chrisdoc_example.Rmd")
pdf_name <- "chrisdoc_example.pdf"
dest_dir <- here::here("inst", "examples")
dest_pdf <- file.path(dest_dir, pdf_name)

# Scratch directory for all the mess (tex, figures, logs, etc.)
tmp_out <- fs::path_temp("chrisdoc_render")
fs::dir_create(tmp_out)

# Render to the scratch dir, and avoid keeping .tex
res <- rmarkdown::render(
  input             = rmd_in,
  output_file       = pdf_name,               # name only
  output_dir        = tmp_out,                # all outputs land here
  intermediates_dir = tmp_out,                # keep knitr junk here too
  output_options    = list(keep_tex = FALSE), # don't keep .tex
  clean             = TRUE,                   # delete pandoc intermediates
  quiet             = TRUE,
  envir             = new.env(parent = globalenv())
)

# Ensure destination exists, then copy JUST the PDF
fs::dir_create(dest_dir)
fs::file_copy(res, dest_pdf, overwrite = TRUE)

message("Rendered to ", dest_pdf)

# Optional: nuke the scratch dir (comment this out if you want to inspect logs)
# fs::dir_delete(tmp_out)



library(magick)

imgs <- image_read_pdf("inst/examples/chrisdoc_example.pdf", density = 200) # rasterise

# write selected pages
image_write(imgs[1], path = "man/figures/template_title.png", format = "png")
image_write(imgs[2], path = "man/figures/template_body.png",  format = "png")
image_write(imgs[10], path = "man/figures/template_lorem.png",  format = "png")
image_write(imgs[5], path = "man/figures/template_figures.png",  format = "png")
image_write(imgs[8], path = "man/figures/template_tables.png",  format = "png")
