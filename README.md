# Weston Lambert available work

This repo demonstrates a [GitHub action](.github/workflows/scrape.yaml) that every 3 hours scrapes Weston Lambert's [available work](http://www.westonlambert.com) page. It records the currently available products to [products.csv](products.csv), and there are any new products that are unsold, sends me a [push notification](https://github.com/hadley/available-work/blob/main/scrape.R#L43-L47) using [ntfy.sh](https://ntfy.sh).
