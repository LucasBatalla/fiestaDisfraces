class Fiesta{
	var lugar
	var property fecha
	var invitados
	
	method esUnBodrio(){
		return invitados.all({invitado => !invitado.estaConformeConDisfraz()})
	}
	
	method mejorDisfraz(){
		return (self.disfracesDeInvitados()).max({disfraz => disfraz.puntaje()})
	}
	
	method disfracesDeInvitados(){
		return invitados.filter({invitado => invitado.disfraz()})
	}
	
	method agregarInvitado(persona){
		self.validarCarga(persona)
	}	
	
	method validarCarga(posibleInvitado){
		if(invitados.contains(posibleInvitado)){
			throw new DomainException(message = "Ya esta en la lista de invitados!")
		} else if(posibleInvitado.estaDisfrazado()){
			invitados.add(posibleInvitado)
		} else
		throw new DomainException(message = "No esta disfrazado!")
	}
	
	method esInolvidable(){
		return invitados.all({invitado => (invitado.esSexy() and invitado.estaConformeConDisfraz())})
	}
	
} 
 


class Invitado{
	var property disfraz
	var property fiesta
	var property edad
	var personalidad
	var criterioConformidad
	
	method estaDisfrazado(){
		return disfraz.puntaje(self) > 0
	}
	
	method puntosDisfraz(){
		return disfraz.puntaje(self)
	}
	
	method esSexy(){
		return (self.tipoPersonalidad()).esSexy(self)
	}
	
	method tipoPersonalidad(){
		return personalidad.tipo()
	}
	
	method estaConformeConDisfraz(){
		return disfraz.puntaje(self) > 10 and criterioConformidad.conforme()
	}
	
	method realizarCanje(persona){
		self.validarCanje(persona)
		self.cambiarTrajeCon(persona)
	}
	
	method validarCanje(persona){
		return self.estaEnMismaFiestaQue(persona) and
		(!self.estaConformeConDisfraz() or !persona.estaConformeConDisfraz()) and 
		(self.cambiandoTrajesEstaConforme(persona) and 
		(persona.cambiandoTrajesEstaConforme(self))) 
	}
	
	method cambiarTrajeCon(persona){
		const disfrazACambiar = disfraz
		disfraz = persona.disfraz()
		persona.disfraz(disfrazACambiar)
	}
	
	method estaEnMismaFiestaQue(persona){
		return fiesta == persona.fiesta()
	}
	
	method cambiandoTrajesEstaConforme(persona){
		const disfrazOriginal = disfraz
		disfraz = persona.disfraz()
		if(self.estaConformeConDisfraz()){
		   disfraz = disfrazOriginal
           return true
		} else 
		disfraz = disfrazOriginal
		return false
	   }
	
}

class Disfraz{
	var property nombre
	var property fechaDeCompra
	var property fechaDeConfeccion
	var property nivelDeGracia
	var caracteristicasDisfraz
	
	method puntaje(disfrazado){
		return (caracteristicasDisfraz.map({caracteristica => caracteristica.puntos(disfrazado,self)})).sum()
	}
	
}


object gracioso{
	
	method puntos(disfrazado,disfraz){
		if(self.tieneMasDeCincuenta(disfrazado)){
			return disfraz.nivelDeGracia() * 3
		} else 
		
		return disfraz.nivelDeGracia()
	}
	method tieneMasDeCincuenta(disfrazado){
		return disfrazado.edad() > 50
	}
}

object tobara{
	
	method puntos(disfrazado, disfraz){
		if(self.comproConAnticipacion(disfrazado, disfraz)){
			return 5
		} else 
		
		return 3
	}
	
	method comproConAnticipacion(disfrazado,disfraz){
		return (disfrazado.fiesta()).fecha() - disfraz.fechaDeCompra() >= 2
	}
	
	
}

class Careta{
	var personaje
	
	method puntos(disfraz, disfrazado){
		return personaje.puntaje()
	}
}

object sexies{
	
	method puntos(disfraz, disfrazado){
		if(disfrazado.esSexy()){
			return 15
		} else
		return 2
	}
	
}

class Personaje{
	var puntos
	
	method puntaje(){
		return puntos
	}
}

object alegre{
	
	method esSexy(disfrazdo){
		return false
	}
	
	method tipo(){
		return self
	}
}

object taciturna{
	
	method esSexy(disfrazado){
		return disfrazado.edad() > 30
	}
	
	method tipo(){
		return self
	}
}


class Cambiante{
	const personalidades = [alegre, taciturna]
	
	method tipo(){
		return personalidades.anyOne()
	}
	
}


object caprichoso{
	
	method conforme(disfraz){
		return self.nombrePar(disfraz.nombre())
	}
	
	method nombrePar(nombreDisfraz){
		return (nombreDisfraz.length()).even()
	}
	
}

object pretencioso{
	
	method conforme(disfraz){
		return self.recientementeConfeccionado(disfraz)
	}
	
	method recientementeConfeccionado(disfraz){
		return disfraz.fechaDeCompra() - disfraz.fechaDeConfeccion() < 30
		
	}
}


class Numerologo{
	var numeroPreferido
	
	
	method conforme(disfraz){
		return disfraz.puntaje() == numeroPreferido
	}
	
	method cambiarNumero(nuevoNumero){
		numeroPreferido = nuevoNumero
	}
}










