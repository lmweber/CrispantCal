CrispantCal
===========

<!---
### To update:

* Link to new website

* move some info below to website (local installation instructions etc)

* mention that website files are included in the repository



### Previous info below...
-->

Web tool to calculate optimal injection mix volumes for CRISPR-Cas9 experiments.

Developed using the Shiny web application framework for R, and hosted online using the ShinyApps.io service.

For more details on how to use the tool, and details on the calculations, see the Information section on the main page of the Shiny app.


### How to access

The tool can be accessed in two ways:

* In a web browser (desktop or mobile) at the following address: https://lmwebr.shinyapps.io/CrispantCal/

* Within R/RStudio, by installing and running from this GitHub repository using the command `runGitHub("lmwebr/CrispantCal")`. This requires the `shiny` package to be installed and loaded first, which can be done with the commands `install.packages("shiny")` and `library("shiny")`.

If you are not familiar with R, we highly recommend RStudio as a user-friendly editor and development environment. RStudio can be downloaded from http://www.rstudio.com/. Before you install RStudio, you also need to install R itself, which can be downloaded from http://cran.r-project.org/. Both R and RStudio are free. The RStudio website also includes links to tutorials and online learning resources on R programming at http://www.rstudio.com/resources/training/online-learning/.

Once you have installed R and RStudio, open RStudio and paste the commands above into the "Console" window, which should be on the left or in the bottom left corner of the screen (in the default layout). The CrispantCal tool should then launch in a new window or in the "Viewer" pane on the right.


### Authors

Developed by Lukas M. Weber, Jonas Zaugg, Anastasia Felker, and Christian Mosimann (Mark D. Robinson and Christian Mosimann labs), Institute of Molecular Life Sciences, University of Zurich.


<!---
### References

Burger et al. (2014), *Crispants: somatic mutagenesis with active CRISPR-Cas9 complexes in zebrafish*, submitted.
-->
