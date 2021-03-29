import wollok.game.*
import personajes.*
import movimientos.*
import armas.*
import mapa.*

object saveStalin {
	
	// ENEMIGOS PARA NIVEL 2
	const listaDeEnemigos = [new Enemigo(position = game.at(3,14),direccionDeLaMira = abajo, direccion = derecha),
							new Enemigo(position = game.at(25,12),direccionDeLaMira = abajo, direccion = derecha),
							new Enemigo(position = game.at(25,10),direccionDeLaMira = abajo,direccion = izquierda),
							new Enemigo(position = game.at(17,20),direccionDeLaMira = izquierda,direccion = arriba),
							new Enemigo(position = game.at(14,8),direccionDeLaMira = arriba,direccion = izquierda),
							new Enemigo(position = game.at(8,13),direccionDeLaMira = izquierda,direccion = abajo,arma = pistola)]
							
	// ENEMIGOS PARA NIVEL 1 (O PARA QUE NO SE TRABE TANTO xd)
	
	/*const listaDeEnemigos2 = [new Enemigo(position = game.at(3,14)),
							new Enemigo(position = game.at(22,10),direccionDeLaMira = abajo,direccion = izquierda),
							new Enemigo(position = game.at(14,8),direccionDeLaMira = arriba,direccion = izquierda)*/
	
	var currentMusic

	const armasEnElPiso = [new ArmaEnElPiso(position = game.at(2,8)), new ArmaEnElPiso(position = game.at(12,4))]

	method iniciar() {
		currentMusic.stop()
		game.clear()
		self.agregarPersonajes()
		self.configurarTeclas()
		self.configurarAcciones()
		mapa.establecer()
		self.dropearArmas()
		currentMusic = game.sound("MusicaFondo.mp3")
		
	}

	method dropearArmas(){
		armasEnElPiso.forEach({arma => game.addVisual(arma)})
	}

	method configurarJuego() {
		game.title("Save Stalin")
		game.width(31)
		game.height(25)
		game.boardGround("Fondo.png")
	}

	method agregarPersonajes() {
		game.addVisual(stalin)
		game.addVisual(personaje)
		listaDeEnemigos.forEach({enemigo => game.addVisual(enemigo)})
		game.addVisual(zonaDeRescate) // este addVisual iria en el popZonaDeRescate, sino se muestra la zona de rescate ni bien empieza
	}

	method configurarTeclas() {
		keyboard.w().onPressDo({personaje.moverse(arriba)}) 
		keyboard.s().onPressDo({personaje.moverse(abajo)})
		keyboard.a().onPressDo({personaje.moverse(izquierda)})
		keyboard.d().onPressDo({personaje.moverse(derecha)})
		keyboard.enter().onPressDo({personaje.apretarGatillo()})
		keyboard.g().onPressDo({personaje.agarrar()})
		keyboard.h().onPressDo({personaje.cambiarDeArma()})
	}
	
	method configurarAcciones() {
		game.schedule(1000,{(currentMusic.play())})
		game.onCollideDo(stalin, {elemento => elemento.chocarConStalin()})
		//game.onTick(7000, "todos los enemigos disparan", {listaDeEnemigos.forEach({enemigo => /*if(enemigo.arma().tieneMunicion())*/ enemigo.disparar()})})
		// el enemigo puede disparar por mas q no tenga municion ya q sino el ujuego seria muy facil
		game.onTick(1000, "el enemigo patrulla", {listaDeEnemigos.forEach({enemigo => enemigo.avanzar()})})
		game.onTick(4000, "Disparan enemigos de la seccion", {self.disparenEnemigosDeSeccion()})
		
	}
	
	method enemigosEnSeccionJugador() = listaDeEnemigos.filter({enemigo => personaje.mismaSeccion(enemigo.seccionActual())})

	method disparenEnemigosDeSeccion(){
		game.schedule(10,{self.enemigosEnSeccionJugador().forEach({enemigo => enemigo.disparar()})})
	}

	method actualizarEnemigosVivos(enemigoMuerto){
		listaDeEnemigos.remove(enemigoMuerto)
	}
	
	method seTerminoElJuego(final){
		currentMusic.stop()
		game.removeTickEvent("Disparan enemigos de la seccion")
		final.musica().play()
		game.addVisual(final)
		final.tituloOpcional()
		game.schedule(10000 ,{game.stop()})
	}
	
	method menuInicio(){
		const musicaInicio = game.sound("cancionInicio.mp3")
		currentMusic = musicaInicio
		self.configurarJuego()
		game.addVisual(inicio)
		game.addVisual(titulo)
		game.addVisual(pressSpace)
		game.addVisual(teclas)
		keyboard.space().onPressDo({self.iniciar()})
		game.schedule(100,{musicaInicio.play()})
		game.start()
	}
}


object victoria{
	method position() = game.at(0,0)
	method image() = "ImagenVictoria.png"
	method musica() = game.sound("HimnoURSSCumbiaRemix.mp3")
	method tituloOpcional(){}
}

object derrota{
	method position() = game.at(0,0)
	method image() = "ImagenDerrota.png"
	method musica() = game.sound("HimnoUsa.mp3")
	method tituloOpcional(){
		game.addVisual(tituloPerdedor)
		const risaTrump = game.sound("risaTrump.mp3")
		risaTrump.play()
	}	
}

object inicio{
	method position() = game.at(0,0)
	method image() = "fondoInicio.png"
}

object titulo{
	method position() = game.at(8,12)
	method image() = "Titulo.png"
}

object pressSpace{
	method position() = game.at(8,5)
	method image() = "pressSpace.png"
}

object teclas{
	method position() = game.at(24,1)
	method image() = "Teclas.png"
}

object tituloPerdedor{
	method position() = game.at(12,19)
	method image() = "gameOver.png"
}

