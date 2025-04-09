library(rvest)

test_that("find_products returns empty list if no products found", {
  html <- minimal_html("")
  products <- find_products(html)
  expect_equal(length(products), 0)
})

test_that("find_products correct length", {
  html <- minimal_html(
    '
    <div id="productList">
      <ul>
        <li><a href="product1">Product 1<span></li>
        <li><a href="product2">Product 2<span></li>
      </ul>
    </div>
  '
  )
  products <- find_products(html)
  expect_equal(length(products), 2)

  extract_products(products)
})

test_that("can extract title, price, and link", {
  html <- minimal_html(
    '
    <div id="productList">
      <ul>
        <li><a href="product1">
          <span class="product-title">Product 1</span>
          <span class="product-price">$2,000</span>
        </a></li>
        <li><a href="product2">
          <span class="product-title">Product 2</span>
          <span class="product-price">$3,000</span>
        </a></li>
      </ul>
    </div>
  '
  )
  products <- extract_products(find_products(html))
  expect_equal(products$title, c("Product 1", "Product 2"))
  expect_equal(products$price, c(2000, 3000))
  expect_equal(products$link, c("product1", "product2"))
})

test_that("can extract sold out", {
  html <- minimal_html(
    '
    <div id="productList">
      <ul>
        <li><a href="product1">
          <div class="product-mark sold-out">sold out</div>
        </a></li>
        <li><a href="product2">
        </a></li>
      </ul>
    </div>
  '
  )
  products <- extract_products(find_products(html))
  expect_equal(products$sold_out, c(TRUE, FALSE))
})
