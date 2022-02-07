# install.packages yang dibutuhkan
library(flexdashboard)
library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(ggpubr)
library(plotly)
library(glue)
library(reshape2)
library(echarts4r)
library(highcharter)
library(htmlwidgets)
library(scales)

# read data
komposisi <- read.csv("data_input/komposisi_pangan.csv")

desk_komposisi <- read.csv("data_input/deskripsi_komposisi.csv")

desk_makanan <- read.csv("data_input/deskripsi_makanan.csv")

komposisi_fix <- komposisi%>%
  mutate_at(c("Kelompok_Pangan", "Jenis_Pangan"), as.factor)

komposisi_fix <- komposisi_fix[, -c(1,2)]

komposisi_new <- melt(komposisi_fix, id.vars = c("Nama_Bahan", "Kelompok_Pangan", "Jenis_Pangan"),
                      variable.name = "Komposisi",
                      value.name = "Jumlah_Komposisi")

# makanan non olahan
makanan_single <- komposisi_new%>%
  filter(Jenis_Pangan == "Tunggal/Single")

#makanan olahan
makanan_olahan <- komposisi_new%>%
  filter(Jenis_Pangan == "Olahan/Produk")

makanan_single1 <- komposisi_fix%>%
  filter(Jenis_Pangan=="Tunggal/Single")
makanan_olahan1 <- komposisi_fix%>%
  filter(Jenis_Pangan=="Olahan/Produk")
