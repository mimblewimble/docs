# Grin Documentation

## Requirements

Clone repo and navigate to directory:

```bash
git clone --recursive https://github.com/mimblewimble/docs.git
```

### Local

Install the following software:

- [MkDocs](https://www.mkdocs.org/#installation)
- [MkDocs Material theme](https://squidfunk.github.io/mkdocs-material/getting-started/)

Then start the local Mkdocs server:

```bash
mkdocs serve
```

### Container

Start the local MkDocs server:

```bash
docker build -t docs -f Containerfile .
docker run -p 8000:8000 -v ./:/app/:ro docs:latest
```

## Test

Visit `http://localhost:8000` to see live changes.

When ready, push changes to your forked repo and then submit a PR.
