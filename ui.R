ui <- dashboardPage(skin = "red",
  dashboardHeader(title = "Komposisi Pangan"),
  dashboardSidebar(
    sidebarMenu(
      menuItem(text = "Beranda", tabName = "beranda", icon = icon("home")),
      menuItem(text = "Analisis Pangan", tabName = "makanan", icon = icon("carrot")),
      menuItem(text = "Glosarium", tabName = "glosarium", icon = icon("book"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "beranda",
                fluidRow(
                  valueBox(width = 4,
                           value = n_distinct(komposisi_fix$Kelompok_Pangan),
                           subtitle = "Kelompok Pangan",
                           icon = icon("nutritionix"),
                           color = "maroon"),
                  valueBox(width = 4,
                           value = length(makanan_single1$Nama_Bahan),
                           subtitle = "Makanan Non Olahan",
                           icon = icon("carrot"),
                           color = "maroon"),
                  valueBox(width = 4,
                           value = length(makanan_olahan1$Nama_Bahan),
                           subtitle = "Makanan Olahan",
                           icon = icon("hamburger"),
                           color = "maroon")
                ),
              fluidPage(
                h1("Dashboard Komposisi Pangan Indonesia"),
                h5("By",
                   a("Avita Khiyatu Hafni", href ="https://www.linkedin.com/in/avita-khilyatu-hafni-3b68a9211/")),
                h2("Dataset"),
                p("Visualisasi dibuat dengan dataset Komposisi Pangan Indonesia Tahun 2017 dari situs", 
                  a("Kemenkes RI", href = "https://www.dropbox.com/s/k1anbpb95cw8ikx/Tabel%20Komposisi%20Pangan%20Indonesia%202017.pdf?dl=0")),
                p("Dashboard ini bertujuan untuk menampilkan informasi mengenai komposisi pangan agar masyarakat dapat memilih dan mengkombinasikan pangan sehat menurut kandungan gizinya."),
                p("Dataset masih relevan dengan kondisi saat ini karena komposisi pangan bukanlah data yang mengalami perubahan signifikan per tahunnya."),
                h2("Kelompok Pangan"),
                p("Kelompok Pangan dikelompokkan menjadi 13 sesuai dengan pengelompokan pangan yang dilakukan oleh Harmonisasi ASEAN"),
                h2("Jenis Pangan"),
                p("- Pangan Tunggal/Non Olahan = bahan pangan yang tidak mengalami pengolahan dan tidak memiliki campuran bahan pangan lainnya (termasuk garam dan minyak), bisanya dalam bentuk mentah atau segar atau masih dalam bentuk alaminya"),
                p("- Pangan Olahan = bahan pangan yang telah mengalami proses pengolahan sehingga merubah bentuk alami bahan pangan. Bahan pangan olahan tersebut dapat berupa bahan pangan single/tunggal yang telah mengalami pengolahan atau pangan komposit/campuran."),
                h2("Angka Kecukupan Gizi (AKG)"),
                p("Setiap orang tentunya mempunyai nilai AKG yang berbeda-beda tergantung pada usia, jenis kelamin dan aktivitas yang dilakukan"),
                p("AKG yang sesuai dengan peraturan Kemenkes RI dapat dilihat pada",
                  a("Tabel AKG", href = "http://hukor.kemkes.go.id/uploads/produk_hukum/PMK_No__28_Th_2019_ttg_Angka_Kecukupan_Gizi_Yang_Dianjurkan_Untuk_Masyarakat_Indonesia.pdf#:~:text=Pasal%204%20Tabel%20AKG%20sebagaimana%20dimaksud%20dalam%20Pasal,pemerintah%20pusat%2C%20pemerintah%20daerah%2C%20dan%20pemangku%20kepentingan%20untuk%3A")),
                p("Lihat kode lengkap di",
                  a("GitHUb", href = ""))
                  )
              ),
      tabItem(tabName = "makanan",
              box(width = 12,
                  background = "black",
                  selectInput(inputId = "Kelompok_pangan",
                              label = "Pilih Kelompok Pangan",
                              choices = unique(komposisi_new$Kelompok_Pangan),
                              selected = "Serealia")),
              
              fluidRow(
                box(title = "Rata-Rata Komposisi Pangan Non Olahan di Indonesia",
                    background = "black",
                    width = 6,
                    echarts4rOutput(outputId = "plot_meanKomposisi")),
                box(title = "Rata-Rata Komposisi Pangan Olahan di Indonesia",
                    width = 6,
                    background = "black",
                    echarts4rOutput(outputId = "plot_meanKomposisi2"))
                ),
              
              box(width = 12,
                  background = "black",
                  selectInput(inputId = "Komposisi",
                              label = "Pilih Komposisi Pangan",
                              choices = unique(komposisi_new$Komposisi),
                              selected = "Air.g.")),
              fluidRow(
                box(title = "TOP 15 Makanan Non Olahan",
                    width = 6,
                    background = "black",
                    plotlyOutput(outputId = "plot_single")),
                box(title = "TOP 15 Makanan Olahan",
                    width = 6,
                    background = "black",
                    plotlyOutput(outputId = "plot_olahan"))
              ),
              box(width = 12,
                  background = "black",
                    sliderInput(inputId = "Jumlah_Komposisi",
                                    label = "Pilih Range Komposisi",
                                    min = 0,
                                    max = 400,
                                    value = c(0,100),
                                    dragRange = T)),
              fluidRow(
                box(title = "Range Komposisi Makanan Non Olahan",
                    width = 6,
                    background = "black",
                    plotlyOutput(outputId = "plot_range_single")),
                box(title = "Range Komposisi Makanan Olahan",
                    width = 6,
                    background = "black",
                    plotlyOutput(outputId = "plot_range_olahan"))
              )
              ),
      
      tabItem(tabName = "glosarium",
              fluidRow(
                box(width = 12,
                    background = "red",
                    title = "Data Komposisi Pangan Di Indonesia Tahun 2017",
                    DT::dataTableOutput(outputId = "table")),
                
              fluidRow(
                box(width = 12,
                    background = "red",
                    title = "Deskripsi Makanan",
                    DT::dataTableOutput(outputId = "table2"))
              ),
              fluidRow(
                box(width = 12,
                    background = "red",
                    title = "Deskripsi Komposisi",
                    DT::dataTableOutput(outputId = "table3"))
              ))
              
      )
)
)
)
