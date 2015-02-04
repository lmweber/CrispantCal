# ui.R

shinyUI(fluidPage(
  titlePanel(title="CrispantCal: CRISPR-Cas9 Injection Mix Calculator",
             windowTitle="CrispantCal"),
  
  sidebarLayout(
    sidebarPanel(
      
      h4("gRNA sample properties"),
      
      helpText(span("gRNA molar mass:", style="font-weight:bold"),
               "Enter DNA template sequence to calculate molar mass, or enter 
               custom value directly."),
      helpText("DNA sequence (e.g. ATCG)"),
      textInput("DNA_template",
                label=NULL,
                value=""),
      checkboxInput("add_tracrRNA",
                   label="Add tracrRNA and UUUUU-end",
                   value=FALSE),
      helpText("Molar mass (g/mol)"),
      numericInput("gRNA_molarMass",
                   label=NULL,
                   value=33382.6,
                   step=0.1),
      
      helpText(span("gRNA concentration:", style="font-weight:bold"),
               "Mass concentration (ng/µL)"),
      numericInput("gRNA_massConc",
                   label=NULL,
                   value=265,
                   step=1),
      
      
      hr(),
      h4("Optional: Second gRNA sample"),
      helpText("Select whether to include a second gRNA sample. If yes, enter 
               sample properties below."),
      radioButtons("two_gRNA_samples",
                   label=NULL,
                   choices=list("No","Yes"),
                   selected="No"),
      
      helpText(span("gRNA molar mass:", style="font-weight:bold"),
               "Enter DNA template sequence to calculate molar mass, or enter 
               custom value directly."),
      helpText("DNA sequence (e.g. ATCG)"),
      textInput("DNA_template_2nd",
                label=NULL,
                value=""),
      checkboxInput("add_tracrRNA_2nd",
                   label="Add tracrRNA and UUUUU-end",
                   value=FALSE),
      helpText("Molar mass (g/mol)"),
      numericInput("gRNA_molarMass_2nd",
                   label=NULL,
                   value=33382.6,
                   step=0.1),
      
      helpText(span("gRNA concentration:", style="font-weight:bold"),
               "Mass concentration (ng/µL)"),
      numericInput("gRNA_massConc_2nd",
                   label=NULL,
                   value=265,
                   step=1),
      
      
      hr(),
      h4("Cas9 sample properties"),
      helpText("Choose one of the preset defaults or enter custom values."),
      selectInput("Cas9_select",
                  label=NULL,
                  choices=list("MJ922 - Cas9p GFP",
                               "MJ923 - Cas9p mCherry",
                               "Custom"),
                  selected="MJ922 - Cas9p GFP"),
      helpText("Molar mass (kg/mol or kDa)"),
      numericInput("Cas9_molarMass_custom",
                   label=NULL,
                   value=191.200,
                   step=0.1),
      helpText("Mass concentration (g/L)"),
      numericInput("Cas9_massConc_custom",
                   label=NULL,
                   value=2.97,
                   step=0.01),
      helpText("Volume of Cas9 solution (µL)"),
      numericInput("Cas9_vol_custom",
                   label=NULL,
                   value=1.40,
                   step=0.01),
      
      
      hr(),
      h4("Total volume"),
      helpText("Total volume of injection mix (µL)"),
      numericInput("total_vol",
                   label=NULL,
                   value=5.00,
                   step=1),
      
      
      hr(),
      h4("Optional: Final Cas9 concentration"),
      helpText("Select whether to specify final concentration of Cas9 instead 
               of total volume. If yes, enter concentration."),
      radioButtons("final_conc_radio",
                   label=NULL,
                   choices=list("No","Yes"),
                   selected="No"),
      helpText("Final mass concentration of Cas9 in injection mix (ng/µL)"),
      numericInput("Cas9_final_massConc",
                   label=NULL,
                   value=832,
                   step=1),
      
      
      hr(),
      h4("Optional: KCl diluent"),
      helpText("Select whether to add additional KCl diluent. If yes, enter 
               concentrations."),
      radioButtons("KCl_radio",
                   label=NULL,
                   choices=list("No","Yes"),
                   selected="No"),
      helpText("KCl concentration of Cas9 solution (mM)"),
      numericInput("KCl_Cas9_conc",
                   label=NULL,
                   value=100,
                   step=1),
      helpText("KCl concentration of diluent (mM)"),
      numericInput("KCl_diluent_conc",
                   label=NULL,
                   value=2000,
                   step=1),
      helpText("Desired KCl concentration (mM)"),
      numericInput("KCl_final_conc",
                   label=NULL,
                   value=300,
                   step=1)
      
    ),
    
    
    mainPanel(
      
      h3("Optimal injection mix"),
      tableOutput("volume_table"),
      plotOutput("volume_plot", width="300px", height="300px"),
      
      
      br(),
      h3("Information"),
      
      p("This tool calculates volumes corresponding to an optimal one-to-one 
        molecular ratio of gRNA to Cas9 in a CRISPR-Cas9 injection mix."),
      p("Enter the molecular properties of your gRNA and Cas9 samples, volume 
        of Cas9 solution, and desired total volume of injection mix in the 
        input fields. The calculated volumes for the optimal mix ratio are then 
        shown in the table and plot above."),
      
      
      br(),
      h4("Notes",
         style="margin-bottom:12px"),
      
      h5("gRNA inputs",
         style="margin-top:18px; margin-bottom:12px"),
      tags$ul(
        tags$li("The gRNA molar mass can be calculated by entering the DNA 
                template sequence (e.g. \"ATCG\") or entering a custom value 
                directly. If entering a DNA sequence, it can be either the full 
                sequence (crRNA + tracrRNA, around 100 nt) or the crRNA only 
                (around 20 nt). If you enter the crRNA only, select the option 
                to add the tracrRNA and UUUUU-end (25,981.5 g/mol) to give the 
                full sequence.",
                style="margin-bottom:12px"),
        tags$li("The calculation formula for the gRNA molar mass is: ",
                em("(A * 329.21) + (U * 306.17) + (C * 305.18) + (G * 345.21) + 159.0,"),
                "where A, U, C, and G are the number of each nucleotide, all T's 
                are assumed to be converted to U's, and the 159.0 term is for a 
                5' triphosphate.",
                a("Link to formula source and further details.",
                  href="http://www.basic.northwestern.edu/biotools/oligocalc.html"),
                style="margin-bottom:12px"),
        tags$li("The optional inputs for a second gRNA sample allow you to 
                calculate volumes for an experiment targeting two DNA locations. 
                The calculations assume that the two gRNAs are required in equal 
                proportions. Output volumes are then shown for a one-to-one 
                ratio of Cas9 to the combined concentration of gRNA from both 
                samples.",
                style="margin-bottom:12px")
      ),
      
      h5("Cas9 inputs",
         style="margin-top:18px; margin-bottom:12px"),
      tags$ul(
        tags$li("Default values for Cas9 sample properties are available for 
                the Cas9 samples currently used in the Mosimann lab at the 
                University of Zurich.",
                style="margin-bottom:12px"),
        tags$li("The optional input for final Cas9 concentration allows you to
                specify a desired final concentration of Cas9 in the injection 
                mix, instead of total volume.",
                style="margin-bottom:12px")
      ),
      
      h5("KCl diluent",
         style="margin-top:18px; margin-bottom:12px"),
      tags$ul(
        tags$li("The", em("KCl diluent"), "option allows you to calculate the 
                additional volume of KCl diluent required to increase the KCl 
                concentration in the injection mix to a desired value. This 
                option was added because optimal reaction efficiency has been 
                observed at a KCl concentration of around 300 mM, but Cas9 
                samples are often provided in 100-150 mM KCl solution, which is 
                then further diluted by the rest of the injection mix.",
                style="margin-bottom:12px")
      ),
      
      
      br(),
      h4("Authors"),
      
      p("This tool was developed by Lukas M. Weber, Jonas Zaugg, Anastasia Felker, 
        and Christian Mosimann (Mark D. Robinson and Christian Mosimann labs), 
        Institute of Molecular Life Sciences, University of Zurich."),
      p("Additional information including local installation instructions 
        available at",
        a("crispantcal.io",
          href="http://crispantcal.io/"),
        ".")
    )
  )
))

