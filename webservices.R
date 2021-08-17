
library(plumber)

#* @apiTitle servidor Plumber

#* @param msg 
#* @get /echo
function(msg=""){
  list(msg=paste0("mensaje: ",msg))
}

#* @serializer unboxedJSON
#* @param a 
#* @param b 
#* @post /suma
function(a,b){
  a<-as.numeric(a)
  b<-as.numeric(b)
  list(resul=a+b)
}

#* @serializer png
#* @param req
#* @post /datosFaltantes
function(req) {
  result <- as.data.frame(lapply(jsonlite::fromJSON(req$postBody), unlist))
  View(result)
  
  # save example plot to file
  library(visdat)
  plot(vis_dat(result));
}


#* @filter cors
cors <- function(req, res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  if (req$REQUEST_METHOD == "OPTIONS") {
    res$setHeader("Access-Control-Allow-Methods","*")
    res$setHeader("Access-Control-Allow-Headers", req$HTTP_ACCESS_CONTROL_REQUEST_HEADERS)
    res$status <- 200 
    return(list())
  } else {
    plumber::forward()
  }
}