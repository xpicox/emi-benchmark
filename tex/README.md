## Generate the png

Requires:
- running `pdflatex` with option `-shell-escape`
- the `convert` utility from `imagemagick`

```bash
pdflatex -file-line-error -shell-escape "emi-framework.tex"
```
