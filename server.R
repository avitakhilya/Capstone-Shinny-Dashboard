server <- function(input, output) {
  
  ### Tab Overview--------------------------------------------------

    
  ### Tab Analisis Makanan--------------------------------
  output$plot_meanKomposisi <- renderEcharts4r({
    komposisi_new%>%
      filter(Kelompok_Pangan== input$Kelompok_pangan, Jenis_Pangan=="Tunggal/Single")%>%
      group_by(Komposisi)%>%
      summarise(Jumlah_Komposisi = mean(Jumlah_Komposisi))%>%
      arrange(desc(Jumlah_Komposisi))%>%
      e_chart(Komposisi)%>%
      e_pie(Jumlah_Komposisi, radius = c ("50%", "75%"))%>%
      e_theme("dark-mushroom")%>%
      e_title(text = paste("Rata-Rata Komposisi", input$Kelompok_pangan),
              left = "center",
              top = "0")%>%
      e_legend(F)%>%
      e_tooltip(trigger = "item",
                formatter = JS("
                           function(params){return(
                           '<b>' + params.name + '</b>'
                           + ' : '
                           + (params.value).toLocaleString('en-US', 
                           {maximumFractionDigits : 2, minimumFractionDigits: 2})
                           )}
                           "))
  })
  output$plot_meanKomposisi2 <- renderEcharts4r({
    komposisi_new%>%
      filter(Kelompok_Pangan== input$Kelompok_pangan, Jenis_Pangan=="Olahan/Produk")%>%
      group_by(Komposisi)%>%
      summarise(Jumlah_Komposisi = mean(Jumlah_Komposisi))%>%
      arrange(desc(Jumlah_Komposisi))%>%
      e_chart(Komposisi)%>%
      e_pie(Jumlah_Komposisi, radius = c ("50%", "75%"))%>%
      e_theme("dark-mushroom")%>%
      e_title(text = paste("Rata-Rata Komposisi", input$Kelompok_pangan),
              left = "center",
              top = "0")%>%
      e_legend(F)%>%
      e_tooltip(trigger = "item",
                formatter = JS("
                           function(params){return(
                           '<b>' + params.name + '</b>'
                           + ' : '
                           + (params.value).toLocaleString('en-US', 
                           {maximumFractionDigits : 2, minimumFractionDigits: 2})
                           )}
                           "))
  })
  
  output$plot_single <- renderPlotly({
    #prepare data
    
    komposisi_single <- makanan_single%>%
      filter(Kelompok_Pangan == input$Kelompok_pangan,
             Komposisi == input$Komposisi)%>%
      group_by(Nama_Bahan)%>%
      summarise(Banyaknya_komposisi = sum(Jumlah_Komposisi))%>%
      ungroup() %>% 
      arrange(desc(Banyaknya_komposisi))%>%
      mutate(label = glue("Nama_Bahan : {Nama_Bahan}
                      Jumlah_Komposisi (gr) : {Banyaknya_komposisi}"))
    
    Top_single <- head(komposisi_single,15)
    Top_single
    
    #plot
    plot1 <- ggplot(data = Top_single, aes(
      x = Banyaknya_komposisi,
      y = reorder(Nama_Bahan, Banyaknya_komposisi),
      text = label)) +
      geom_col(mapping = aes(fill = Banyaknya_komposisi))+
      scale_fill_gradient(low="#f5e8c8", high="#c1232b") +
      scale_y_discrete(labels = scales::wrap_format(25)) +
      labs(title = paste("Top 15", input$Kelompok_pangan, "Komposisi", input$Komposisi),
           x = paste("Jumlah Komposisi", input$Komposisi),
           y = NULL)+
      theme_dark() +
      theme(legend.position = "none",
            plot.background = element_rect(fill = "black"),
            panel.background = element_rect(fill = "black"),
            plot.title = element_text(hjust = 0, colour = "white"),
            axis.title.x = element_text(hjust = 0.5, colour = "white"))
    
    ggplotly(plot1, tooltip = "text")
  })
  
  output$plot_olahan <- renderPlotly({
    # prepare data
    komposisi_olahan <- makanan_olahan%>%
      filter(Kelompok_Pangan == input$Kelompok_pangan,
             Komposisi == input$Komposisi)%>%
      group_by(Nama_Bahan)%>%
      summarise(Banyaknya_komposisi = sum(Jumlah_Komposisi))%>%
      ungroup() %>% 
      arrange(desc(Banyaknya_komposisi))%>%
      mutate(label = glue("Nama_Olahan : {Nama_Bahan}
                      Jumlah_Komposisi (gr) : {Banyaknya_komposisi}"))
    
    Top_olahan <-  head(komposisi_olahan,15)
    
    # membuat plot
    plot2 <- ggplot(data = Top_olahan, aes(
      x = Banyaknya_komposisi,
      y = reorder(Nama_Bahan, Banyaknya_komposisi),
      text = label))+
      geom_col(mapping = aes(fill = Banyaknya_komposisi))+
      scale_fill_gradient(low="#f5e8c8", high="#c1232b") +
      labs(title = paste("Top 15", input$Kelompok_pangan, "Komposisi", input$Komposisi),
           x = paste("Jumlah Komposisi", input$Komposisi),
           y = NULL)+
      theme_dark()+
      theme(legend.position = "none",
            plot.background = element_rect(fill = "black"),
            panel.background = element_rect(fill = "black"),
            plot.title = element_text(hjust = 0, colour = "white"),
            axis.title.x = element_text(hjust = 0.5, colour = "white"))
    
    ggplotly(plot2, tooltip = "text")
  })
  
  output$plot_range_single <- renderPlotly({
    
    #prepare data
    range_komposisi_single <- makanan_single%>%
      filter(Kelompok_Pangan == input$Kelompok_pangan,
             Komposisi == input$Komposisi,
             Jumlah_Komposisi >= input$Jumlah_Komposisi[1],
             Jumlah_Komposisi <= input$Jumlah_Komposisi[2])%>%
      group_by(Nama_Bahan)%>%
      ungroup() %>% 
      arrange(desc(Jumlah_Komposisi))%>%
      mutate(label = glue("Nama_Olahan : {Nama_Bahan}
                      Jumlah_Komposisi (gr) : {Jumlah_Komposisi}"))
    top_range_komposisi_single <- head(range_komposisi_single, 15)
    
    #plot
    loli_plot_single <- ggplot(top_range_komposisi_single,
                        aes(x = reorder(Nama_Bahan, Jumlah_Komposisi),
                            y = Jumlah_Komposisi,
                            text = label))+
      geom_segment(aes(x = reorder(Nama_Bahan, Jumlah_Komposisi),
                       xend = reorder(Nama_Bahan, Jumlah_Komposisi),
                       y = 0,
                       yend = Jumlah_Komposisi))+
      geom_point(size = 3, color= "#c1232b")+
      coord_flip()+
      labs(title = paste("Komposisi", input$Komposisi, "Pada", input$Kelompok_pangan))+
      theme_minimal()+
      scale_x_discrete(labels = scales::wrap_format(25))+
      theme(
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        legend.position = "none",
        plot.background = element_rect(fill = "#ffa07a"),
        panel.background = element_rect(fill = "#ffa07a"),
        plot.title = element_text(hjust = 0, colour = "white"),
        axis.title.x = element_text(hjust = 0.5, colour = "white")
      )+
      xlab("")+
      ylab(paste("Jumlah Komposisi", input$Komposisi))
    
    ggplotly(loli_plot_single, tooltip = "text")
  })
  
  
  output$plot_range_olahan <- renderPlotly({
    # prepare data
    range_komposisi_olahan <- makanan_olahan%>%
      filter(Kelompok_Pangan == input$Kelompok_pangan,
             Komposisi == input$Komposisi,
             Jumlah_Komposisi >= input$Jumlah_Komposisi[1],
             Jumlah_Komposisi <= input$Jumlah_Komposisi[2])%>%
      group_by(Nama_Bahan)%>%
      ungroup() %>% 
      arrange(desc(Jumlah_Komposisi))%>%
      mutate(label = glue("Nama_Olahan : {Nama_Bahan}
                      Jumlah_Komposisi (gr) : {Jumlah_Komposisi}"))
    top_range_komposisi_olahan <- head(range_komposisi_olahan, 15)
    
    #plot
    loli_plot_olahan <- ggplot(top_range_komposisi_olahan,
                        aes(x = reorder(Nama_Bahan, Jumlah_Komposisi),
                            y = Jumlah_Komposisi,
                            text = label))+
      geom_segment(aes(x = reorder(Nama_Bahan, Jumlah_Komposisi),
                       xend = reorder(Nama_Bahan, Jumlah_Komposisi),
                       y = 0,
                       yend = Jumlah_Komposisi))+
      geom_point(size = 3, color= "#c1232b")+
      coord_flip()+
      labs(title = paste("Komposisi", input$Komposisi, "Pada", input$Kelompok_pangan))+
      theme_minimal()+
      theme(
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        legend.position = "none",
        plot.background = element_rect(fill = "#ffa07a"),
        panel.background = element_rect(fill = "#ffa07a"),
        plot.title = element_text(hjust = 0, colour = "white"),
        axis.title.x = element_text(hjust = 0.5, colour = "white")
      )+
      xlab("")+
      ylab(paste("Jumlah Komposisi", input$Komposisi))
    
    ggplotly(loli_plot_olahan, tooltip = "text")
  })
  
  ## Tab Glosarium
  output$table <- DT::renderDataTable(komposisi_fix,
                                      options = list(scrollX =T,
                                                     scrollY =T))
  output$table2 <- DT::renderDataTable(desk_makanan,
                                      options = list(scrollX =T,
                                                     scrollY =T))
  output$table3 <- DT::renderDataTable(desk_komposisi,
                                      options = list(scrollX =T,
                                                     scrollY =T))
}