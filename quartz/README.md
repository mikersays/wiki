# Quartz publishing

This directory configures [Quartz 4](https://quartz.jzhao.xyz) to publish each vault in the repo as its own static site. Obsidian still works the same way locally — Quartz just reads the same markdown when building for the web.

## Layout

- `quartz.config.ts` — Quartz site config. `pageTitle` and `baseUrl` come from env vars set by `build.sh`, so one config builds every vault.
- `quartz.layout.ts` — page layout (header / sidebar / footer components).
- `build.sh` — clones Quartz to a gitignored `.quartz-build/`, copies our config in, then builds each vault into `public/<vault>/` and writes a small `public/index.html` listing them.

## Local preview

```bash
./quartz/build.sh        # build every vault
./quartz/build.sh ufo    # build just the ufo vault
python3 -m http.server --directory public 8080
```

Then open http://localhost:8080.

## Deploy

`.github/workflows/pages.yml` runs `build.sh` on every push to `main` that touches a vault's `wiki/`, the `quartz/` config, or the workflow itself, then publishes `public/` to GitHub Pages.

Enable Pages once: **Repo → Settings → Pages → Source = GitHub Actions**. After the first successful run the site is at `https://<owner>.github.io/<repo>/<vault>/`.

## Adding a new vault

No Quartz changes needed. Create the vault per the top-level `CLAUDE.md` (`<vault>/wiki/`, `<vault>/raw/`, etc.) and `build.sh` will pick it up on the next push.

## Pinning Quartz

`build.sh` pins Quartz via `QUARTZ_REF` (default: a v4 release tag). Override with `QUARTZ_REF=v4.6.0 ./quartz/build.sh` to upgrade. If upstream changes the config schema, sync `quartz.config.ts` / `quartz.layout.ts` against the new upstream defaults.
