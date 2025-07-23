
## funcion fEsperanzaQ_k

#' Autor: Rodrigo Lagos
# Fecha: 07-03-2022

#Determina la esperanza de Q_k dado el vector de dectativilidad, el tamaño muestral(T) y la riqueza


#Inputs:
# vLambda : vector de dectaviliad
# nT      : tamaño muestra  
# nK      : canidad de especies/conceptos que se presenta K veces

#Outputs:
# CV : estimador del coverage de la muestra


fEsperanzaQ_k <- function(nK,nT,vLambda){
  
  
  tCk <- choose(nT,nK)
  
  vE <- tCk * vLambda^nK * (1- vLambda)^(nT- nK)
  
  nE <- sum(vE)
  
  return(nE)
  
}