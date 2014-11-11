# ui.R

shinyUI(fluidPage(
  titlePanel("CrispantCal: CRISPR/Cas9 Injection Mix Calculator"),
  
  sidebarLayout(
    sidebarPanel(
      
      h4("gRNA molar mass"),
      helpText("Enter DNA template to calculate molar mass, or enter 
               custom value directly."),
      textInput("DNA_template",label="DNA sequence (e.g. ATCG)",value=""),
      radioButtons("add_tracrRNA",
                   label="Add tracrRNA and UUUUU-end?",
                   choices=list("No","Yes"),
                   selected="No"),
      numericInput("gRNA_molarMass",
                   label="Molar mass (g/mol)",
                   value=33382.6,
                   step=0.1),
      br(),
      br(),
      
      h4("gRNA concentration"),
      numericInput("gRNA_massConc",
                   label="Mass concentration (ng/µL)",
                   value=265,
                   step=1),
      br(),
      br(),
      
      h4("Cas9"),
      helpText("Choose one of the preset defaults or enter custom values."),
      selectInput("Cas9_select",label="",
                  choices=list("MJ922 - Cas9p GFP",
                               "MJ923 - Cas9p mCherry",
                               "Custom"),
                  selected="MJ922 - Cas9p GFP"),
      numericInput("Cas9_molarMass_custom",
                   label="Molar mass (kg/mol or kDa)",
                   value=191.200,
                   step=0.1),
      numericInput("Cas9_massConc_custom",
                   label="Mass concentration (g/L)",
                   value=2.97,
                   step=0.01),
      br(),
      br(),
      
      h4("Volumes"),
      numericInput("Cas9_vol_custom",
                   label="Volume of Cas9 solution (µL)",
                   value=1.40,
                   step=0.01),
      numericInput("total_vol",
                   label="Total volume of injection mix (µL)",
                   value=5.00,
                   step=1),
      br(),
      br(),
      
      h4("KCl diluent"),
      helpText("Select whether to add additional KCl diluent. If yes, enter 
               concentrations."),
      radioButtons("KCl_radio",
                   label="Add additional KCl diluent?",
                   choices=list("No","Yes"),
                   selected="No"),
      numericInput("KCl_Cas9_conc",
                   label="KCl conc. of Cas9 solution (mM)",
                   value=100,
                   step=1),
      numericInput("KCl_diluent_conc",
                   label="KCl conc. of diluent (mM)",
                   value=2000,
                   step=1),
      numericInput("KCl_final_conc",
                   label="Desired KCl conc. (mM)",
                   value=300,
                   step=1)
      
    ),
    
    mainPanel(
      
      h3("Optimal injection mix"),
      tableOutput("volume_table"),
      plotOutput("volume_plot",width="300px",height="300px"),
      
      br(),
      
      h3("Information"),
      p("This tool calculates volumes corresponding to a perfect 1:1 mix ratio 
        of gRNA to Cas9 molecules in a CRISPR/Cas9 injection."),
      p("Enter the properties of your gRNA and Cas9 samples, volume of Cas9 
        solution, and the desired total volume of injection mix. Default values 
        are available for the Cas9 samples currently used in the Mosimann lab. 
        The calculated volumes for an optimal mix ratio are then shown in the 
        table and plot above."),
      p("The gRNA molar mass can be calculated by entering the DNA template 
        sequence (e.g. \"ATCG\") or entering a custom value directly. If 
        entering a DNA sequence, it can be either the full sequence (crRNA 
        + tracrRNA, around 100 nt) or the crRNA only (around 20 nt). If you 
        enter the crRNA only, select the option to add the tracrRNA and 
        UUUUU-end (25,981.5 g/mol) to give the full sequence."),
      p("The calculation formula for the gRNA molar mass is: ",
        em("(A * 329.21) + (U * 306.17) + (C * 305.18) + (G * 345.21) + 159.0,"),
        "where A, U, C, and G are the number of each nucleotide, all T's are 
        assumed to be converted to U's, and the 159.0 term is for a 5' 
        triphosphate.",
        a("Link to formula source and further details.",
          href="http://www.basic.northwestern.edu/biotools/oligocalc.html")),
      p("The \"KCl diluent\" option allows you to calculate the additional 
        volume of KCl diluent required to increase the KCl concentration in the 
        injection mix to a desired value. This option was added because optimal 
        reaction efficiency has been observed at a KCl concentration of around 
        300 mM, but Cas9 samples are often provided in 100-150 mM KCl solution, 
        which is then further diluted by the rest of the injection mix."),
      p("Authors: Jonas Zaugg and Lukas M Weber (Christian Mosimann and Mark D 
        Robinson labs, Institute of Molecular Life Sciences, University of 
        Zurich).")
      
    )
  )
))