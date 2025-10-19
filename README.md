# xllify-build

Companion action for [xllify.com](https://xllify.com) - open beta, see [terms of service](https://xllify.com/terms.html)

## Overview

[xllify.com](https://xllify.com) is easiest way to add custom functions to Microsoft Excel. It takes functions implemented in Luau scripts and compiles them into custom functions packaged as an .xll Excel add-in. You can sell, distribute and deploy this .xll however you wish.

After a successful build, the .xll file is downloaded to your workspace for you to copy somewhere. In the below example it is attached to a release.

Note that currently only Microsoft Excel on Windows is supported. Mac support will involve some compromises, but may follow if there's demand.

## Support

Drop an email to [support@xllify.com](mailto:support@xllify.com).

## Usage

Here is a workflow to get you started with this action. It compiles [hello.luau](./hello.luau) and [the_answer.luau](./the_answer.luau) into a ready to run .xll add-in named `hello.xll`.

To test out your scripts first (advisable), either use the [online editor](https://app.xllify.com/editor) or the [local environment](https://github.com/acornsoftuk/xllify-local).

After the build has completed, it is downloaded to your workspace at the path held in `${{ steps.xllify.outputs.xll_path }}`. A common approach is to attach it to a release, as is done below.

```yaml
name: Build XLL Add-in

on:
  push:
    tags:
      - "v*"

jobs:
  build:
    runs-on: windows-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Build XLL with xllify
        id: xllify
        uses: acornsoftuk/xllify-build@main # or @vX
        with:
          xll_filename: hello.xll
          luau_scripts: |
            hello.luau
            the_answer.luau
            black_scholes.luau
          xllify_key: ${{ secrets.XLLIFY_KEY }}

      - name: Upload XLL to release
        uses: softprops/action-gh-release@v1
        with:
          files: ${{ steps.xllify.outputs.xll_path }}
```

## Inputs

### `xll_filename` (required)

Output XLL filename (e.g., `my_addin.xll`).

### `luau_scripts` (required)

Space or newline-separated list of Luau file paths relative to your repository root.

## Outputs

### `xll_path`

Path to the built XLL file that has been downloaded to your workspace.

## Caveats

- .xll files are not signed. This may trigger a warning when you load them into Excel, depending upon your environment. See https://support.microsoft.com/en-gb/topic/excel-is-blocking-untrusted-xll-add-ins-by-default-1e3752e2-1177-4444-a807-7b700266a6fb about ways to work around this for now. Support using your own signing certificates is coming soon.
