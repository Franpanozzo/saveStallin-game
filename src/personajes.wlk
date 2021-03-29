import wollok.game.*
import movimientos.*
import armas.*
import saveStalin.*
import mapa.*

class Soldado{
	
    var property arma = new AK47()  //se usa el property para los test armas.first()
	var position = game.at(2,3)
	var property direccion = derecha
	var direccionDeLaMira = derecha
	const nombre = "Enemigo"
	
	
	//GETTER
	
	
	method position() = position

	method image() = direccionDeLaMira.imageDireccion(nombre + arma.nombre())

    method direccion() = direccion
    
    method seccionActual() = seccion.seccionActual(self.position())
	
	 // CONSULTAS
	 

    method puedeAvanzar() = game.getObjectsIn(direccion.posicionSiguiente(position)).all({obj => obj.esAtravesable()})


    //ACCIONES
    
	
	method avanzar(){
		if(self.puedeAvanzar()) position = direccion.posicionSiguiente(position)
		else self.chocoContraLaPared()
	}

	method chocoContraLaPared(){}


    method disparar(){
        const tiro = new Bala(
                direccion = direccionDeLaMira,
                position = direccionDeLaMira.posicionSiguiente(position),
                damage = arma.damage())
        tiro.salirBala()
    }

     method recibirDisparo(unaBala){
        self.causarDanio(unaBala.damage())
        unaBala.eliminar()
    }
    
    method causarDanio(unDanio){}
    
     method chocarConStalin(){
    }
    
    method esAtravesable() = false
		
}


object personaje inherits Soldado(arma = pistola, direccion = derecha, direccionDeLaMira = derecha, nombre = "Survivor"){

    var property armaPrimaria = null  //se usa el property para los test
    const armaSecundaria = pistola


    // GETTER
	
    method vida() = vidaPersonaje.vida()

    method armaSecundaria() = armaSecundaria

	method mismaSeccion(seccionActual) = seccionActual == self.seccionActual()
	
	method municionesDisponibles() = arma.municionDisponible()
	
    //ACCIONES

    method moverse(nuevaDireccion){
        direccion = nuevaDireccion
        direccionDeLaMira = nuevaDireccion
        self.avanzar()
    }

    method apretarGatillo(){
        if(arma.tieneMunicion()) self.disparar()
		else self.armaSinMunicion()
    }

    method armaSinMunicion(){
        arma = armaSecundaria
        armaPrimaria = null
    }

    method morir(){  
        game.say(self,"Me muerooooo")
        saveStalin.seTerminoElJuego(derrota)
    }
   
    method agarrar(){
        game.getObjectsIn(position).forEach({obj => obj.serAgarrado()})
    }

    method serAgarrado(){}

    method agarrarArma(unArma){
    	const agarrar = game.sound("agarrarArma.mp3")
    	agarrar.play()
        armaPrimaria = unArma
        arma = armaPrimaria
    }

    method cambiarDeArma(){
        if(armaPrimaria != null){
            if(arma == armaPrimaria) arma = armaSecundaria
            else arma = armaPrimaria 
        }
    }

	
	// OVERRIDES
	
	
	override method disparar(){
		super()
		arma.restarMunicion()
        const sonidoBala = game.sound("shot.mp3")
        sonidoBala.play()
	}
	
	override method causarDanio(unDanio){
		vidaPersonaje.causarDanio(unDanio)
	}
	
	override method chocarConStalin(){
    	stalin.seguirAlPersonaje()
    	//mapa.popZonaDeRescate()
    }
}

object stalin{

	var property movimiento = prisionero  //es property por los test

	method position() = movimiento.position()
	
	method direccion() = movimiento.direccion()
	
	method image() = self.direccion().imageDireccion("Stalin")

	method recibirDisparo(unaBala){
		game.say(self,"AHHHH")
		unaBala.eliminar()
		saveStalin.seTerminoElJuego(derrota) // cambio de escena que perdes
	}

	method seguirAlPersonaje(){
		movimiento = escapar
	}
	
	method esAtravesable() = true
}


class Enemigo inherits Soldado{
    var property vida = 25
	
	
    method morir(){
    	const enemigoMuere = game.sound("enemigoMuere.mp3")
    	enemigoMuere.play()
        game.removeVisual(self)
        saveStalin.actualizarEnemigosVivos(self)
    }

    //method chocarConStalin(){}
	
	// OVERRIDE
	
	override method chocoContraLaPared(){
		direccion = direccion.direccionOpuesta()
		position = direccion.posicionSiguiente(position)
	}
	
	override method causarDanio(unDanio){
		vida -= unDanio
		if(vida<=0) {
            self.morir()
	    }
	}
}

