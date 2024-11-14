# Weston Lambert's available work

This repo demonstrates a [GitHub action](.github/workflows/scrape.yaml) that every 3 hours scrapes Weston Lambert's [available work](http://www.westonlambert.com) page. It records the currently available products to [products.csv](products.csv), and there are any new products that are unsold, sends me a [push notification](https://github.com/hadley/available-work/blob/main/scrape.R#L43-L47) using [ntfy.sh](https://ntfy.sh).

It uses a staged deployment process where [deploy.yaml](.github/workflows/deploy.yml) creates a docker container when you tag a commit. Then [run.yml](.github/workflows/run.yml) checks out that container and runs [scrape.R](scrape.R) every three hours.
