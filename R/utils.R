data_path <- function(...) {
  file.path(data_dir(), ...)
}

data_dir <- function() {
  data_dir <- Sys.getenv("DATA_DIR")
  if (data_dir != "") {
    return(data_dir)
  }

  if (!dir.exists("data")) {
    system("git worktree add data data")

    con <- file(".gitignore", open = "a")
    on.exit(close(con))
    writeLines("data/", con)
  } else {
    system("git -C data pull origin")
  }
  "data"
}

has_env <- function(name) {
  Sys.getenv(name) != ""
}

set_commit_message <- function(value) {
  writeLines(
    paste0("commit_message=", value),
    Sys.getenv("GITHUB_OUTPUT")
  )
}

action_url <- function() {
  paste0(
    "https://github.com/",
    Sys.getenv("GITHUB_REPOSITORY"),
    "/actions/runs/",
    Sys.getenv("GITHUB_RUN_ID")
  )
}
