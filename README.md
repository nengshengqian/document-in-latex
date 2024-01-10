# document-in-latex
Using Latex to write documents, installed CN Fonts

## Propose
- Latex/texlive
- Support Docker
- Support CN Fonts

## Comming Featrues
- Papper Template

## Generate

You should prepare a docker environment, and run:
`docker run -it nengshengqian/texlive:2023-small-cnfonts bash`,

you can pull this docker image: `docker pull nengshengqian/texlive:2023-small-cnfonts`
### HTML
Using `pandoc` command:
```
pandoc -s your-doc.tex -o your-doc.html --toc
```
### PDF
Using `xelatex` command:
```
xelatex your-doc.tex && xelatex your-doc.tex
```