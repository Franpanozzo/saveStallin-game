import wollok.game.*
import personajes.*
import movimientos.*
import armas.*
import saveStalin.*

object balaMunicion{
	//const image = "balaMunicion.png"
	
	method image() = "balaMunicion.png"
	
	method recibirDisparo(unaBala){
	}

	method esAtravesable() = true
	
	method chocarConStalin() {
		
	}
}

object municion{
	
	method image() = personaje.municionesDisponibles() + "municion.png" 
	
	method recibirDisparo(unaBala){
	}

	method esAtravesable() = true
	
	method chocarConStalin() {}
}


class BloqueDeHierro{
	const position 
	const image = "BloqueDeHierro.png"
	
	method position() = position

	method image() = image
	
	method esAtravesable() = false
	
  	method recibirDisparo(unaBala){
  	}
  	
  	method chocarConStalin(){}
}

class Columna inherits BloqueDeHierro{
	
	override method recibirDisparo(unaBala){
		unaBala.eliminar()
	}	
}

object zonaDeRescate{
	
	method position() = game.at(2,19)
	method image() = "zonaDeRescate.png"
	
	method chocarConStalin() {
		game.say(stalin, "Vamo lo pibe!!!")
		saveStalin.seTerminoElJuego(victoria)
	}
	
  	method recibirDisparo(unaBala){
  	}
	
	method esAtravesable() = true
}

object avisoDeRescate{
	var direccion = arriba
	const posicionInicial = zonaDeRescate.position().up(2)
	
	method position() = direccion.posicionSiguiente(posicionInicial)
	
	method image() = "avisoDeRescate.png"

	method llamarAtencion(){
		direccion = direccion.direccionOpuesta()
	}
	
	method recibirDisparo(unaBala){
	}

	method esAtravesable() = true
	
	method chocarConStalin() {}
}

object puerta{
	
	var image = "PuertaCerrada.png"
	const position = game.at(23,16)
	
	method image() = image
	
	method position() = position
	
	method abrirse(){
		image = "PuertaAbierta.png"
		const abrirPuerta = game.sound("PuertaAbierta.mp3")
    	abrirPuerta.play()
		(1 .. 4).forEach({nro => game.getObjectsIn(position.right(nro)).forEach({pared => game.removeVisual(pared)})})
		// se puede hacer con un .times
	}	
	method esAtravesable() = false
	
  	method recibirDisparo(unaBala){
  		unaBala.eliminar()
  	}
  	method chocarConStalin() {}
}

object palanca{
	var property image = "PalancaTrabada.png"
	
	method image() = image
	
	method esAtravesable() = false
	
	method recibirDisparo(unaBala){
		image = "PalancaDestrabada.png"
		puerta.abrirse()
		unaBala.eliminar()
	}
	
	method chocarConStalin() {	
	}	
}

object botellaVida{
	method image() = "vodka.png"
	
	method esAtravesable() = true
	
	method recibirDisparo(unaBala){
		
	}
	method chocarConStalin(){}
	
	method serAgarrado(){
		const tomar = game.sound("tomarVodka.mp3")
		tomar.play()
		vidaPersonaje.llenar()
		game.removeVisual(self)
	}
}
	

object vidaPersonaje{
	var vida = 100
	//var image = "Vida100.png"
	
	method image() {
		if(vida.between(81,100)) return "Vida100.png"
		if(vida.between(61,80)) return "Vida80.png"
		if(vida.between(41,60)) return "Vida60.png"
		if(vida.between(21,40)) return "Vida40.png"
		if(vida.between(1,20)) return "Vida20.png"
		return "Vida0.png" 
	}
	
	method llenar(){
		vida = 100
	}

	method vida() = vida
	
	method causarDanio(unDanio) {
		vida = vida - unDanio
		if(vida<= 0) {
			personaje.morir()
		}
	}
	method recibirDisparo(unaBala){
	}

	method esAtravesable() = true
	
	method chocarConStalin() {}
}


object mapa {
	const ancho = game.width() - 1 // debemos restarles uno para 
	const alto = game.height() - 1 // que las posiciones se generen bien.


	method establecer() {
		const posicionesParaGenerarMuros = []
			
		(0 .. ancho).forEach{ num => posicionesParaGenerarMuros.add(new BloqueDeHierro(position = game.at(num, alto)))} // lado superior
		(0 .. ancho).forEach{ num => posicionesParaGenerarMuros.add(new Columna(position = game.at(num, alto-1),image= "ParedesArribaAbajo.png"))} 
		(0 .. ancho).forEach{ num => posicionesParaGenerarMuros.add(new BloqueDeHierro(position = game.at(num, 0)))}  // lado inferior
		(0 .. ancho).forEach{ num => posicionesParaGenerarMuros.add(new Columna(position = game.at(num, 0+1),image= "ParedesArribaAbajo.png"))} 
		(0 .. ancho).forEach{ num => posicionesParaGenerarMuros.add(new BloqueDeHierro(position = game.at(num, 0+1)))}
		(0 .. alto).forEach{ num => posicionesParaGenerarMuros.add(new BloqueDeHierro(position = game.at(ancho, num)))} // lado derecho
		(0 .. alto).forEach{ num => posicionesParaGenerarMuros.add(new BloqueDeHierro(position = game.at(0, num)))} // lado izquierdo
		(1 .. (alto-6)).forEach{ num => posicionesParaGenerarMuros.add(new Columna(position = game.at((ancho/2 - 6), num),image = "Columna.png"))}
		((alto-1) .. 6).forEach{ num => posicionesParaGenerarMuros.add(new Columna(position = game.at((ancho/2 + 6), num),image = "Columna.png"))} 
		(22 .. 31).forEach{ num => posicionesParaGenerarMuros.add(new BloqueDeHierro(position = game.at(num, alto-8),image = "ParedesArribaAbajo.png"))}
			

		posicionesParaGenerarMuros.forEach {bloque => game.addVisual(bloque)}
		game.addVisualIn(vidaPersonaje,game.at((ancho-6),(alto-1)))
		game.addVisual(avisoDeRescate)
		game.onTick(500,"mover aviso",{avisoDeRescate.llamarAtencion()})
		game.addVisual(puerta)
		game.addVisualIn(palanca,game.at(28,alto-10))
		game.addVisualIn(balaMunicion,game.at(ancho-9,alto-1))
		game.addVisualIn(municion,game.at(ancho-8,alto-1))
		game.addVisualIn(botellaVida,game.at(ancho-6,alto-4))
    }
    
}

object seccion{
	const seccion1 = (0 .. 9)
	const seccion2 = (9 .. 21)
	const seccion3 = (21 .. 31)
	
	method seccionActual(posicion){
		if(seccion1.contains(posicion.x())) return 1
		if(seccion2.contains(posicion.x())) return 2
		if(seccion3.contains(posicion.x())) return 3
		else return 0
	}
}



