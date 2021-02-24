REM rd /s /q tmp
asciidoctor-pdf -r asciidoctor-diagram -a pdf-theme=./src/tmf-pdf-theme.yml -a pdf-fontsdir=src/fonts;GEM_FONTS_DIR -D tmp ./src/IG1228.adoc
