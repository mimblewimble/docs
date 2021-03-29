# Grin Documentation

## Requirements

- MkDocs
- MkDocs Material theme

## Build

Clone repo and navigate to directory:

```bash
git clone --recursive https://github.com/mimblewimble/docs.git
```

### Local

Start the local server:

```bash
mkdocs serve
```

### Container

Start the local server:

```bash
docker build -t docs -f Containerfile .
docker run -p 8000:8000 -v ./:/app/:ro docs:latest
```

## Test

Visit `http://localhost:8000` to see live changes.

When ready, push changes to your forked repo and then submit a PR.
