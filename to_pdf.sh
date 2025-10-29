#!/bin/bash 

# Create multi-page .pdf from provided .svg files 
#
# .svg files are first exporder to .png using inkscape 
# Then images are put in .pdf with ImageMagick
#
# Parametrization is done by editing variables at the
# beginning of this script.
#
# ------Example usage------
#
# ./to_pdf.sh a.svg b.svg
# To create a 2 page .pdf consisting of files a and b 
#
# ------Troubleshooting------
#
# In case of conversion errors, check /etc/ImageMagick-6/policy.xml
#
# Memory issues - give access to more space:
# <policy domain="resource" name="disk" value="1GiB"/>
#
# Access issues - remove safety guard:
# <policy domain="coder" rights="none" pattern="PDF" />


inkscape_path=/usr/local/bin/Inkscape-1.4.2.AppImage
page_dpi=600
output_pdf_name=output.pdf

mkdir cache

i=0
for file_name in "$@"
do
    $inkscape_path \
        "$file_name" \
        --export-area-page \
        --export-filename="cache/$(printf "%02d\n" "$i").png" \
        --export-dpi=$page_dpi
    ((i+=1))
done

convert cache/*.png $output_pdf_name

read -p "Remove .png files? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

rm -r cache
