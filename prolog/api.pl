:- encoding(utf8).
/*  Interfaz para el backend en Python (Entrega 2).
    No modifica el chatbot de la Entrega 1: solo lo carga y expone dos usos.

      swipl api.pl --stdin   lee una pregunta desde la entrada estándar y responde
      swipl api.pl --json    exporta la base de conocimiento en JSON (la usa el LLM)
*/
:- ensure_loaded(chatbot).
:- use_module(library(http/json)).
:- initialization(api_main, main).

api_main :-
    set_stream(user_input, encoding(utf8)),
    set_stream(user_output, encoding(utf8)),
    current_prolog_flag(argv, Argv),
    (   Argv == ['--json']  -> exportar_json
    ;   Argv == ['--stdin'] -> read_string(user_input, _, Q), responder(Q, R), format("~w~n", [R])
    ;   format(user_error, "Uso: swipl api.pl --stdin | --json~n", []), halt(1)
    ).

exportar_json :-
    findall(D, (especie(X, _, _), especie_dict(X, D)), Ds),
    json_write_dict(current_output,
        _{fuente: "Base de conocimiento Prolog (kb.pl y reglas.pl). Estados de conservación: Lista Roja UICN.",
          especies: Ds},
        [width(0)]),
    nl.

str(A, S) :- ( string(A) -> S = A ; atom_string(A, S) ).
strs(Goal, V, L) :- findall(S, (Goal, str(V, S)), L0), list_to_set(L0, L).
si_no(Goal, B) :- ( call(Goal) -> B = true ; B = false ).

especie_dict(X, _{id: XS, nombre: N, nombre_cientifico: C, clase: CL, dieta: DN,
                  estado_conservacion: EST, amenazada: Am, prioridad_conservacion: Pr,
                  endemica_chile: En, zonas: Zs, ecosistemas: Es, peso_kg: P,
                  habito: H, presas_en_la_base: Ps, depredadores_en_la_base: Dps,
                  simbolo_nacional: Sim, dato_curioso: Dc, otros_nombres: Al}) :-
    especie(X, N0, C0), str(X, XS), str(N0, N), str(C0, C),
    ( clase(X, Cl), nombre_clase(Cl, CL0, _) -> str(CL0, CL) ; CL = "" ),
    ( dieta(X, D), nombre_dieta(D, DN0) -> str(DN0, DN) ; DN = "" ),
    (   estado_conservacion(X, Cat), nombre_categoria(Cat, CatN)
    ->  upcase_atom(Cat, CU), format(string(EST), "~w (~w)", [CatN, CU])
    ;   EST = ""
    ),
    si_no(amenazada(X), Am), si_no(prioridad_conservacion(X), Pr), si_no(endemica_de_chile(X), En),
    strs(( habita_zona(X, Z), nombre_zona(Z, ZN, ZR), format(atom(V0), '~w (~w)', [ZN, ZR]) ), V0, Zs),
    strs(( habita_ecosistema(X, E), nombre_ecosistema(E, V1) ), V1, Es),
    ( peso_kg(X, P) -> true ; P = null ),
    ( habito(X, H0) -> str(H0, H) ; H = "" ),
    strs(( come(X, Pr0), especie(Pr0, V2, _) ), V2, Ps),
    strs(( come(Dp, X), especie(Dp, V3, _) ), V3, Dps),
    si_no(simbolo_nacional(X), Sim),
    ( dato_curioso(X, Dc0) -> str(Dc0, Dc) ; Dc = "" ),
    strs(( alias(X, Ws), atomic_list_concat(Ws, ' ', V4) ), V4, Al).
