# ==== UI
ui <- dashboardPage(
  dashboardHeader(title = "DataRioBus"),
  dashboardSidebar(
    selectInput("linhas", label = "Type", width = "100%",
                choices =  c(readRDS("www/linhas.RDS"))),
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard"),
      menuItem("Estatísticas", tabName = "estatisticas")
    )
  ),
  dashboardBody(
    tags$script('
              $(document).ready(function () {
                
                function getLocation(callback){
                var options = {
                enableHighAccuracy: true,
                timeout: 5000,
                maximumAge: 0
                };
                
                navigator.geolocation.getCurrentPosition(onSuccess, onError);
                
                function onError (err) {
                Shiny.onInputChange("geolocation", false);
                }
                
                function onSuccess (position) {
                setTimeout(function () {
                var coords = position.coords;
                var timestamp = new Date();
                
                console.log(coords.latitude + ", " + coords.longitude, "," + coords.accuracy);
                Shiny.onInputChange("geolocation", true);
                Shiny.onInputChange("lat", coords.latitude);
                Shiny.onInputChange("long", coords.longitude);
                Shiny.onInputChange("accuracy", coords.accuracy);
                Shiny.onInputChange("time", timestamp)
                
                console.log(timestamp);
                
                if (callback) {
                callback();
                }
                }, 1100)
                }
                }
                
                var TIMEOUT = 1000; //SPECIFY
                var started = false;
                function getLocationRepeat(){
                //first time only - no delay needed
                if (!started) {
                started = true;
                getLocation(getLocationRepeat);
                return;
                }
                
                setTimeout(function () {
                getLocation(getLocationRepeat);
                }, TIMEOUT);
                
                };
                
                getLocationRepeat();
                
                });
                '),
    tabItems(
      tabItem("dashboard",
              fluidRow(
                # valueBoxOutput("rate"),
                # valueBoxOutput("count"),
                # valueBoxOutput("users")
              ),
              fluidRow(
                box(
                  width = 8, status = "info", solidHeader = TRUE,
                  title = "Localização dos onibus da linha selecionada (1 min)",
                  br(),
                  leafletOutput("map", height="600px"), 
                  br(),
                  verbatimTextOutput("lat")
                )
              )
      ),
      tabItem("estatisticas",
              fluidRow(
                column(12,
                       dataTableOutput("cons")
                )
              )
              )
    )
  )
)
  
  
  
 

