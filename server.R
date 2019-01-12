# ==== server
server <- function(input, output) {
  
  output$lat <- renderPrint({
    input$lat
  })
  
  # InputData
  jsondata <- reactive({
    invalidateLater(millis = 60000)
    jsonlite::fromJSON("http://dadosabertos.rio.rj.gov.br/apiTransporte/apresentacao/rest/index.cfm/obterTodasPosicoes") 
  })
  
  
  # Basic map
  output$map <- renderLeaflet({
    dados <- jsondata()$DATA %>% as_data_frame() %>% distinct()
    
    names(dados) <- jsondata()$COLUMNS
    
    dados$LATITUDE <- as.numeric(dados$LATITUDE)
    dados$LONGITUDE <- as.numeric(dados$LONGITUDE)
    
    numLinha = input$linhas
    latUser = input$lat
    longUser = input$long
    
    dadosFilter <- dados %>% filter(LINHA == numLinha)
    
    leaflet(data = dadosFilter) %>% addTiles() %>%
      addMarkers(~LONGITUDE, ~LATITUDE, popup = ~LINHA, label = ~VELOCIDADE) %>% 
      addCircleMarkers(longUser, latUser, label = "USUARIO" )
  })
  
  # Find geolocalisation coordinates when user clicks
  observeEvent(input$geoloc, {
    js$geoloc()
  })
  
  
  # zoom on the corresponding area
  observe({
    if(!is.null(input$lat)){
      map <- leafletProxy("map")
      dist <- 0.2
      lat <- input$lat
      lng <- input$long
      map %>% fitBounds(lng - dist, lat - dist, lng + dist, lat + dist)
    }
  })

  output$cons <-renderDataTable({
    dados %>% 
    mutate(prefixo = substr(ORDEM, 1, 1)) %>% 
    left_join(consorcios) %>% 
    count(consorcio)
  })
  
  n_linha <- reactive({
    dados %>% 
      filter(LINHA == input$linha_count) %>% 
      summarise(num_bus = n()) %>% 
      pull()
  })
  
  output$cont_linha <- renderValueBox({
    valueBox(
      paste(n_linha()), "Ônibus na linha selecionada", icon = icon("bus")
    )
  })
}