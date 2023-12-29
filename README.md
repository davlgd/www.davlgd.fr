# davlgd's website 
This repository contains files & tools used to build my personal website.
## Generate static files
This website uses `markdown-styles` as a static generator. You can install it through `npm`: 
```
npm i -g markdown-styles
```
Use this script to generate stylized HTML pages in `src/` folder from Markdown files:
```
./toMD.sh path_to/file.md
```
## Deploy to an S3 compatible object storage service
If `MinIO Client` and a bucket are setup, define values in `deploy.sh` and use it to publish the website: 
```
./deploy.sh
```
This website is hosted on [Cellar from Clever Cloud](https://www.clever-cloud.com/product/cellar-object-storage/), but you can use any S3 static compatible service.
## Deploy with GitHub Action
This repository contains [a GitHub Action workflow](.github/workflows/deploy-cellar.yml) to publish the website when: 
- There is a push or a PR on the `main` branch
- One or more files have been modified in the `src/` folder
- Or if you ask for a manual deployment

Env var and `ACCESS_KEY` / `SECRET_KEY` repository secrets should be configured for this action to work.
