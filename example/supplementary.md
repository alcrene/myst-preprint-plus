---
numbering:
  headings: false    # Ensures references use the section title instead of the number
  figure:
    template: Supp. Figure %s
  table:
    template: Supp. Table %s  
---

(sec:supp-methods)=
# Supplementary Methods

__The Supplementary Information is typeset on a separate page, with its own title, so it can be distributed as a separate document.__

A reference in the supplementary: @kour2014fast.

An equation in the supplementary:

$$\frac{\partial \rho}{\partial t} = D \nabla_x^2 \partial \rho \,.$$ (eq_ficks-2nd-law)

__Supplementary sections are unnumbered: typically they have referenceable titles like “Supplementary Methods”.__


:::{include} lipsum/2.md
:::

:::{include} lipsum/3.md
:::

:::{include} lipsum/2.md
:::

:::{include} lipsum/3.md
:::

:::{include} lipsum/3.md
:::

(sec:supp-figures)=
# Supplementary Figures

__Supplementary figures are prefixed with "Supp."; see @fig:suppfig1.
This can be changed with the `supplementaryprefix` package option.
Supplementary figures are also given the `h` ("here") option by default, to discourage them from floating too far.__

:::{figure} placeholder.*
:label: fig:suppfig1

A supplementary figure.
:::

:::{error}
A current issue ([#2214](https://github.com/jupyter-book/mystmd/issues/2214)) with MyST is that paths in material included in parts is not updated to point to the export directory.
So at the moment one needs to manually copy over supplementary figures to the LaTeX directory and recompile the document for them to be included.

This isn’t too difficult to include in a build script (see the `build.sh` script included in this example), but hopefully a future update will make this unnecessary.
:::

:::{include} lipsum/3.md
:::

:::{include} lipsum/2.md
:::

