:- encoding(utf8).

%  Procesamiento del lenguaje natural (simple)
%  1) Normaliza el texto: minúsculas, sin tildes, sin puntuación.
%  2) Lo separa en una lista de palabras (átomos).
%  3) Detecta entidades: especies, zonas, ecosistemas, clases, dietas...


% normalizar(+Texto, -Tokens)
%   "¿Qué come el Pudú?"  ->  [que, come, el, pudu]
normalizar(Texto, Tokens) :-
    string_lower(Texto, Min),
    string_chars(Min, Cs0),
    maplist(simplificar_char, Cs0, Cs1),
    string_chars(Limpio, Cs1),
    split_string(Limpio, " ", " ", Partes),
    exclude(==(""), Partes, Partes1),
    maplist([S, A]>>atom_string(A, S), Partes1, Tokens).

% Quita tildes y reemplaza todo lo que no sea letra/dígito por espacio
simplificar_char(C, R) :- tilde(C, R), !.
simplificar_char(C, C) :- char_type(C, alnum), !.
simplificar_char(_, ' ').

tilde('á', a). tilde('é', e). tilde('í', i). tilde('ó', o).
tilde('ú', u). tilde('ü', u). tilde('ñ', n).

% Utilidades de búsqueda en la lista de palabras

% contiene(+Tokens, +Frase): Frase (lista) aparece contigua en Tokens
contiene(Tokens, Frase) :-
    Frase \== [],
    append(_, Resto, Tokens),
    append(Frase, _, Resto), !.

% posicion(+Tokens, +Frase, -Pos): primera posición donde aparece Frase
posicion(Tokens, Frase, Pos) :-
    Frase \== [],
    append(Antes, Resto, Tokens),
    append(Frase, _, Resto), !,
    length(Antes, Pos).

% alguna_palabra(+Tokens, +Lista): alguna palabra de Lista está en Tokens
alguna_palabra(Tokens, Lista) :-
    member(P, Lista), memberchk(P, Tokens), !.

% tiene_prefijo(+Tokens, +Prefijo): alguna palabra empieza con Prefijo
tiene_prefijo(Tokens, Prefijo) :-
    member(T, Tokens),
    sub_atom(T, 0, _, _, Prefijo), !.

algun_prefijo(Tokens, Prefijos) :-
    member(P, Prefijos), tiene_prefijo(Tokens, P), !.

% Reconocimiento de entidades

% especies_mencionadas(+Tokens, -Especies)
%   Especies en el orden en que aparecen en la pregunta, sin repetir.
%   Si un alias largo contiene a otro corto (ej. "zorro chilote" y
%   "zorro") se cuenta una sola vez porque ambos apuntan al mismo Id.
especies_mencionadas(Tokens, Especies) :-
    findall(Pos-E, (alias(E, A), posicion(Tokens, A, Pos)), Pares),
    keysort(Pares, Ordenados),
    pairs_values(Ordenados, Es0),
    sin_repetidos(Es0, Especies).

% quitar_alias(+Tokens, +Especie, -Tokens2): elimina de la pregunta las
% palabras que forman el nombre de la especie (el alias mas largo).
quitar_alias(Tokens, E, Tokens2) :-
    findall(L-A, (alias(E, A), contiene(Tokens, A), length(A, L)), Pares),
    (   Pares == []
    ->  Tokens2 = Tokens
    ;   max_member(_-Alias, Pares),
        append(Antes, Resto, Tokens), append(Alias, Despues, Resto), !,
        append(Antes, Despues, Tokens2)
    ).

sin_repetidos([], []).
sin_repetidos([X|Xs], [X|Ys]) :-
    exclude(==(X), Xs, Xs1),
    sin_repetidos(Xs1, Ys).

% zonas_mencionadas(+Tokens, -Zonas)
%   "norte" sin "grande"/"chico" se interpreta como ambas zonas del norte.
zonas_mencionadas(Tokens, Zonas) :-
    findall(Z, (alias_zona(Z, A), contiene(Tokens, A)), Zs0),
    (   memberchk(norte, Tokens),
        \+ memberchk(norte_grande, Zs0),
        \+ memberchk(norte_chico, Zs0)
    ->  append(Zs0, [norte_grande, norte_chico], Zs1)
    ;   Zs1 = Zs0
    ),
    sort(Zs1, Zonas).

ecosistemas_mencionados(Tokens, Ecos) :-
    findall(E, (alias_ecosistema(E, A), contiene(Tokens, A)), L),
    sort(L, Ecos).

clases_mencionadas(Tokens, Clases) :-
    findall(C, (prefijo_clase(C, P), tiene_prefijo(Tokens, P)), L),
    sort(L, Clases).

dietas_mencionadas(Tokens, Dietas) :-
    findall(D, (prefijo_dieta(D, P), tiene_prefijo(Tokens, P)), L),
    sort(L, Dietas).

% Filtro de conservación pedido en la pregunta
%   casi amenazada -> nt ; vulnerable -> vu ;
%   "amenazada" / "peligro" / "extincion" -> amenazada (vu, en o cr)
%   "no amenazada" / "preocupacion menor" -> no amenazada
filtro_conservacion(Tokens, categoria(nt)) :-
    contiene(Tokens, [casi]), tiene_prefijo(Tokens, amenaz), !.
filtro_conservacion(Tokens, categoria(vu)) :-
    tiene_prefijo(Tokens, vulnerable), !.
filtro_conservacion(Tokens, categoria(cr)) :-
    contiene(Tokens, [peligro, critico]), !.
filtro_conservacion(Tokens, categoria(lc)) :-
    contiene(Tokens, [preocupacion, menor]), !.
filtro_conservacion(Tokens, no_amenazada) :-
    ( contiene(Tokens, [no, estan, amenazadas])
    ; contiene(Tokens, [no, amenazadas])
    ; contiene(Tokens, [no, estan, en, peligro])
    ; contiene(Tokens, [fuera, de, peligro])
    ), !.
filtro_conservacion(Tokens, amenazada) :-
    algun_prefijo(Tokens, [amenaz, peligro, extincion]), !.
