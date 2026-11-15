:- encoding(utf8).

%  Reglas de inferencia (lógica de primer orden)
%  Cada regla incluye su equivalente en LPO como comentario.

% Estado de conservación

% ∀x ∀c ( Estado(x,c) ∧ c ∈ {vu,en,cr} → Amenazada(x) )
amenazada(X) :-
    estado_conservacion(X, C),
    memberchk(C, [vu, en, cr]).

% ∀x ( Especie(x) ∧ ¬Amenazada(x) → NoAmenazada(x) )
no_amenazada(X) :-
    especie(X, _, _),
    \+ amenazada(X).

% ∀x ( Endemica(x) ∧ Amenazada(x) → PrioridadConservacion(x) )
prioridad_conservacion(X) :-
    endemica_de_chile(X),
    amenazada(X).

% ∀x ( Amenazada(x) ∧ ∃!z HabitaZona(x,z) → DistribucionRestringida(x) )
distribucion_restringida(X) :-
    amenazada(X),
    numero_zonas(X, 1).

% Relaciones tróficas (cadena alimenticia)

% ∀x ∀y ( Come(x,y) → DepredadorDe(x,y) )
depredador_de(X, Y) :- come(X, Y).

% ∀x ∀y ( Come(x,y) → PresaDe(y,x) )
presa_de(Y, X) :- come(X, Y).

% Clausura transitiva:
% ∀x ∀y ( Come(x,y) → Cadena(x,y) )
% ∀x ∀y ∀z ( Come(x,y) ∧ Cadena(y,z) → Cadena(x,z) )
cadena_alimenticia(X, Y) :- come(X, Y).
cadena_alimenticia(X, Z) :- come(X, Y), cadena_alimenticia(Y, Z).

% ∀x ( ∃y Come(x,y) ∧ ¬∃z Come(z,x) → DepredadorTope(x) )
depredador_tope(X) :-
    especie(X, _, _),
    once(come(X, _)),
    \+ come(_, X).

% Distribución geográfica y ecológica

% ∀x ∀y ∀z ( HabitaZona(x,z) ∧ HabitaZona(y,z) ∧ x≠y → CompartenZona(x,y,z) )
comparten_zona(X, Y, Z) :-
    habita_zona(X, Z),
    habita_zona(Y, Z),
    X \== Y.

% ∀x ∀y ( ∃z CompartenZona(x,y,z) ∧ ∃e (HabitaEco(x,e) ∧ HabitaEco(y,e)) → Conviven(x,y) )
conviven(X, Y) :-
    comparten_zona(X, Y, _),
    habita_ecosistema(X, E),
    habita_ecosistema(Y, E), !.

% Ecosistemas compartidos por dos especies (sin repetidos)
ecosistemas_comunes(X, Y, Es) :-
    findall(E, (habita_ecosistema(X, E), habita_ecosistema(Y, E)), L),
    sort(L, Es).

zonas_comunes(X, Y, Zs) :-
    findall(Z, comparten_zona(X, Y, Z), L),
    sort(L, Zs).

numero_zonas(X, N) :-
    especie(X, _, _),
    aggregate_all(count, habita_zona(X, _), N).

% ∀x ( |{z : HabitaZona(x,z)}| ≥ 4 → AmpliaDistribucion(x) )
amplia_distribucion(X) :-
    numero_zonas(X, N),
    N >= 4.

% Se puede observar la especie x en la zona z
se_puede_ver_en(X, Z) :- habita_zona(X, Z).

% Tamaño
% ∀x ∀y ( Peso(x,px) ∧ Peso(y,py) ∧ px > py → MasPesado(x,y) )
mas_pesado(X, Y) :-
    peso_kg(X, PX),
    peso_kg(Y, PY),
    PX > PY.

% ∀x ( Dieta(x,herbivoro) ∧ Peso(x,p) ∧ p ≥ 20 → HerbivoroGrande(x) )
herbivoro_grande(X) :-
    dieta(X, herbivoro),
    peso_kg(X, P),
    P >= 20.

% La especie mas pesada / liviana de una lista no vacía
mas_pesada_de(Lista, X) :-
    findall(P-E, (member(E, Lista), peso_kg(E, P)), Pares),
    max_member(_-X, Pares).

mas_liviana_de(Lista, X) :-
    findall(P-E, (member(E, Lista), peso_kg(E, P)), Pares),
    min_member(_-X, Pares).
