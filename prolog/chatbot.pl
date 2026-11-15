:- encoding(utf8).

%  Chatbot de Fauna Nativa de Chile
%  Uso:
%     swipl main.pl -> inicia la conversación
%     ?- preguntar("¿Qué come el puma?").
%     ?- responder("¿Dónde vive el huemul?", R).

:- set_prolog_flag(encoding, utf8).

:- ensure_loaded(kb).
:- ensure_loaded(reglas).
:- ensure_loaded(nlp).

% Bucle de conversación
main :-
    set_stream(user_input, encoding(utf8)),
    set_stream(user_output, encoding(utf8)),
    format("~n=== Chatbot Fauna Nativa de Chile (Prolog) ===~n"),
    format("Escribe tu pregunta, 'ayuda' para ver ejemplos o 'salir'.~n~n"),
    bucle.

bucle :-
    format("Tú: "), flush_output,
    read_line_to_string(user_input, Linea),
    (   ( Linea == end_of_file ; es_salida(Linea) )
    ->  format("Bot: ¡Hasta pronto!~n")
    ;   responder(Linea, R),
        format("Bot: ~w~n~n", [R]),
        bucle
    ).

es_salida(Linea) :-
    normalizar(Linea, T),
    alguna_palabra(T, [salir, chao, adios, exit]).

% Para pruebas desde la consola de Prolog
preguntar(Texto) :-
    responder(Texto, R),
    format("Tú:  ~w~nBot: ~w~n~n", [Texto, R]).

% responder(+Texto, -Respuesta)
%   1) normaliza  2) extrae entidades  3) detecta intención  4) responde
responder(Texto, Respuesta) :-
    normalizar(Texto, Tokens),
    especies_mencionadas(Tokens, Especies),
    (   intencion(Tokens, Especies, Respuesta0)
    ->  concordar_genero(Respuesta0, Respuesta)
    ;   respuesta_no_entendida(Respuesta)
    ).

% concordar_genero(+R0, -R): "el güiña" -> "la güiña", "del" -> "de la"...
concordar_genero(R0, R) :-
    findall(N, (femenino(E), especie(E, N, _)), Fems),
    foldl(ajustar_articulos, Fems, R0, R).

ajustar_articulos(N, R0, R) :-
    foldl([De-A, X0, X]>>( atom_concat(De, N, Viejo), atom_concat(A, N, Nuevo),
                           reemplazar(X0, Viejo, Nuevo, X) ),
          ['del '-'de la ', 'El '-'La ', 'el '-'la ', 'Un '-'Una ',
           'que el '-'que la '],
          R0, R).

reemplazar(Texto, Viejo, Nuevo, Resultado) :-
    atomic_list_concat(Partes, Viejo, Texto),
    atomic_list_concat(Partes, Nuevo, Resultado).

% Intenciones (se prueban en orden y gana la primera que aplica)

% Saludo y ayuda
intencion(T, [], R) :-
    alguna_palabra(T, [hola, buenas, buenos, saludos]), !,
    R = '¡Hola! Soy un chatbot sobre fauna nativa de Chile. Pregúntame qué come, dónde vive o en qué estado de conservación está una especie. Escribe "ayuda" para ver ejemplos.'.
intencion(T, _, R) :-
    alguna_palabra(T, [ayuda, ejemplos, help]), !,
    texto_ayuda(R).
intencion(T, [], R) :-
    alguna_palabra(T, [gracias]), !,
    R = '¡De nada! ¿Quieres saber algo más sobre la fauna chilena?'.

% Comparación de peso entre dos especies
intencion(T, [A, B|_], R) :-
    pide_comparacion(T), !,
    responder_comparacion(A, B, R).

% Convivencia entre dos especies
intencion(T, [A, B|_], R) :-
    algun_prefijo(T, [convive, comparte, junt, coincid, mismo, misma]), !,
    responder_convivencia(A, B, R).

% ¿Vive la especie X en la zona Z?
intencion(T, [E], R) :-
    pide_ubicacion(T),
    quitar_alias(T, E, T2), % evita que "picaflor de Arica" cuente como zona
    zonas_mencionadas(T2, [Z|Zs]), !,
    responder_vive_en(E, [Z|Zs], R).

% Cadena alimenticia de una especie
intencion(T, [E|_], R) :-
    tiene_prefijo(T, cadena), !,
    responder_cadena(E, R).

% ¿Quién se come a X? (depredadores)
intencion(T, [E|_], R) :-
    pide_depredadores(T), !,
    responder_depredadores(E, R).

% ¿Qué come X? (dieta)
intencion(T, [E|_], R) :-
    algun_prefijo(T, [come, comen, alimenta, dieta, caza, presas, aliment]), !,
    responder_dieta(E, R).

% Nombre científico
intencion(T, [E|_], R) :-
    algun_prefijo(T, [cientific, latin]), !,
    especie(E, N, C),
    format(atom(R), 'El nombre científico del ~w es ~w.', [N, C]).

% Estado de conservación
intencion(T, [E|_], R) :-
    algun_prefijo(T, [peligro, amenaz, conserva, extincion, extint,
                      estado, vulnerable, protegid, uicn]), !,
    responder_conservacion(E, R).

% Endemismo
intencion(T, [E|_], R) :-
    algun_prefijo(T, [endemic, exclusiv, solo, unicamente]), !,
    responder_endemica(E, R).

% Peso / tamaño
intencion(T, [E|_], R) :-
    algun_prefijo(T, [pesa, peso, kilo, tamano, grande, mide]), !,
    especie(E, N, _), peso_kg(E, P),
    format(atom(R), 'Un ~w adulto pesa aproximadamente ~w kg.', [N, P]).

% Hábitos de actividad
intencion(T, [E|_], R) :-
    algun_prefijo(T, [nocturn, diurn, crepuscular, activ, habito, horario]), !,
    especie(E, N, _), habito(E, H),
    format(atom(R), 'El ~w es ~w.', [N, H]).

% Dónde vive
intencion(T, [E|_], R) :-
    pide_ubicacion(T), !,
    responder_ubicacion(E, R).

% Símbolo nacional
intencion(T, [E|_], R) :-
    algun_prefijo(T, [simbolo, escudo, emblema]), !,
    especie(E, N, _),
    (   simbolo_nacional(E)
    ->  format(atom(R), 'Sí, el ~w es un símbolo nacional: aparece en el escudo de Chile.', [N])
    ;   format(atom(R), 'No, el ~w no aparece en el escudo de Chile. Los símbolos del escudo son el huemul y el cóndor andino.', [N])
    ).

% Dato curioso
intencion(T, [E|_], R) :-
    algun_prefijo(T, [curios, interesant, sabias]), !,
    especie(E, N, _), dato_curioso(E, D),
    format(atom(R), 'Dato curioso del ~w: ~w', [N, D]).

% Preguntas generales sin especie
intencion(T, [], R) :-
    algun_prefijo(T, [simbolo, escudo, emblema]), !,
    findall(E, simbolo_nacional(E), Es),
    lista_nombres(Es, L),
    format(atom(R), 'Los animales del escudo nacional de Chile son: ~w.', [L]).

intencion(T, [], R) :-
    algun_prefijo(T, [prioridad, priorit, urgente]), !,
    findall(E, prioridad_conservacion(E), Es),
    lista_nombres(Es, L),
    format(atom(R), 'Las especies con prioridad de conservación (endémicas y amenazadas) son: ~w.', [L]).

intencion(T, [], R) :-
    ( ( tiene_prefijo(T, depredador), memberchk(tope, T) ) ; tiene_prefijo(T, superdepredador)
    ; contiene(T, [cima, de, la, cadena]) ), !,
    findall(E, depredador_tope(E), Es),
    lista_nombres(Es, L),
    format(atom(R), 'Según la base de conocimiento, los depredadores tope (cazan y nadie los caza) son: ~w.', [L]).

% Superlativos sobre un conjunto filtrado
intencion(T, Especies, R) :-
    superlativo(T, Tipo), !,
    (   Especies = [_, _|_] -> Candidatas = Especies
    ;   especies_filtradas(T, Candidatas, _)
    ),
    Candidatas \== [],
    responder_superlativo(Tipo, Candidatas, R).

% Listados con filtros (clase, dieta, zona, etc.)
intencion(T, [], R) :-
    especies_filtradas(T, Lista, Filtros),
    Filtros \== [], !,
    responder_listado(T, Lista, Filtros, R).

% ¿Cuántas especies hay?
intencion(T, [], R) :-
    tiene_prefijo(T, cuant), !,
    aggregate_all(count, especie(_, _, _), N),
    format(atom(R), 'La base de conocimiento contiene ~w especies de fauna nativa de Chile.', [N]).

% Si solo se nombra una especie: ficha completa
intencion(_, [E|_], R) :-
    ficha(E, R).

% Detectores de tipo de pregunta
pide_comparacion(T) :-
    (   algun_prefijo(T, [compar, diferencia, versus, vs])
    ;   contiene(T, [mas, pesado]) ; contiene(T, [mas, pesada])
    ;   contiene(T, [pesa, mas])   ; contiene(T, [mas, grande])
    ;   contiene(T, [mas, liviano]); contiene(T, [mas, pequeno])
    ;   contiene(T, [mas, chico])
    ), !.

pide_depredadores(T) :-
    (   contiene(T, [quien, se, come]) ; contiene(T, [quien, come])
    ;   contiene(T, [quienes, comen]) ; contiene(T, [quien, caza])
    ;   contiene(T, [quienes, cazan]) ; contiene(T, [es, presa])
    ;   contiene(T, [son, presa])     ; tiene_prefijo(T, depredador)
    ;   contiene(T, [enemigos, naturales])
    ), !.

pide_ubicacion(T) :-
    algun_prefijo(T, [donde, habita, vive, viven, encuentr, ubica, zona,
                      region, distribu, ver, observar, ecosistema, habitat]), !.

superlativo(T, max) :-
    ( contiene(T, [mas, pesado]) ; contiene(T, [mas, pesada])
    ; contiene(T, [mas, grande]) ; contiene(T, [pesa, mas])
    ; contiene(T, [mayor, peso]) ), !.
superlativo(T, min) :-
    ( contiene(T, [mas, liviano]) ; contiene(T, [mas, liviana])
    ; contiene(T, [mas, pequeno]) ; contiene(T, [mas, pequena])
    ; contiene(T, [mas, chico])   ; contiene(T, [mas, chica])
    ; contiene(T, [menor, peso]) ), !.

% Filtros combinados
%   especies_filtradas(+Tokens, -Especies, -FiltrosUsados)
%   Aplica todos los filtros detectados en la pregunta (conjunción).
especies_filtradas(T, Especies, Filtros) :-
    filtros(T, Filtros),
    findall(E, ( especie(E, _, _), cumple_todos(E, Filtros) ), Especies).

filtros(T, Filtros) :-
    clases_mencionadas(T, Cs),
    dietas_mencionadas(T, Ds),
    zonas_mencionadas(T, Zs),
    ecosistemas_mencionados(T, Es),
    findall(F, filtro_simple(T, F), Simples),
    Filtros0 = [clase(Cs), dieta(Ds), zona(Zs), eco(Es) | Simples],
    exclude(filtro_vacio, Filtros0, Filtros).

filtro_vacio(clase([])).
filtro_vacio(dieta([])).
filtro_vacio(zona([])).
filtro_vacio(eco([])).

filtro_simple(T, conservacion(F)) :- filtro_conservacion(T, F).
filtro_simple(T, endemica)        :- tiene_prefijo(T, endemic).
filtro_simple(T, habito(nocturno)):- tiene_prefijo(T, nocturn).
filtro_simple(T, habito(diurno))  :- tiene_prefijo(T, diurn).
filtro_simple(T, simbolo)         :- algun_prefijo(T, [simbolo, escudo]).

cumple_todos(E, Filtros) :- forall(member(F, Filtros), cumple(E, F)).

% Dentro de un mismo tipo de filtro se acepta cualquiera (disyunción)
cumple(E, clase(Cs))  :- clase(E, C), memberchk(C, Cs).
cumple(E, dieta(Ds))  :- dieta(E, D), memberchk(D, Ds).
cumple(E, zona(Zs))   :- member(Z, Zs), habita_zona(E, Z), !.
cumple(E, eco(Es))    :- member(X, Es), habita_ecosistema(E, X), !.
cumple(E, conservacion(amenazada))    :- amenazada(E).
cumple(E, conservacion(no_amenazada)) :- no_amenazada(E).
cumple(E, conservacion(categoria(C))) :- estado_conservacion(E, C).
cumple(E, endemica)   :- endemica_de_chile(E).
cumple(E, habito(H))  :- habito(E, H).
cumple(E, simbolo)    :- simbolo_nacional(E).

% Construcción de respuestas
responder_dieta(E, R) :-
    especie(E, N, _), dieta(E, D), nombre_dieta(D, DT),
    findall(P, come(E, P), Ps),
    (   Ps == []
    ->  format(atom(R), 'El ~w es ~w.', [N, DT])
    ;   lista_nombres(Ps, L),
        format(atom(R), 'El ~w es ~w. Entre sus presas registradas están: ~w.', [N, DT, L])
    ).

responder_depredadores(E, R) :-
    especie(E, N, _),
    findall(X, come(X, E), Xs),
    (   Xs \== []
    ->  lista_nombres(Xs, L),
        format(atom(R), 'El ~w es presa de: ~w.', [N, L])
    ;   depredador_tope(E)
    ->  format(atom(R), 'El ~w no tiene depredadores registrados en la base: es un depredador tope.', [N])
    ;   format(atom(R), 'No tengo registrados depredadores naturales del ~w en la base de conocimiento.', [N])
    ).

responder_cadena(E, R) :-
    especie(E, N, _),
    findall(Y, cadena_alimenticia(E, Y), Abajo0), sort(Abajo0, Abajo),
    findall(X, cadena_alimenticia(X, E), Arriba0), sort(Arriba0, Arriba),
    (   Abajo == [] -> TA = 'no depreda a ninguna especie de la base'
    ;   lista_nombres(Abajo, LA),
        format(atom(TA), 'se alimenta, directa o indirectamente, de ~w', [LA])
    ),
    (   Arriba == [] -> TB = 'ninguna especie de la base lo depreda'
    ;   lista_nombres(Arriba, LB),
        format(atom(TB), 'es alimento, directo o indirecto, de ~w', [LB])
    ),
    format(atom(R), 'Cadena alimenticia del ~w: ~w; y ~w.', [N, TA, TB]).

responder_conservacion(E, R) :-
    especie(E, N, _), estado_conservacion(E, C), nombre_categoria(C, CT),
    (   prioridad_conservacion(E)
    ->  Extra = ' Además es endémica de Chile, por lo que es prioridad de conservación.'
    ;   amenazada(E)
    ->  Extra = ' Es una especie amenazada.'
    ;   Extra = ' No se considera amenazada.'
    ),
    format(atom(R), 'El estado de conservación del ~w es: ~w (UICN).~w', [N, CT, Extra]).

responder_endemica(E, R) :-
    especie(E, N, _),
    ( femenino(E) -> Adj = 'endémica' ; Adj = 'endémico' ),
    (   endemica_de_chile(E)
    ->  format(atom(R), 'Sí, el ~w es ~w de Chile: no vive de forma natural en ningún otro país.', [N, Adj])
    ;   format(atom(R), 'No, el ~w no es ~w de Chile; también habita en otros países.', [N, Adj])
    ).

responder_ubicacion(E, R) :-
    especie(E, N, _),
    findall(Z, habita_zona(E, Z), Zs), nombres_zonas(Zs, TZ),
    findall(Ec, habita_ecosistema(E, Ec), Es), nombres_ecos(Es, TE),
    format(atom(R), 'El ~w habita en: ~w. Su hábitat es: ~w.', [N, TZ, TE]).

responder_vive_en(E, Zonas, R) :-
    especie(E, N, _),
    include([Z]>>habita_zona(E, Z), Zonas, Si),
    (   Si \== []
    ->  nombres_zonas(Si, TZ),
        format(atom(R), 'Sí, el ~w habita en ~w.', [N, TZ])
    ;   findall(Z, habita_zona(E, Z), Todas), nombres_zonas(Todas, TT),
        nombres_zonas(Zonas, TP),
        format(atom(R), 'No, el ~w no habita en ~w. Vive en: ~w.', [N, TP, TT])
    ).

responder_comparacion(A, B, R) :-
    especie(A, NA, _), especie(B, NB, _),
    peso_kg(A, PA), peso_kg(B, PB),
    (   mas_pesado(A, B)
    ->  format(atom(R), 'El ~w (~w kg) es más pesado que el ~w (~w kg).', [NA, PA, NB, PB])
    ;   mas_pesado(B, A)
    ->  format(atom(R), 'El ~w (~w kg) es más pesado que el ~w (~w kg).', [NB, PB, NA, PA])
    ;   format(atom(R), 'El ~w y el ~w pesan aproximadamente lo mismo (~w kg).', [NA, NB, PA])
    ).

responder_convivencia(A, B, R) :-
    especie(A, NA, _), especie(B, NB, _),
    zonas_comunes(A, B, Zs),
    ecosistemas_comunes(A, B, Es),
    (   conviven(A, B)
    ->  nombres_zonas(Zs, TZ), nombres_ecos(Es, TE),
        format(atom(R), 'Sí, el ~w y el ~w conviven: comparten ~w, en ~w.', [NA, NB, TZ, TE])
    ;   Zs \== []
    ->  nombres_zonas(Zs, TZ),
        format(atom(R), 'Comparten zona (~w), pero no el mismo ecosistema, así que no conviven directamente.', [TZ])
    ;   format(atom(R), 'No, el ~w y el ~w no comparten ninguna zona de Chile.', [NA, NB])
    ).

responder_superlativo(max, Lista, R) :-
    mas_pesada_de(Lista, E), especie(E, N, _), peso_kg(E, P),
    format(atom(R), 'El más pesado es el ~w, con aproximadamente ~w kg.', [N, P]).
responder_superlativo(min, Lista, R) :-
    mas_liviana_de(Lista, E), especie(E, N, _), peso_kg(E, P),
    format(atom(R), 'El más liviano es el ~w, con aproximadamente ~w kg.', [N, P]).

responder_listado(T, Lista, Filtros, R) :-
    describir_filtros(Filtros, Desc),
    length(Lista, N),
    (   Lista == []
    ->  format(atom(R), 'No encontré especies que cumplan: ~w.', [Desc])
    ;   tiene_prefijo(T, cuant)
    ->  lista_nombres(Lista, L),
        format(atom(R), 'Hay ~w especie(s) que cumplen (~w): ~w.', [N, Desc, L])
    ;   lista_nombres(Lista, L),
        format(atom(R), 'Especies que cumplen (~w): ~w.', [Desc, L])
    ).

ficha(E, R) :-
    especie(E, N, C), clase(E, Cl), nombre_clase(Cl, ClT, _),
    dieta(E, D), nombre_dieta(D, DT),
    estado_conservacion(E, Ca), nombre_categoria(Ca, CaT),
    findall(Z, habita_zona(E, Z), Zs), nombres_zonas(Zs, TZ),
    (   endemica_de_chile(E)
    ->  ( femenino(E) -> End = ' Es endémica de Chile.' ; End = ' Es endémico de Chile.' )
    ;   End = ''
    ),
    (   dato_curioso(E, Dato) -> true ; Dato = '' ),
    format(atom(R), 'El ~w (~w) es un ~w ~w. Habita en ~w. Estado de conservación: ~w.~w ~w',
           [N, C, ClT, DT, TZ, CaT, End, Dato]).

respuesta_no_entendida('No logré entender la pregunta o no tengo esa información en mi base de conocimiento. Escribe "ayuda" para ver ejemplos de preguntas.').

texto_ayuda('Puedes preguntarme, por ejemplo: "¿Qué come el puma?", "¿Dónde vive el huemul?", "¿El pudú está en peligro?", "¿Qué mamíferos amenazados viven en la zona sur?", "¿Cuál es el ave más pesada?", "¿Quién se come al guanaco?", "¿El degú es endémico?", "¿Conviven el pudú y el huemul?", "¿Qué especies tienen prioridad de conservación?".').

% UTILIDADES DE TEXTO
lista_nombres(Ids, Texto) :-
    maplist([I, N]>>especie(I, N, _), Ids, Ns),
    unir_y(Ns, Texto).

nombres_zonas(Zs, Texto) :-
    maplist([Z, T]>>(nombre_zona(Z, N, Reg), format(atom(T), '~w (~w)', [N, Reg])), Zs, Ts),
    unir_y(Ts, Texto).

nombres_ecos(Es, Texto) :-
    maplist([E, T]>>nombre_ecosistema(E, T), Es, Ts),
    unir_y(Ts, Texto).

% unir_y([a,b,c], 'a, b y c')
unir_y([], '').
unir_y([X], X) :- !.
unir_y(Xs, Texto) :-
    append(Init, [Ult], Xs),
    atomic_list_concat(Init, ', ', T0),
    format(atom(Texto), '~w y ~w', [T0, Ult]).

describir_filtros(Filtros, Desc) :-
    maplist(describir_filtro, Filtros, Ds),
    atomic_list_concat(Ds, '; ', Desc).

describir_filtro(clase(Cs), D) :-
    maplist([C, T]>>nombre_clase(C, _, T), Cs, Ts), unir_o(Ts, X),
    format(atom(D), 'clase: ~w', [X]).
describir_filtro(dieta(Ds0), D) :-
    maplist([C, T]>>nombre_dieta(C, T), Ds0, Ts), unir_o(Ts, X),
    format(atom(D), 'dieta: ~w', [X]).
describir_filtro(zona(Zs), D) :-
    maplist([Z, T]>>nombre_zona(Z, T, _), Zs, Ts), unir_o(Ts, X),
    format(atom(D), 'zona: ~w', [X]).
describir_filtro(eco(Es), D) :-
    nombres_ecos_o(Es, X), format(atom(D), 'ecosistema: ~w', [X]).
describir_filtro(conservacion(amenazada), 'amenazadas (VU, EN o CR)').
describir_filtro(conservacion(no_amenazada), 'no amenazadas').
describir_filtro(conservacion(categoria(C)), D) :-
    nombre_categoria(C, T), format(atom(D), 'estado: ~w', [T]).
describir_filtro(endemica, 'endémicas de Chile').
describir_filtro(habito(H), D) :- format(atom(D), 'hábito ~w', [H]).
describir_filtro(simbolo, 'símbolo nacional').

nombres_ecos_o(Es, X) :- maplist([E, T]>>nombre_ecosistema(E, T), Es, Ts), unir_o(Ts, X).

unir_o([], '').
unir_o([X], X) :- !.
unir_o(Xs, Texto) :-
    append(Init, [Ult], Xs),
    atomic_list_concat(Init, ', ', T0),
    format(atom(Texto), '~w o ~w', [T0, Ult]).
