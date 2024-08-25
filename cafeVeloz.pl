
% Jugadores conocidos
jugador(maradona).
jugador(chamot).
jugador(balbo).
jugador(caniggia).
jugador(passarella).
jugador(pedemonti).
jugador(basualdo).



% relaciona la máxima cantidad de un producto que 1 jugador puede ingerir
maximo(cocacola, 3). 
maximo(gatoreit, 1).
maximo(naranju, 5).

% relaciona las sustancias que tiene un compuesto
composicion(cafeVeloz, [efedrina, ajipupa, extasis, whisky, cafe]).

% sustancias prohibidas por la asociación
sustanciaProhibida(efedrina). 
sustanciaProhibida(cocaina).

% Relaciona lo que toma cada jugador
tomo(maradona, sustancia(efedrina)).
tomo(maradona, compuesto(cafeVeloz)).
tomo(caniggia, producto(cocacola, 2)).
tomo(chamot, compuesto(cafeVeloz)).
tomo(balbo, producto(gatoreit, 2)).

% Punto 1

tomo(passarella, Sustancia) :- 
    tomo(_, Sustancia),
    not(tomo(maradona, Sustancia)). 

tomo(pedemonti, Sustancia) :- 
    tomo(maradona, Sustancia),
    tomo(chamot, Sustancia). 


% Punto 2

puedeSerSuspendido(Jugador) :- 
    tomo(Jugador, Ingerido), 
    tieneFalopa(Ingerido). 

tieneFalopa(sustancia(Sustancia)) :- 
    sustanciaProhibida(Sustancia). 

tieneFalopa(compuesto(Compuesto)) :- 
    composicion(Compuesto, Sustancias), 
    member(SustanciaProhibida, Sustancias),
    sustanciaProhibida(SustanciaProhibida).

tieneFalopa(producto(Producto, CantidadInjerida)) :-
    maximo(Producto, MaximoProducto),
    CantidadInjerida > MaximoProducto.

% Punto 3

amigo(maradona, caniggia).
amigo(caniggia, balbo).
amigo(balbo, chamot).
amigo(balbo, pedemonti).
  
malaInfluencia(Jugador, OtroJugador) :- 
    puedenSerSuspendidos(Jugador, OtroJugador),
    seConocen(Jugador, OtroJugador).

puedenSerSuspendidos(Jugador, OtroJugador) :-
    puedeSerSuspendido(Jugador),
    puedeSerSuspendido(OtroJugador). 

seConocen(Jugador, OtroJugador) :- 
    amigo(Jugador, OtroJugador). 

seConocen(Jugador, OtroJugador) :- 
    amigo(Jugador, Conocido),
    seConocen(Conocido, OtroJugador). 

% Punto 4 

atiende(cahe, maradona).
atiende(cahe, chamot).
atiende(cahe, balbo).
atiende(zin, caniggia).
atiende(cureta, pedemonti).
atiende(cureta, basualdo).

chanta(Medico) :-
    atiende(Medico,_),
    forall(atiende(Medico, Jugador), puedeSerSuspendido(Jugador)). 

% Punto 5

nivelFalopez(efedrina, 10).
nivelFalopez(cocaina, 100).
nivelFalopez(extasis, 120).
nivelFalopez(omeprazol, 5).

cuantaFalopaTiene(Jugador, NivelDeAlteracion) :-
    tomo(Jugador, Sustancia),
    nivelDeAlteracionTomada(Sustancia, NivelDeAlteracion).

nivelDeAlteracionTomada(producto(_,_), 0).
nivelDeAlteracionTomada(sustancia(Tipo), NivelDeAlteracion) :-
    nivelFalopez(Tipo, NivelDeAlteracion). 

nivelDeAlteracionTomada(compuesto(SustanciaComp), NivelDeAlteracion) :-
    composicion(SustanciaComp, Ingredientes),
    findall(Nivel, nivelComposicion(Ingredientes, Nivel), Niveles),
    sumlist(Niveles, NivelDeAlteracion).

nivelComposicion(Ingredientes, Nivel) :-
    member(Componente, Ingredientes),
    nivelFalopez(Componente, Nivel). 

% Punto 6

medicoConProblemas(Medico) :-
    atiende(Medico,_),
    atiendeMuchosQuilomberos(Medico).

atiendeMuchosQuilomberos(Medico) :-
    findall(Jugador, quilomberoAtendido(Medico,Jugador), JugadoresQuilomberos),
    length(JugadoresQuilomberos, CantJugadores),
    CantJugadores > 3. 

quilomberoAtendido(Medico, Jugador) :-
    atiende(Medico, Jugador),
    quilombero(Jugador). 
    
quilombero(Jugador) :- 
    puedeSerSuspendido(Jugador). 

quilombero(Jugador) :- 
    seConocen(Jugador, maradona). 
    
    