# xllify-build

[xllify.com](https://xllify.com) is easiest way to add very high performance custom functions to Microsoft Excel. It takes functions implemented as Luau scripts and compiles them into custom functions packaged as an .xll Excel add-in. You can sell, distribute and deploy this .xll however you wish.

Note that currently only Microsoft Excel on Windows is supported. Mac support will involve some (!) compromises, but may follow if there's demand.

There's a [starter template repository](https://github.com/acornsoftuk/xllify-starter) to help you get started in under a minute.

## Support

Drop an email to [support@xllify.com](mailto:support@xllify.com).

## Usage

Here is a workflow to get you started with this action. It compiles [black_scholes.luau], [hello.luau](./hello.luau) and [the_answer.luau](./the_answer.luau) into a ready to run .xll add-in named `hello.xll`.

After the build has completed, it is available in your workspace at the path held in `${{ steps.xllify.outputs.xll_path }}`. A common approach is to attach it to a release, as is done below.

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
        uses: acornsoftuk/xllify-build@v0.0.0 # use version
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

- .xll files are not signed and can only run from safe locations. xllify XLLs may trigger a warning when you load them into Excel, depending upon your environment. This is all explained here: https://support.microsoft.com/en-gb/topic/excel-is-blocking-untrusted-xll-add-ins-by-default-1e3752e2-1177-4444-a807-7b700266a6fb about ways to work around this for now. Examples of using your own signing certificates are coming soon.
