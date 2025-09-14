---
title: A flexible, general-purpose template for preprints, supporting both
  one and two column layouts.
short_title: A flexible, general-purpose template for preprints

abstract: abstract.md
parts:
  # In order to prevent the supplementary from showing up if the template
  # does not define a part for it, we provide it as a separate file.
  # (This exploits the new ability to specify parts as files: https://github.com/jupyter-book/mystmd/pull/1586)
  # Note that it is documented(?) behaviour that for undefined parts, they
  # don’t show up if added by the frontmatter, but *do* show up if added
  # as tagged cells (https://github.com/jupyter-book/mystmd/issues/1246)
  appendix: appendix.md
  supplementary: supplementary.md

bibliography:
  - references.bib

numbering:
  figures:
    template: "fig. %s"
    

exports:
  - format: tex
    template: ../../preprint+
    ### Paper ###
    papersize: letter        # Choose either 'letter' or 'a4'
    two_column: true
    #text_geometry: nature   # 'text_geometry' option can be used to select one of the preconfigured geometries in `preprint+`
    ### Metadata ###
    venue_status: Example document
    status: Beta
    compile_date: frontmatter  # 'frontmatter' will use the date from the frontmatter. Use 'none' to avoid printing the date altogether.
    language: english          # Load babel; babel is not loaded at all if no language is specified
    ### Style ###
    line_numbers: false
    cite_style: numeric            # (passed to biblatex option citestyle)
    bib_style: nature              # (passed to biblatex option bibstyle)
    citep_format: superscript      # (passed to biblatex option autocite)
    supplementary_prefix: "Supp."  # Default value  — Determines the identification label displayed below the figure. The label in used in the text is set by the `numbering` field.
    ### Content ###
    online_link: Link_to_online_version_of_the_paper
    supplementary_link: Instead_of_including_the_Supplementary,_a_link_to_a_permanent_archive_can_instead_be_provided_here.)
---


(sec:intro)=
# Introduction

The original idea for this template was to build upon the [*arXiv (Two Column)* template](https://github.com/myst-templates/arxiv_two_column), adding functionality for producing output which would be more suitable for self-publishing and preparing submissions to journals.

Ultimately this aims to become a best-in-class, all-around default MyST template for writing scientific articles, by providing sufficient configuration options to cover major layout variations. This currently includes:
- selecting either one or two column layouts;
- selecting among a few curated font options;[^fonts][^only-latin]
- using either BibTeX or BibLaTeX to compile references;[^biblatex]
- support for both appendices and supplementary information;
  - _Appendices_ are typeset as part of the article, after the references and all other notices.
  - _Supplementary Information_ is typeset as a separate document, on separate pages and with its own title on the first page. Equations and figures also a prefix like “S” or “Supp.”.

Basically, if there is a template for the journal you are targeting, you should use that.
Otherwise, or if you haven’t yet decided on a target journal, this should be a pretty good fallback.

This template is based on the [preprint+ style](https://github.com/alcrene/latex-preprint-plus), which powers most of the customizability.

[^fonts]: There are many fonts involved in a document—serif, sans-serif, monospace, italic, math…—and they should be chosen so as to be harmonious. The template font options sets all of these at once, based on documented recommendations, so that you get the benefit of font harmonies without having to worry about them.

[^only-latin]: Font options are currently limited to latin fonts.

[^biblatex]: BibLaTeX will generally give better output, esp. regarding URLs and line breaking, but if you intend to submit the generated tex source to a journal, they will probably require BibTeX.

:::{hint}
If your footnotes are missing, check to make sure that you have closed any parts introduced with 
```myst
+++ { "part": ...}
```
with another `+++` separator.
:::

## Basic features and usage

### List of parts

Most paper elements are specified as separate parts.
This allows them to be defined either in the frontmatter, in the main text itself (under a `+++ {"parts": …}` separator), or in a separate file.

- *abstract*
- *acknowledgments*
- *funding*
- *data_availability*
- *code_availability*
- *appendix*
- *supplementary*

The *appendix* and *supplementary* should generally be defined in a separate file, so that their numbering schemes can be customized in the frontmatter.
It is also often convenient to define the abstract in a separate file: this makes it easy for co-authors to edit, and allows other tools to retrieve it more easily (e.g. for a list of publications).

Usually papers will have either an appendix or a supplementary, although the template allows for both.

### Appendix and Supplementary

The *appendix* and *supplementary information* work in the same way.
Usually papers papers only include one, although the template allows to specify both.
The appendix will be typeset as part of the document, just at the very end, whereas the supplementary is typeset as a separate document. (Still in the same PDF, but with separate pages, its own title, etc.)
Layout options for the supplementary are also a bit more spaced, and more flexible with respect to figure placement, to better accommodate the higher figure/text ratios one usually finds in supplementary material.

(In the produced tex, the appendix is introduced with the standard `\appendix` command, whereas the supplementary is introduced with a `\supplementary` command specific to the *preprint+* style.)

Both *appendix* and *supplementary information* should be written in separate files.
Not only is this much easier for authors, but it also allows them to have their own frontmatter where we can adjust numbering.

So for example, we might have in `main.md`:
```myst
---
parts:
  appendix: appendix.md
  supplementary: supplementary.md
exports:
  - format: tex
    supplementary_prefix: "Supplementary"
---
```
then in `appendix.md`:
```myst
---
numbering:
  headings:
    template: Appendix %s
---
```
while in `supplementary.md`:
```myst
---
numbering:
  headings: false
  figure:
    template: Supplementary Figure %s
  table:
    template: Supplementary Table %s  
---
```


As far as I can tell,[^myst-1.6.0] MyST does not allow to change the identification label below figures: [the `numbering` option](https://mystmd.org/guide/cross-references#customizing-numbering-appearance) in the frontmatter only affects how they are referenced in the main text: in the supplementary itself, the figures would still be identified as “Figure 1” instead of “Supplementary Figure 1”.
This template allows to change the identification label via the `supplementary_prefix` option.[^alt-cleveref] 
I hope eventually to deprecate this option, so that the numbering format does not need to be set in two different places.

Note that as of MyST 1.6.0, defining the appendix and supplementary in separate files does cause an annoyance with figures; see below for a workaround.


[^myst-1.6.0]: As of MyST 1.6.0

[^alt-cleveref]: Alternatively, instead of setting the `numbering` option, you could add a postprocessing step which replaces all `Figure~\ref{…}` with `\cref{…}`. Then setting  `supplementary_prefix` would suffice, since the underlying `preprint+` package already configures _cleveref_  to prefix that value to all labels pointing to the supplementary.

## Workarounds

There are still a few limitations or quirks to MyST which may trip an author attempting to achieve an output matching the tex they are used to writing.

Many of these however have relatively simple workarounds which can be applied as a postprocessing step on the generated tex. All of the workarounds listed below are implemented in the [_build.sh_](./blob/main/example/build.sh) script included with this example, which should run on Linux and MacOS. This script essentially does three things:
- Use MyST to build the tex: `myst build --tex main.md`
- Fix the tex with some text substitutions.
- Compile the tex with `latexmk -pdf main.tex`

These issues and workarounds are not specific to this template, although they are specific (or at least more relevant) for publishing scientific results in journals.
It should go without saying that every workaround below is subject to change;
I hope and expect that they will all eventually become obsolete.

(sec:headings)=
# Headings: first level

## Headings: second level

:::{include} lipsum/5.md
:::

$$
\xi _{ij}(t)= {\frac {\alpha _{i}(t)a^{w_t}_{ij}\beta _{j}(t+1)b^{v_{t+1}}_{j}(y_{t+1})}{\sum _{i=1}^{N} \sum _{j=1}^{N} \alpha _{i}(t)a^{w_t}_{ij}\beta _{j}(t+1)b^{v_{t+1}}_{j}(y_{t+1})}}
$$

### Headings: third level
:::{include} lipsum/6.md
:::

#### Headings: fourth level (aka 'Paragraph')
:::{include} lipsum/7.md
:::


(sec:others)=
# Examples of citations, figures, tables, references

:::{include} lipsum/8.md
:::

[@kour2014real;@kour2014fast] and see @hadash2018estimate.

The documentation for citations may be found at <https://mystmd.org/guide/citations#markdown-citations>

Note in particular the difference between textual and parenthetical citations: use the textual form if a citations plays a grammatical role in a sentence.

|               | Markdown          | Output          |
|---------------|-------------------|-----------------|
| Textual       | `@kour2014real`   | @kour2014real   |
| Parenthetical | `[@kour2014real]` | [@kour2014real] |
% MyST workaround: Add a comment after tables to prevent undefined macros


## Figures

:::{include} lipsum/10.md
:::

See @fig:fig1.
Here is how you add footnotes.[^sample-footnote]
Note that footnote markers should always come after punctuation.

We can also refer to elements in the supplementary: 

| Markdown            | Output            |
|---------------------|-------------------|
| `@fig:suppfig1`     | @fig:suppfig1     |
| `@sec:supp-methods` | @sec:supp-methods |
| `[](#sec:supp-figures)`| [](#sec:supp-figures)        |
| `@eq_ficks-2nd-law` | @eq_ficks-2nd-law |
%

[^sample-footnote]: Sample of the first footnote.

:::{include} lipsum/11.md
:::

:::{figure} placeholder.*
:label: fig:fig1

Sample figure caption.
:::

## Tables

The capabilities for tables in MyST are still much more limited compared to LaTeX.
One nice feature is the ability to define the content in an external file, which is then inserted with an [`:::{include}` directive](https://mystmd.org/guide/tables#include-tables-from-file).
The external file can be written in either HTML or LaTeX:[^not-equiv-tables] both will be parsed by MyST internally and output to the requested format.
In additional to being more convenient, this allows for more complex formatting than what the MyST format allows, such as multicolumn cells.[^multicol]

[^multicol]: Using `\multicolumn{2}{l}` in LaTeX, or `<td colspan=2>` in HTML.

::::{table} Sample table title
:label: tab:table

:::{include} sample-table.tex
::::

<!-- :::{raw:latex}
\begin{table}
\caption{Sample table title}
\label{tab:table}
\begin{tabular}{lll}
  \toprule
  \multicolumn{2}{c}{Part}   &               \\
  \cmidrule(r){1-2}
  Name     & Description     & Size ($\mathrm{\mu m}$) \\
  \midrule
  Dendrite & Input terminal  & $\sim$100     \\
  Axon     & Output terminal & $\sim$10      \\
  Soma     & Cell body       & up to $10^6$  \\
  \bottomrule
\end{tabular}
\end{table}
:::
 -->

In my limited experience however, neither HTML nor LaTeX offer a completely satisfactory way of specifying tables. Whereas the HTML table parsing has better support for specifying headings and styling, only the LaTeX parser will properly treat any `$…$` math included in the table.

Indeed, even if the table provided with `:::{include}` is specified in LaTeX, MyST will still parse that data to its internal format and then generate new LaTeX code for the export.
This means that only features recognized by MyST will be included.

This is why in @tab:table, the “Part” heading is not centered above the first two columns, and there is no horizontal rule below the two heading levels, despite those being specified in the source.
As far as I can tell,
- MyST always makes columns of equal width;
- MyST does not have a mechanism for specifying text alignment (it always aligns left);
- MyST does not recognize the booktabs macros `\midrule` and `\cmidrule`.
  (Nor `\hline`, although there is no reason to use `\hline` instead of `\midrule` inside a `{booktabs}` table.)

Therefore, if you have mildly exacting requirements, you may have to use the fallback of wrapping the entire table with a [`:::{raw:latex}` directive](https://mystmd.org/guide/creating-pdf-documents#including-content-with-specific-exports).
This allows you to specify the table however you like, however it has several drawbacks:
- The raw LaTeX obviously cannot be exported to other output formats.
- Since any `\label` commands are not parsed by MyST, it is not possible to reference the table in Markdown — only other raw LaTeX can do so.
## Lists

- Lorem ipsum dolor sit amet
- consectetur adipiscing elit. 
- Aliquam dignissim blandit est, in dictum tortor gravida eget. In ac rutrum magna.

:::{caution} Workaround
As of version 1.6.0, the LaTeX output of `include`-ed tables is someone broken: they get placed inside the caption.

This can be fixed by moving the caption’s closing brace forward;
the included _build.sh_ script includes a regular expression which does this automatically.
:::


<!-- :::{raw:latex}
\section*{Current issues}
:::
These might be due to current bugs or limitations in MyST—hopefully they will be resolved soon. As far as I can tell they are not specific to this template.

- Cross-references to sections always use the template `Heading %s`: it is e.g. not possible to start them with “Section”
- TODO: Table insertion
- External files which are referenced to in parts (such as figures) are not copied over to the build directory (see [issue #2214](https://github.com/jupyter-book/mystmd/issues/2214)).
  + The solution for now is to apply a bit of postprocessing: use MyST to generate the TeX, copy the figures, and then build the PDF ourselves. This is at least easy to automate; see the included _build.sh_ script.
- Parts inserted through the frontmatter are implicitely assumed to be below a heading. Every heading within them is therefore one level deeper, so that currently the highest heading level in the Appendix and Supplementary is `\subsection`.[^subsection]
  + This can also be addressed with some postprocessing, by simple search&replace.[^highest-to-lowest] With a bit more effort it can also be automated; see again the included _build.sh_ script.
- MyST does not used `\url{<url>}` to produce URLs, but instead `\href{<url>}{<url>}`. This is suboptimal for two reasons:
  + It uses the normal text font, instead of the one for URLs (typically a monospaced one).
  + Most importantly, it has very poor line breaking, because the `\hypperef` command is designed to format plain text. The `\url` command in contrast expects a URL, and can be configured to be more liberal with its line breaks.[^xurl]
  + As a workaround, we can replace every `\hyperref` command where the argument is repeated by a `\url` command. See the included _build.sh_ script for a regex which automates this substitution. 
- MyST automatically recognizes URLs; basically anything of the form `text.ext`. Unfortunately this will also catch filenames, which is why _build.sh_ points to an unrelated web page. I don’t know of a way to turn this off, but one workaround is to format file names as code instead: `build.sh`.

[^subsection]: While it is true that there usually is an "Appendix" or "Supplementary Information" at the top of those sections, that is a) not always the case for the appendix, and b) often at the “\part” level, so that sections are still introduced with `\section`. (See e.g. the section on appendices in the [REVTEX Author’s Guide](https://texdoc.org/serve/auguide4-2.pdf/0).)
[^highest-to-lowest]: Just make sure to apply substitutions from highest to lowest level! I.e. do `\subsection` $→$ `\section` first, _then_  `\subsubsection` $→$ `\subsection`.
[^xurl]: This template does this by loading the `xurl` package.
 -->

### Limitations regarding heading numbering and references

MyST is still quirky around section (aka heading) references and possibly enumerators (e.g. for equations).
Settings for figure and table references work as advertised — in particular, their format is easily adjusted by their corresponding `template` field in the frontmatter.

For section references, the first thing to note is that the template options for headings don’t really work: none of the following [frontmatter options](https://mystmd.org/guide/cross-references#numbering) have any effect on the produced LaTeX[^diff-html] as far as I can tell:
```myst
numbering:
  title: false/true
  headings: false/true
  heading_1: true
  heading_2:
    template: Sec %s
```
The _only_ option which has an affect on the numbering of headings is the global `true/false`:
```myst
numbering: true/false
```
If you want to set this, one strategy is to set `numbering: true` in project-level `myst.yml`, and then use the page frontmatter to set any other numbering options, such as the template for figures.
However, as we will see below, you probably want to keep the default (`numbering: false`) and instead explicitly request numbered references.

Note that the `numbering: true/false` only affects the formatting of _cross-references_: The produced tex also introduces sections with `\section{…}`, and therefore sections are always numbered in the produced PDF.[^unnumbered-sections]

[^diff-html]: The `numbering` options do seem to have an effect on HTML output, so you may still want to set them if you aim to export both to PDF and HTML.

To understand how cross-references come out in the final document, and how that depends on the `numbering` option, consider the @tab:sec-refs which shows the output update for each form of a markdown reference.

% Next table full width
:::{table} Section cross-references
:label: tbl:sec-refs
:width: 100%

| Markdown                       | `numbering: false`         | `numbering: true` |
|--------------------------------|----------------------------|-------------------|
| `[](sec:intro)`             | Introduction      | {numref}`Heading %s<#sec:intro>` |
| `[](#sec:intro)`            | Introduction      | {numref}`Heading %s<#sec:intro>` |
| `[%s](#sec:intro)`          | ??                | {numref}`Heading %s<#sec:intro>` |
| `[{name}](#sec:intro)`      | Introduction      | {numref}`Heading %s<#sec:intro>` |
| `[Sec. %s](#sec:intro)`     | Sec. ??                    | {numref}`Heading %s<#sec:intro>` |
| `[Sec. {name}](#sec:intro)` | Sec. Introduction | {numref}`Heading %s<#sec:intro>` |
| `@sec:intro`                | Introduction      | {numref}`Heading %s<#sec:intro>` |
| ``{numref}`sec:intro` ``    | Introduction      | {numref}`Heading %s<#sec:intro>` |
| ``{numref}`#sec:intro` ``   | {numref}`#sec:intro`      | {numref}`#sec:intro` |
| ``{numref}`Sec. %s <sec:intro>` `` | Sec. ?? | {numref}`Heading %s<#sec:intro>` |
| ``{numref}`Sec. %s <#sec:intro>` `` | {numref}`Sec. %s<#sec:intro>` | {numref}`Sec. %s<#sec:intro>` |
| ``{numref}`Sec. {name} <#sec:intro>` `` | Sec. name | Sec. name |
:::


<!-- Uncomment the table below to check correctness of the second and third columns above.

| Markdown                                | Result                            |
|-----------------------------------------|-----------------------------------|
| `[](sec:intro)`                         | [](sec:intro)                           |
| `[](#sec:intro)`                        | [](#sec:intro)                           |
| `[%s](#sec:intro)`                      | [%s](#sec:intro)                         |
| `[{name}](#sec:intro)`                  | [{name}](#sec:intro)                     |
| `[Sec. %s](#sec:intro)`                 | [Sec. %s](#sec:intro)                    |
| `[Sec. {name}](#sec:intro)`             | [Sec. {name}](#sec:intro)                |
| `@sec:intro`                            | @sec:intro                        |
| ``{numref}`sec:intro` ``                | {numref}`sec:intro`               |
| ``{numref}`#sec:intro` ``               | {numref}`#sec:intro`              |
| ``{numref}`Sec. %s <sec:intro>` ``      | {numref}`Sec. %s<sec:intro>`      |
| ``{numref}`Sec. %s <#sec:intro>` ``     | {numref}`Sec. %s<#sec:intro>`     |
| ``{numref}`Sec. {name} <#sec:intro>` `` | {numref}`Sec. {name}<#sec:intro>` |
 -->
%

:::{important} Workaround
With some of these forms, and in particular the otherwise most reliable form ``{numref}`Sec. %s <#sec:intro>` ``, MyST will incorrectly include a hashtag `#` in the produced LaTeX. This needs to be removed by a postprocessing step to get the results given in @tbl:sec-refs.

The _build.sh_ includes a `sed` command performing this substitution.
:::

When writing, there are basically three uses we need to account for: numbered references, numbered references at the beginning of a sentence,[^sentence-begin] and named references. 
Personally I find it a bit annoying that the only reliable way to get section numbers, the `{numref}` role, is also the most verbose.
So for my own writing I use a preprocessor which first converts the shorter form into a longer form using `{numref}`; if you don’t want to do this, just use the long form directly.

% Next table full width
:::{table} Section reference cheat sheet

| What I want | Short form   | Robust (long) form | Output |
|-------------|--------------|--------------------|--------|
| normal ref  | `@sec:intro` | ``{numref}`section %s <#sec:intro>` `` | section 1 |
|             | `[](#sec:intro)` | ``{numref}`section %s <#sec:intro>` `` | section 1 |
| at sentence start | `[Section %s](#sec:intro)` | ``{numref}`Section %s <#sec:intro>` `` | Section 1 |
| name ref    | `[{name}](#sec:intro)`[^nameref] | `[{name}](#sec:intro)` (no change) | Introduction |
:::

Having the default forms produce `section %s` is consistent with standard LaTeX usage.[^namecref]

[^sentence-begin]: Typographic conventions dictate that the first word of a sentence should always be capitalized and never abbreviated.

[^namecref]: For example, *clever*’s basic `\cref{}` command will produce something close to `section %s`, where the longer `\namecref{}` is used for name references.

+++ { "part": "author_contributions" }

AR conceived of and implemented this LaTeX template `preprint+`.
AR conceived of and implemented this MyST template based on `preprint+`.

+++ { "part": "data_availability" }

All data generated in this study has been uploaded to…


+++ { "part": "code_availability" }

All code used to generate the figures in this study is archived…

+++ { "part": "acknowledgments" }

We thank John Johnson and Mary Musterfrau for helpful discussions.

+++ { "part": "funding" }

The authors thank the Global Foundation for Template Research for financial support.

+++