import wollok.game.*
import personajes.*
import movimientos.*

class ArmaEnElPiso {
  const arma = new AK47()
  const property position

  method image() = arma.imagen()

  method serAgarrado(){
    personaje.agarrarArma(arma)
    game.removeVisual(self)
  }
  
  method esAtravesable() = true
    
  method recibirDisparo(unaBala){
  }

}


class Arma{

  const property nombre = "ak47"
  const property damage = 20
  var property municion = 30

  // CONSULTAS

  method tieneMunicion() = municion > 0

  method imagen() = nombre + ".png"
  
  method municionDisponible() = municion.toString()

  // ACCIONES
  
  method restarMunicion(){
      municion -= 1
  }


}

object pistola inherits Arma(nombre = "pistola", damage = 10, municion = 1){	
	
  override method restarMunicion(){}
  
  override method municionDisponible() = "infinito"
}

class AK47 inherits Arma{	
}

class Bala{

  var property position  
  var property direccion = derecha
  const velocidad = 100
  const property damage

  method avanzar(){
		position = direccion.posicionSiguiente(position)
	}
  
  method image() = direccion.imageDireccion("bala")

  method salirBala(){
  	game.addVisual(self)  
  	game.onCollideDo(self, {visualColisionado => visualColisionado.recibirDisparo(self)})
    game.onTick(velocidad, "mover Bala", {self.avanzar()})
  }

  method esAtravesable() = true
  
  method recibirDisparo(unaBala){
    unaBala.eliminar()
  }
  
  method eliminar(){
    game.removeVisual(self)
  }
  method chocarConStalin() {}
}


