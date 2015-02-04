# helper functions and default values


# default value for molar mass of tracrRNA and UUUUU-end
tracrRNA_UUUUU_default <- 25981.5  # [g/mol]


# Cas9 default values
Cas9_defaults <- list("MJ922 - Cas9p GFP"     = c(191.2, 2.97, 1.40, 100),
                      "MJ923 - Cas9p mCherry" = c(190.0, 5.54, 0.75, 150))#,
#####                      "MJ844 - Cas9 flag"     = c(161.3, 4.07, 1.00, 100),
#####                      "MJ847 - dCas9 flag"    = c(161.2, 2.9,  1.30, 100))
##### [removed for public version]


# function to calculate gRNA volumes
f_gRNA_vol <- function(gRNA_molarMass,gRNA_massConc,
                       Cas9_molarMass,Cas9_massConc,
                       Cas9_vol) {#####,
#####                       two_gRNA_samples) {
##### [removed for public version]
  # convert concentrations
  gRNA_molarConc <- ( gRNA_massConc / 1000 ) / gRNA_molarMass  # [mol/L]
  Cas9_molarConc <- Cas9_massConc / ( Cas9_molarMass * 1000 )  # [mol/L]
  # amount of Cas9
  Cas9_amount <- Cas9_molarConc * Cas9_vol  # [µmol]
  # adjustment if two gRNA samples
#####  if (two_gRNA_samples=="Yes") {
#####    Cas9_amount <- Cas9_amount / 2
#####  }
##### [removed for public version]
  # output
  return( Cas9_amount / gRNA_molarConc )
}


# function to calculate volume of additional KCl diluent
f_KCl_vol <- function(KCl_Cas9_conc,KCl_diluent_conc,KCl_final_conc,
                      Cas9_vol,total_vol) {
  ((total_vol * KCl_final_conc) - (Cas9_vol * KCl_Cas9_conc)) / KCl_diluent_conc
}


# function to calculate ddH2O volume
f_ddH2O_vol <- function(gRNA_vol_1st,gRNA_vol_2nd,
                        Cas9_vol,KCl_vol,total_vol) {
  total_vol - gRNA_vol_1st - gRNA_vol_2nd - Cas9_vol - KCl_vol
}


# function to calculate final mass concentration of Cas9
f_Cas9_final_massConc <- function(Cas9_massConc,Cas9_vol,total_vol) {
  ( Cas9_massConc * Cas9_vol * 1000 ) / total_vol  # [ng/µL]
}


# function to calculate total volume given final mass concentration of Cas9
f_total_vol <- function(Cas9_massConc,Cas9_vol,Cas9_final_massConc) {
  ( Cas9_massConc * Cas9_vol * 1000 ) / Cas9_final_massConc  # [µL]
}


# function to calculate molecular weight of gRNA from DNA template sequence
# (T converted to U, and assuming 5' triphosphate; 
# source: http://www.basic.northwestern.edu/biotools/oligocalc.html)
f_DNA_molarMass <- function(An,Tn,Cn,Gn) {
  as.numeric( (An * 329.21) + (Tn * 306.17) + (Cn * 305.18) + (Gn * 345.21) + 159.0 )  # [g/mol]
}

