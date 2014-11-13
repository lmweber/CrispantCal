# helper functions and default values


# Cas9 default values
Cas9_defaults <- list("MJ922 - Cas9p GFP"     = c(191.2, 2.97, 1.40, 100),
                      "MJ923 - Cas9p mCherry" = c(190.0, 5.54, 0.75, 150))


# function to calculate gRNA volume
f_gRNA_vol <- function(gRNA_molarMass,gRNA_massConc,
                       Cas9_molarMass,Cas9_massConc,
                       Cas9_vol) {
  # convert concentrations
  gRNA_molarConc <- ( gRNA_massConc / 1000 ) / gRNA_molarMass  # [mol/L]
  Cas9_molarConc <- Cas9_massConc / ( Cas9_molarMass * 1000 )  # [mol/L]
  # amount of Cas9
  Cas9_amount <- Cas9_molarConc * Cas9_vol  # [µmol]
  # output
  return( Cas9_amount / gRNA_molarConc )
}


# function to calculate volume of additional KCl diluent
f_KCl_vol <- function(KCl_Cas9_conc,KCl_diluent_conc,KCl_final_conc,
                      Cas9_vol,total_vol) {
  ((total_vol * KCl_final_conc) - (Cas9_vol * KCl_Cas9_conc)) / KCl_diluent_conc
}


# function to calculate ddH2O volume
f_ddH2O_vol <- function(gRNA_vol,Cas9_vol,KCl_vol,total_vol) {
  total_vol - gRNA_vol - Cas9_vol - KCl_vol
}


# function to calculate molecular weight of gRNA from DNA template sequence
# (T converted to U, and assuming 5' triphosphate; 
# source: http://www.basic.northwestern.edu/biotools/oligocalc.html)
f_DNA_molarMass <- function(An,Tn,Cn,Gn) {
  as.numeric( (An * 329.21) + (Tn * 306.17) + (Cn * 305.18) + (Gn * 345.21) + 159.0 )  # [g/mol]
}

