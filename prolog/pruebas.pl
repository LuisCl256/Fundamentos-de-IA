:- encoding(utf8).

%  Set de 20 preguntas usado en el informe
%  Uso:  swipl pruebas.pl

:- ensure_loaded(chatbot).
:- initialization(ejecutar_pruebas, main).

% pregunta_prueba(Numero, Pregunta)
pregunta_prueba(1, "¿Qué come el puma?").
pregunta_prueba(2, "¿Dónde vive el huemul?").
pregunta_prueba(3, "¿El pudú está en peligro de extinción?").
pregunta_prueba(4, "¿Cuál es el nombre científico de la güiña?").
pregunta_prueba(5, "¿El degú es endémico de Chile?").
pregunta_prueba(6, "¿Quién se come al guanaco?").
pregunta_prueba(7, "¿Cuánto pesa un cóndor?").
pregunta_prueba(8, "¿El monito del monte es nocturno?").
pregunta_prueba(9, "¿Vive el picaflor de Arica en la zona sur?").
pregunta_prueba(10, "¿Qué mamíferos amenazados viven en la zona sur?").
pregunta_prueba(11, "¿Qué animales herbívoros hay en el altiplano?").
pregunta_prueba(12, "¿Cuál es el ave más pequeña?").
pregunta_prueba(13, "¿Qué pesa más, el puma o el huemul?").
pregunta_prueba(14, "¿Conviven el pudú y el huemul?").
pregunta_prueba(15, "¿Qué especies tienen prioridad de conservación?").
pregunta_prueba(16, "¿Cuál es la cadena alimenticia del degú?").
pregunta_prueba(17, "Háblame del zorro chilote").
pregunta_prueba(18, "¿Hay felinos en Chile?").
pregunta_prueba(19, "¿El puma es peligroso para las personas?").
pregunta_prueba(20, "¿Qué come el guanacco?").

ejecutar_pruebas :-
    set_stream(user_output, encoding(utf8)),
    forall(pregunta_prueba(N, P),
           ( responder(P, R),
             format("~w. Tú:  ~w~n   Bot: ~w~n~n", [N, P, R]) )).
