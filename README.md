# docs-to-pdf

PDF generator from dependency documentation

## How to start

1. Add a devDependencies, ie: `npm i -D elysia`
2. Clone the corresponding documentation for this devDependencies but make sure the name of the folder matches the devDependencies name, ie: `cd projects && git clone https://github.com/elysiajs/documentation elysia`
3. Run the generator `./scripts/generate_pdf.sh` or `npm start`

## Important

- Documentation repositories should have to same structure: `.md` files should be contained into a `/docs` folder.
