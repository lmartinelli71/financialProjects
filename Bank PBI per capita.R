# Instalar y cargar las bibliotecas necesarias
install.packages("rvest")
install.packages("WDI")
install.packages("ggplot2")
install.packages("dplyr")
install.packages("hrbrthemes")
install.packages("viridis")
install.packages("cowplot")

library(rvest)
library(WDI)
library(ggplot2)
library(dplyr)
library(hrbrthemes)
library(viridis)
library(cowplot)

# URL de la página web
url <- "https://unstats.un.org/unsd/methodology/m49/overview/#"

# Se lee el contenido de la página
pagina <- read_html(url)

# Extraccion de la tabla (se ajusta el selector CSS según la estructura de la página)
tabla <- html_table(html_nodes(pagina, "table"))[[1]]

# Convierte la tabla a un marco de datos con nombres de columna
data <- as.data.frame(tabla, header = TRUE)

# Se Obtiene los nombres de columna desde la primera fila de la tabla
col_names <- unlist(data[1,])
data <- data[-1,]

# Asigna los nombres de columna al marco de datos
colnames(data) <- col_names

# Cambia los nombres de las columnas
nuevos_nombres <- c("Continente", "Pais")
colnames(data)[colnames(data) %in% c("Region Name", "Country or Area")] <- nuevos_nombres

# Selecciona columnas de interés
columnas_seleccionadas <- c("Continente", "Pais", "ISO-alpha3 Code")
pais_continente <- data[columnas_seleccionadas]



# Definicion  del indicador (PBI per cápita)
indicator_code <- "NY.GDP.PCAP.CD"

# Descarga los datos de PBI per cápita para todos los países en el año 2021
data_pbi_cap <- WDI(country = "all",
                    indicator = indicator_code,
                    start = 2021,
                    end = 2021)

# Definir el país y el indicador de expectativa de vida
pais <- "all" 
indicador <- "SP.DYN.LE00.IN"  # Expectativa de vida al nacer

# Descargar los datos para 2021
datos_2021 <- WDI(country = pais, indicator = indicador, start = 2021, end = 2021)

# Filtrar y limpiar los datos
datos_2021_exp_vida <- na.omit(datos_2021)

# Definir los parámetros de la consulta
indicador <- "SP.POP.TOTL"  
paises <- "all"             

# Descargar los datos de población para el año 2021
datos_poblacion <- WDI(country = paises, indicator = indicador, start = 2021, end = 2021)

# Combinar las tres tablas utilizando los campos coincidentes
tabla_combinada <- pais_continente %>%
  inner_join(datos_2021_exp_vida, by = c("ISO-alpha3 Code" = "iso3c")) %>%
  inner_join(data_pbi_cap, by = c("ISO-alpha3 Code" = "iso3c")) %>%
  inner_join(datos_poblacion, by = c("ISO-alpha3 Code" = "iso3c"))

# Seleccionar las columnas de interés
data <- tabla_combinada %>%
  select(Continente, Pais, iso2c.x, year.x, SP.DYN.LE00.IN, NY.GDP.PCAP.CD, SP.POP.TOTL)

# Eliminar filas con valores NA
data <- na.omit(data)

# Cambiar nombres de columnas
colnames(data) <- c("Continente", "Pais", "Codigo", "Año", "Exp_vida", "PBI_per_capita", "Poblacion")

# Filtramos y eliminamos registros donde PBI_per_capita es mayor a 100,000
#se hace para que la presentacion sea mas prolija pues casi todos los paises entran aca
data <- data %>%
  filter(PBI_per_capita <= 100000)

#Eliminamos dataframes que no usamos
rm(data_pbi_cap,datos_2021,datos_2021_exp_vida,datos_poblacion,pais_continente)

# Se crea el gráfico de dispersión
data %>%
  arrange(desc(Poblacion)) %>%
  group_by(Continente) %>%
  mutate(rank = row_number(desc(Poblacion))) %>%
  mutate(label = ifelse(rank <= 3, as.character(Pais), "")) %>%
  mutate(Pais = factor(Pais, Pais)) %>%
  ggplot(aes(x = PBI_per_capita, y = Exp_vida, size = Poblacion, fill = Continente)) +
  geom_point(alpha = 0.5, shape = 21, color = "black") +
  geom_text(aes(label = label), size = 3, nudge_y = 1) +
  scale_size(range = c(.1, 24), name = "Poblacion") +
  scale_fill_viridis(discrete = TRUE, guide = guide_legend(title = "Continente"), option = "A") +
  scale_x_continuous(breaks = seq(0, 100000, by = 5000)) +  # Establecer los números en el eje x
  scale_y_continuous(breaks = seq(0, 100, by = 20)) +
  theme_minimal() +
  ylab("Expectativa de vida") +
  xlab("PBI per Capita (US$ a precios actuales) ") +
  theme(legend.justification = "top", legend.position = "right") +
  guides(fill = guide_legend(override.aes = list(size = 4)), size = guide_legend(title = "Poblacion"))


# Se calcula el tanaño de circulos proporcional a PBI_per_capita * Poblacion
data$circle_size <- sqrt(data$PBI_per_capita * data$Poblacion)

# Definir colores para cada continente
continent_colors <- c("Asia" = "red", "Africa" = "black", "Europe" = "orange","Americas"="purple", "Oceania"="black")

# Ordenar el dataframe por PBI_per_capita * Poblacion de mayor a menor dentro de cada continente
data <- data %>%
  arrange(Continente, desc(PBI_per_capita * Poblacion))

# Seleccionar los 5 países con mayor PBI_per_capita * Poblacion por continente
data_top5 <- data %>%
  group_by(Continente) %>%
  slice_max(order_by = PBI_per_capita * Poblacion, n = 10)

# Crear el gráfico usando ggplot2
ggplot(data_top5, aes(x = Continente, y = Pais)) +
  geom_point(aes(size = circle_size, fill = Continente), shape = 21, color = "black") +
  geom_text(aes(label = Pais, color = Continente), nudge_x = 0.2) +  # Ajustamos la posición horizontal de las etiquetas
  scale_size_continuous(range = c(3, 15)) +
  labs(title = "Economias con mayor PBI por continente") +
  theme_minimal() +
  theme(legend.position = "top") +
  guides(fill = guide_legend(title = "Continente", override.aes = list(color = NA))) +  # Eliminar color en la leyenda de la letra por país de continente
  scale_fill_viridis(discrete = TRUE, option = "A") +  # Escala de colores para los círculos
  scale_color_manual(values = continent_colors) +  # Paleta de colores para las etiquetas
  theme(axis.text.y = element_blank())








