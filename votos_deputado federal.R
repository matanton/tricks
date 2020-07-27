if (!require("devtools")) install.packages("devtools")
devtools::
install_github("Cepesp-Fgv/cepesp-r")
library(cepespR)

install.packages("devtools")
library(devtools)
library(cepespR)
library(dplyr)
library(geobr)
library(ggplot2)
library(sf)
library(ggthemes)

#lista de colunas a serem baixadas
columns <- list("ANO_ELEICAO","DESCRICAO_CARGO","NUMERO_CANDIDATO","UF","NOME_MESO","COD_MUN_IBGE","NOME_MUNICIPIO", "QTDE_VOTOS")
columns2 <- list("ANO_ELEICAO","DESCRICAO_CARGO","NUMERO_CANDIDATO","UF", "QTDE_VOTOS")
columns3 <- list("ANO_ELEICAO","DESCRICAO_CARGO","UF","COD_MUN_IBGE","NOME_MUNICIPIO", "QTDE_VOTOS")

#votos nos deputados por municipios
votos_deputados <- get_votes("1998, 2002, 2006, 2010, 2014, 2018", "Federal Deputy", regional_aggregation = "Municipality",
          state = "SE", cached = FALSE, columns_list = columns, party = NULL,
          candidate_number = NULL)
View(votos_deputados)

votos_deputados_2018 <- get_votes("2018", "Federal Deputy", regional_aggregation = "Municipality",
                                  state = "SE", cached = FALSE, columns_list = columns, party = NULL,
                                  candidate_number = NULL)
View(votos_deputados_2018)

#Deputados eleitos
View(eleitos_deputados)
eleitos_deputados <- get_elections("1998, 2002, 2006, 2010, 2014, 2018", "Federal Deputy", columns_list = columns2, 
              only_elected = TRUE, state = "SE", regional_aggregation = "Estado")

eleitos_deputados_2018 <- get_elections("2018", "Federal Deputy", columns_list = columns2, 
                                   only_elected = TRUE, state = "SE", regional_aggregation = "Estado")

#groupamento por NOME_MUNICPIO
votos_muni <- votos_deputados %>%
  group_by(ANO_ELEICAO, COD_MUN_IBGE, NOME_MUNICIPIO, NUMERO_CANDIDATO) %>%
  summarise(VOTOS = QTDE_VOTOS,
            Porcent_VOTOS = (QTDE_VOTOS/rowsum.default(QTDE_VOTOS, group = NOME_MUNICIPIO)) %>%
  arrange(-VOTOS)

votos_muni_2018 <- votos_deputados_2018 %>%
    group_by(ANO_ELEICAO, COD_MUN_IBGE, NOME_MUNICIPIO, NUMERO_CANDIDATO) %>%
    summarise(VOTOS = QTDE_VOTOS) %>%
                arrange(-VOTOS)

#Analisar em quais municipios os eleitos foram mais votados
#Tentar colocar isso no mapa
#Bonus: Fazer % dos votos de cada candidato considerando os votos validos por municipio naquele ano

              

View(votos_muni)

sergipe <- read_municipality(code_state = 'SE')
plot(sergipe)

