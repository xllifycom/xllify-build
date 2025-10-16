# xllify-build

Companion action for [xllify.com](https://xllify.com) - open beta launching 17th October 2025 

## Overview

[xllify.com](https://xllify.com) is easiest way to add custom functions to Microsoft Excel. It is a build API that takes scripts and makes them into custom functions packaged as an .xll Excel add-in.

From 17th October 2025 can [sign up to xllify here](https://app.xllify.com) with your GitHub login. From here you can generate an API key use in the action, as detailed below. Note that currently you can only build from repos owned by your GitHub user. If you're a member of an organization these repos are not yet supported (but will be, soon.)

When running this action in your repo, the scripts are compiled, signed and submitted to the xllify build API. After a successful build, the .xll file is downloaded to your workspace for you to copy somewhere. In the below example it is simply attached as a workflow artifact.

## Usage

Here is a workflow to get you started with this action. It compiles [hello.luau](./hello.luau) into a ready to run .xll add-in named `hello.xll`. You don't need to worry about a Windows runner to build this, it's all handled by xllify.

After the build has completed, it is downloaded to your workspace at the path held in `${{ steps.xllify.outputs.xll_path }}`. A common approach is to attach it to a release, as is done below.

```yaml
name: Demo XLL build

permissions:
  contents: write

on:
  release:
    types: [published]

jobs:
  build:
    name: xllify and publish
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: xllify Remote Build
        id: xllify
        uses: acornsoftuk/xllify-build@v0.2.0-beta
        with:
          xll_filename: hello.xll
          luau_files: |
            hello.luau
            the_answer.luau
          xllify_key: ${{ secrets.XLLIFY_KEY }}

      # The built .xll is now in your workspace. It is common to upload it as a release.

      - name: Upload XLL to release
        if: startsWith(github.ref, 'refs/tags/')
        run: |
          TAG_NAME="${GITHUB_REF#refs/tags/}"
          echo "Uploading ${{ steps.xllify.outputs.xll_path }} to release $TAG_NAME..."
          gh release upload "$TAG_NAME" "${{ steps.xllify.outputs.xll_path }}" --clobber
          echo "Successfully uploaded XLL to release $TAG_NAME"
        env:
          GH_TOKEN: ${{ github.token }}
```

## Inputs

### `xll_filename` (required)

Output XLL filename (e.g., `my_addin.xll`).

### `luau_files` (required)

Space or newline-separated list of Luau file paths relative to your repository root.

### `xllify_key` (required)

Your xllify API key. Get this from app.xllify.com and add it to your repository secrets.

### `xllify_api_endpoint` (optional)

xllify build API endpoint URL. You won't need to change this unless using on-prem.

## Outputs

### `xll_path`

Path to the built XLL file that has been downloaded to your workspace.

## Caveats

- In alpha, built .xll files are not signed. This can trigger a warning. See https://support.microsoft.com/en-gb/topic/excel-is-blocking-untrusted-xll-add-ins-by-default-1e3752e2-1177-4444-a807-7b700266a6fb about ways to work around this for now
