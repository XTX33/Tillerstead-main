# GitHub Pages deployment notes

The GitHub Actions workflow `.github/workflows/pages.yml` deploys the built site using `actions/deploy-pages@v4`, which requires the repository's **Pages source** to be set to *GitHub Actions* and the default `GITHUB_TOKEN` to have the `pages: write` permission. When Pages is disabled or pointed at another source, the `Deploy to GitHub Pages` job exits almost immediately with the "workflow is not authorized to deploy to GitHub Pages" error and shows up as a failure after roughly a second.

Enable Pages for this repo by going to **Settings → Pages** and selecting **GitHub Actions** as the source. Once enabled, rerunning the workflow will allow the `deploy` job to publish the `github-pages` artifact produced by the `build` job.
