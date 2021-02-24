#!/bin/sh 

############################################################
# This script is for locally testing the rendering in pdf
# of the asciidoc files.
# 
# This script is not used in the Github workflow
# 
###########################################################

TEMP=tmp
HTML_OUT=out/html
PDF_OUT=./tmp
ROOT_ADOC=./src/IG1228.adoc
USE_CASES="*"
OUT_FORMAT="all"

usage()
{
	echo "usage: render.sh [-u use_case_number] [-f  pdf | html ]"
	echo "usage: render.sh -c"
	exit 2
}

set_part()
{
	echo "set_part "$1
	if [ ! -z $1 ] && [ $1 -gt 0 ] && [ $1 -lt 8 ]
	then
		USE_CASES=$1
	else
		usage
	fi
}

set_format()
{
	case $1 in
		pdf) 
			OUT_FORMAT=$1 ;;
		html)
			OUT_FORMAT=$1 ;;
		*)
			usage
	esac
}

clean()
{
	rm -rf $TEMP
	rm -rf out
	exit 0
}


# render guidelines in PDF
render_pdf()
{
	asciidoctor-pdf -r asciidoctor-diagram \
		-a pdf-theme=./src/tmf-pdf-theme.yml \
		-a pdf-fontsdir="./src/fonts;GEM_FONTS_DIR" \
		-D ${PDF_OUT} \
		${ROOT_ADOC}
}

copy_images()
{
	find src -name "*.$1" | while read file_name
	do
		dest_file_name=${HTML_OUT}/`echo $file_name | cut -d'/' -f2-`
		mkdir -p `dirname $dest_file_name`
		cp $file_name $dest_file_name
	done
}

# render guidelines in HTML
render_html()
{
	asciidoctor -r asciidoctor-diagram \
		-a toc=left \
		-D out/html \
		${ROOT_ADOC}

	if [ ! -d ${HTML_OUT}/images ]
	then
		mkdir -p ${HTML_OUT}/images
	fi
	copy_images png
	copy_images jpg
}


# main

while getopts 'hcp:f:' opt
do
	case $opt in
		c) clean ;; 
		h) usage ;; 
		p) set_part $OPTARG ;;
		f) set_format $OPTARG ;;
	esac
done


case $OUT_FORMAT in
	pdf) render_pdf ;;
	html) render_html ;;
	all)
		render_pdf
		render_html
		;;
	*)
		usage
esac

