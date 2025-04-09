find_products <- function(html) {
  html |>
    html_element("#productList") |>
    html_elements("a")
}

extract_products <- function(products) {
  data.frame(
    title = products |> html_element(".product-title") |> html_text(),
    price = products |>
      html_element(".product-price") |>
      html_text() |>
      gsub("[$,]", "", x = _) |>
      as.numeric(),
    sold_out = !(products |>
      html_element(".sold-out") |>
      html_text() |>
      is.na()),
    link = html_attr(products, "href")
  )
}
