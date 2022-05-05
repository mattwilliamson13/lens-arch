library(googledrive)
options(
  gargle_oauth_cache = ".secrets",
  gargle_oauth_email = TRUE
)


# Download NEON Summary ----------------------------------------------------------

folder_url <- "https://drive.google.com/drive/u/1/folders/1YDuPkvVterhf6KTvduLK5sO7km1RPDeS"
folder <- drive_get(as_id(folder_url))

gdrive_files <- drive_ls(folder)
#have to treat the gdb as a folder and download it into a gdb directory in order to deal with the fact that gdb is multiple, linked files
lapply(gdrive_files$id, function(x) drive_download(as_id(x), 
                                                   path = paste0(here::here("data/original/"), gdrive_files[gdrive_files$id==x,]$name), overwrite = TRUE))


# Download NEON boxes -----------------------------------------------------


folder_url <- "https://drive.google.com/drive/folders/1CH-W8ksD5y6PxNQUrzcSyANQ5TOTTN5Q"
folder <- drive_get(as_id(folder_url))

gdrive_files <- drive_ls(folder)
#have to treat the gdb as a folder and download it into a gdb directory in order to deal with the fact that gdb is multiple, linked files
lapply(gdrive_files$id, function(x) drive_download(as_id(x), 
                                                   path = paste0(here::here("data/original/"), gdrive_files[gdrive_files$id==x,]$name), overwrite = TRUE))
