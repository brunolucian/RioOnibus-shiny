# ==== libraries
library(dplyr)
library(shiny)
library(leaflet)
library(shinyjs)
library(shinydashboard)
library(DT)

# ==== fonction allowing geolocalisation
jsCode <- '
shinyjs.geoloc = function() {
navigator.geolocation.getCurrentPosition(onSuccess, onError);
function onError (err) {
Shiny.onInputChange("geolocation", false);
}
function onSuccess (position) {
setTimeout(function () {
var coords = position.coords;
console.log(coords.latitude + ", " + coords.longitude);
Shiny.onInputChange("geolocation", true);
Shiny.onInputChange("lat", coords.latitude);
Shiny.onInputChange("long", coords.longitude);
}, 5)
}
};
'

consorcios <- data.frame(prefixo = LETTERS[1:4], 
                         consorcio = c("Intersul", "Internorte",
                                       "Transcarioca", "Santa Cruz"), 
                         stringsAsFactors = F)
