# Inspired by <https://simonwillison.net/2020/Oct/9/git-scraping/>
library(rvest)
library(gha)
library(httr2)

url <- "http://www.westonlambert.com/available-work"
html <- read_html(url)

products <- html |>
  html_element("#productList") |>
  html_elements("a")
gha_notice("Found {length(products)} products")

if (length(products) == 0) {
  stop("No products found! Did the website change?")
}

cur <- data.frame(
  title = products |> html_element(".product-title") |> html_text(),
  price = products |> 
    html_element(".product-price") |> 
    html_text() |>
    gsub("[$,]", "", x = _) |>
    as.numeric(),
  sold_out = !(products |> html_element(".sold-out") |> html_text() |> is.na()),
  link = html_attr(products, "href")
)
gha_notice("Found {sum(!cur$sold_out)} available products")

gha_summary("### Current products\n")
gha_summary(knitr::kable(cur))

old <- read.csv("data/products.csv")
write.csv(cur, "data/products.csv", row.names = FALSE)

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
