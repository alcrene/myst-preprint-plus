#! /bin/sh

# MyST build
myst build --tex main.md
# Copy figures in the supplementary to the TeX export directory
ln placeholder.pdf _build/exports/main_tex/
# Switch to the directory containing the generated TeX
cd _build/exports/main_tex/
# Reduce heading levels in the appendix and supplementary by one
# CAUTION: This may break things if you use `\subsection` in your text (eg within verbatim environments)
#csplit main.tex /\\\\appendix/ /\\\\supplementary/
csplit --keep-files main.tex '/^\(\\appendix\|\\supplementary\)/' {*}
mv xx00 main-xx00
sed -i 's/\\subsection/\\section/g' xx*          # NB: Make sure subs are applied
sed -i 's/\\subsubsection/\\subsection/g' xx*    #     from highest to lowest level!
mv main-xx00 xx00
cat xx* > main.tex
# rm xx*
# Replace \href{<url>}{<url>} by \url{<url>}
# (This gives better formatting, and especially better line breaks)
sed -i 's/\\href{\([^}]*\)}{\1}/\\url{\1}/g' main.tex 
# Replace '\ref{#sec:' with '\ref{sec:'
sed -i 's/\\ref{#sec:/\\ref{sec:/g' main.tex
# Make marked tables full width
perl -0777 -pi -e 's/% Next table full width\s*\\begin{table}([\s\S]*?)\\end{table}/\\begin{table*}\1\\end{table*}/g' main.tex
    # The equivalent Python regex would be: re.sub(r"^% Next table full width\s*\\begin{table}([\s\S]*?)\\end{table}", r"\\begin{table*}\1\\end{table*}", tex, flags=re.MULTILINE)
perl -0777 -pi -e 's/% Next figure full width\s*\\begin{figure}([\s\S]*?)\\end{figure}/\\begin{table*}\1\\end{table*}/g' main.tex
# Fix tables being placed inside captions
# This works by finding blocks \begin{tabular}(…)\end{tabular}}, taking care to prevent matches where (…) contains \end{tabular}
# The \s* also removes spurious line breaks, which can cause compile issues, since \caption{} should not contain paragraph breaks
perl -0777 -pi -e 's/\s*\\begin{tabular}((?:(?!\\end{tabular})[\s\S])*?)\\end{tabular}}/}\n\\begin{tabular}\1\\end{tabular}/g' main.tex
# Fix {tabular} being ended by \bigskip without whitespace
perl -0777 -p -e 's/\\bigskip(?!\s)/\\bigskip\n/g' main.tex
# Build the PDF
latexmk -pdf main.tex
# Switch back to the project’s root directory
cd ../../../
# Symlink the compiled PDF from the source directory
ln -sf _build/exports/main_tex/main.pdf ./

# HINT: You can use something like
#           grep -Po "(?<=:::{figure}\s?)[^\s]*" supplementary.md
#       to list all of the figures in the supplementary.
