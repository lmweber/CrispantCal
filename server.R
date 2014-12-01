# server.R

# helper functions and default values
source("helpers.R")


shinyServer(
  function(input, output, session) {
    
    # Manipulate inputs
    # -----------------
    
    # Cas9 inputs
    Cas9_inputs <- reactive({
      c(input$Cas9_molarMass_custom,
        input$Cas9_massConc_custom,
        input$Cas9_vol_custom,
        input$KCl_Cas9_conc)
    })
    # update Cas9 input fields
    sel <- reactive({
      switch(input$Cas9_select,
             "MJ922 - Cas9p GFP"    =Cas9_defaults$"MJ922 - Cas9p GFP",
             "MJ923 - Cas9p mCherry"=Cas9_defaults$"MJ923 - Cas9p mCherry")
    })
    observe({ updateNumericInput(session,"Cas9_molarMass_custom",value=sel()[1]) })
    observe({ updateNumericInput(session,"Cas9_massConc_custom", value=sel()[2]) })
    observe({ updateNumericInput(session,"Cas9_vol_custom",      value=sel()[3]) })
    observe({ updateNumericInput(session,"KCl_Cas9_conc",        value=sel()[4]) })
    observe({
      if ( !(list(Cas9_inputs()) %in% Cas9_defaults) ) {
        updateSelectInput(session,"Cas9_select",selected="Custom")
      }
    })
    # individual input functions: Cas9
    Cas9_molarMass <- reactive({ Cas9_inputs()[1] })
    Cas9_massConc  <- reactive({ Cas9_inputs()[2] })
    Cas9_vol       <- reactive({ Cas9_inputs()[3] })
    
    
    # gRNA inputs
    DNA_table <- reactive({
      DNA_letters <- unlist(strsplit(input$DNA_template,""))
      table(factor(DNA_letters,levels=c("A","T","C","G")))
    })
    DNA_molarMass_calc <- reactive({
      f_DNA_molarMass(DNA_table()["A"],DNA_table()["T"],DNA_table()["C"],DNA_table()["G"])
    })
    DNA_molarMass <- reactive({
      if (input$add_tracrRNA=="Yes") {
        return( DNA_molarMass_calc() + 25981.5 )
      } else {
        return( DNA_molarMass_calc() )
      }
    })
    observe({ 
      if ( !(all(DNA_table()==0)) ) {
        updateNumericInput(session,"gRNA_molarMass",value=DNA_molarMass())
      }
    })
    
    
    
    # Calculate volumes
    # -----------------
    
    # calculate volume of gRNA
    gRNA_vol <- reactive({
      f_gRNA_vol(input$gRNA_molarMass,input$gRNA_massConc,
                 Cas9_molarMass(),Cas9_massConc(),Cas9_vol())
    })
    
    # calculate and update final mass concentration of Cas9
    Cas9_final_massConc <- reactive({
      f_Cas9_final_massConc(Cas9_massConc(),Cas9_vol(),input$total_vol)
    })
    observe({
      if (input$final_conc_radio=="No") {
        updateNumericInput(session,"Cas9_final_massConc",value=round(Cas9_final_massConc(),1))
      }
    })
    
    # calculate and update total volume
    total_vol <- reactive({
      f_total_vol(Cas9_massConc(),Cas9_vol(),input$Cas9_final_massConc)
    })
    observe({
      if (input$final_conc_radio=="Yes") {
        updateNumericInput(session,"total_vol",value=round(total_vol(),2))
      }
    })
    
    # calculate volume of additional KCl diluent (if selected)
    KCl_vol <- reactive({
      if (input$KCl_radio=="Yes") {
        f_KCl_vol(input$KCl_Cas9_conc,input$KCl_diluent_conc,input$KCl_final_conc,
                  Cas9_vol(),input$total_vol)
      } else {
        0
      }
    })
    
    # calculate volume of ddH2O (remaining volume to reach total)
    ddH2O_vol <- reactive({
      f_ddH2O_vol(gRNA_vol(),Cas9_vol(),KCl_vol(),input$total_vol)
    })
    
    # round volumes
    gRNA_vol_rnd  <- reactive({ round(gRNA_vol(),2)  })
    Cas9_vol_rnd  <- reactive({ round(Cas9_vol(),2)  })
    KCl_vol_rnd   <- reactive({ round(KCl_vol(),2)   })
    ddH2O_vol_rnd <- reactive({ round(ddH2O_vol(),2) })
    # total taking into account rounding of components
    total_vol_rnd <- reactive({ 
      gRNA_vol_rnd() + Cas9_vol_rnd() + KCl_vol_rnd() + ddH2O_vol_rnd()
    })
    
    
    
    # Outputs
    # -------
    
    # volumes as list
    data_list <- reactive({
      list(gRNA=gRNA_vol_rnd(),
           Cas9=Cas9_vol_rnd(),
           KCl=KCl_vol_rnd(),
           ddH2O=ddH2O_vol_rnd(),
           Total=total_vol_rnd())
    })
    
    # output table
    output$volume_table <- renderTable({
      t(as.data.frame(data_list(),row.names="Volume (µL)"))
    })
    
    # output plot
    output$volume_plot <- renderPlot({
      data <- unlist(data_list()[1:4])
      barplot(data,ylim=c(0,round(input$total_vol,1)),
              ylab="Volume (µL)",col="skyblue")
      text(seq(0.7,4.3,length=4),sapply(data,max,0),
           labels=data,pos=3)
    })
    
})

