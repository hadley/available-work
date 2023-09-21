# Inspired by <https://simonwillison.net/2020/Oct/9/git-scraping/>

library(rvest)

url <- "http://www.westonlambert.com/available-work"

html <- read_html(url)

products <- html |>
  html_element("#productList") |>
  html_elements("a")

df <- data.frame(
  title = products |> html_element(".product-title") |> html_text(),
  price = products |> html_element(".product-price") |> html_text() |>
    gsub("[$,]", "", x = _) |>
    as.numeric(),
  sold_out = products |> html_element(".sold-out") |> html_text()
)

write.csv(df, "products.csv", row.names = FALSE)


