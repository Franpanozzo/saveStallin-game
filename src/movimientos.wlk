import wollok.game.*
import personajes.*
import armas.*


class Direccion{

	const codigoPosicionSiguiente
	const imagen
	const direccionOpuesta

	method posicionSiguiente(posicion) = codigoPosicionSiguiente.apply(posicion) 
	
	method imageDireccion(unPersonaje) = unPersonaje + imagen

	method direccionOpuesta() = direccionOpuesta

}


object derecha inherits Direccion(codigoPosicionSiguiente = {posicion => posicion.right(1)}, imagen = "Derecha.png", direccionOpuesta = izquierda){}

object izquierda inherits Direccion(codigoPosicionSiguiente = {posicion => posicion.left(1)}, imagen = "Izquierda.png", direccionOpuesta = derecha){}

object arriba inherits Direccion(codigoPosicionSiguiente = {posicion => posicion.up(1)}, imagen = "Arriba.png", direccionOpuesta = abajo){}

object abajo inherits Direccion(codigoPosicionSiguiente = {posicion => posicion.down(1)}, imagen = "Abajo.png", direccionOpuesta = arriba){}


object prisionero{
	method position() = game.at(26,20)  

	method direccion() = derecha
}

object escapar{

	method position() = personaje.direccion().direccionOpuesta().posicionSiguiente(personaje.position())

	method direccion() = personaje.direccion()
}
