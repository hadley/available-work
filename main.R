# Inspired by <https://simonwillison.net/2020/Oct/9/git-scraping/>
library(rvest)
library(gha)
library(httr2)
pkgload::load_all(if (dir.exists("/app")) "/app" else ".")

url <- "http://www.westonlambert.com/available-work"
html <- read_html(url)
products <- find_products(html)
gha_notice("Found {length(products)} products")
if (length(products) == 0) {
  stop("No products found! Did the website change?")
}

cur <- extract_products(products)
gha_notice("Found {sum(!cur$sold_out)} available products")
gha_summary("### Current products\n")
gha_summary(knitr::kable(cur))

data_dir <- Sys.getenv("DATA_DIR", ".")
products_path <- file.path(data_dir, "products.csv")
old <- read.csv(products_path)
write.csv(cur, products_path, row.names = FALSE)

# Find all products that aren't sold out, and I didn't see last time
new <- subset(cur, !sold_out & !link %in% old$link)
gha_notice("Found {nrow(new)} new products")

# if (nrow(new) > 0) {
if (FALSE) {
  gha_notice("Sending notification")
  msg <- paste0(nrow(new), " products available at ", url)
  request("https://ntfy.sh/") |>
    req_url_path("BjFR7fMVkYMSsFrS") |>
    req_body_raw(msg) |>
    req_headers(Title = "Update at Weston Lambert", Click = url) |>
    req_perform()
}
