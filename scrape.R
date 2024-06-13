# Inspired by <https://simonwillison.net/2020/Oct/9/git-scraping/>
library(rvest)

url <- "http://www.westonlambert.com/available-work"
html <- read_html(url)

products <- html |>
  html_element("#productList") |>
  html_elements("a")

if (length(products) == 0) {
  stop("No products found! Did the website change?")
}

cur <- data.frame(
  title = products |> html_element(".product-title") |> html_text(),
  price = products |> html_element(".product-price") |> html_text() |>
    gsub("[$,]", "", x = _) |>
    as.numeric(),
  sold_out = products |> html_element(".sold-out") |> html_text(),
  link = html_attr(products, "href")
)

out <- Sys.getenv("GITHUB_STEP_SUMMARY")
if (out == "") out <- stdout()
con <- file(out)
cat("### Current products\n", file = con)
writeLines(knitr::kable(cur), con)
close(con)

cat(sprintf("::notice title=Scraping::Found %i products\n", nrow(cur)))

old <- read.csv("products.csv")
write.csv(cur, "products.csv", row.names = FALSE)

# Find all products that aren't sold out, and I didn't see last time
new <- subset(cur, is.na(sold_out) & !link %in% old$link)
cat(sprintf("::notice title=Scraping::Found %i new products\n", nrow(new)))
if (nrow(new) > 0) {
  msg <- paste0(nrow(new), " products available at ", url)
  request("https://ntfy.sh/") |>
    req_url_path("BjFR7fMVkYMSsFrS") |>
    req_body_raw(msg) |>
    req_headers(Title = "Update at Weston Lambert", Click = "https://google.com") |>
    req_perform()
}
