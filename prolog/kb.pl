:- encoding(utf8).

%  Base de conocimiento: Fauna nativa de Chile
%  Proyecto 2 - Fundamentos de Inteligencia Artificial
%
%  Conocimientos del dominio. Las reglas están en reglas.pl.
%  Para agregar una especie nueva basta con agregar sus hechos
%  en la sección "[Plantilla]" al final del archivo.


:- dynamic especie/3, clase/2, dieta/2, estado_conservacion/2,
           habita_zona/2, habita_ecosistema/2, endemica_de_chile/1,
           peso_kg/2, habito/2, come/2, simbolo_nacional/1,
           dato_curioso/2, alias/2, femenino/1.

:- discontiguous femenino/1, especie/3, clase/2, dieta/2, estado_conservacion/2,
                 habita_zona/2, habita_ecosistema/2, endemica_de_chile/1,
                 peso_kg/2, habito/2, come/2, simbolo_nacional/1,
                 dato_curioso/2, alias/2.

% especie(Id, NombreComun, NombreCientifico)
especie(puma,               'puma',                   'Puma concolor').
especie(huemul,             'huemul',                 'Hippocamelus bisulcus').
especie(pudu,               'pudú',                   'Pudu puda').
especie(guanaco,            'guanaco',                'Lama guanicoe').
especie(vicuna,             'vicuña',                 'Vicugna vicugna').
especie(chinchilla,         'chinchilla de cola larga','Chinchilla lanigera').
especie(zorro_chilote,      'zorro chilote',          'Lycalopex fulvipes').
especie(guina,              'güiña',                  'Leopardus guigna').
especie(monito_del_monte,   'monito del monte',       'Dromiciops gliroides').
especie(degu,               'degú',                   'Octodon degus').
especie(chungungo,          'chungungo',              'Lontra felina').
especie(huillin,            'huillín',                'Lontra provocax').
especie(condor,             'cóndor andino',          'Vultur gryphus').
especie(picaflor_arica,     'picaflor de Arica',      'Eulidia yarrellii').
especie(pinguino_humboldt,  'pingüino de Humboldt',   'Spheniscus humboldti').
especie(flamenco_chileno,   'flamenco chileno',       'Phoenicopterus chilensis').
especie(carpintero_negro,   'carpintero negro',       'Campephilus magellanicus').
especie(chucao,             'chucao',                 'Scelorchilus rubecula').
especie(ranita_darwin,      'ranita de Darwin',       'Rhinoderma darwinii').
especie(culebra_cola_larga, 'culebra de cola larga',  'Philodryas chamissonis').

% clase(Id, Clase) Clase puede ser {mamifero, ave, anfibio, reptil}
clase(puma, mamifero). clase(huemul, mamifero).
clase(pudu, mamifero). clase(guanaco, mamifero).
clase(vicuna, mamifero). clase(chinchilla, mamifero).
clase(zorro_chilote, mamifero). clase(guina, mamifero).
clase(monito_del_monte, mamifero). clase(degu, mamifero).
clase(chungungo, mamifero). clase(huillin, mamifero).
clase(condor, ave). clase(picaflor_arica, ave).
clase(pinguino_humboldt, ave). clase(flamenco_chileno, ave).
clase(carpintero_negro, ave). clase(chucao, ave).
clase(ranita_darwin, anfibio).
clase(culebra_cola_larga, reptil).

% dieta(Id, TipoDieta)
dieta(puma, carnivoro). dieta(huemul, herbivoro).
dieta(pudu, herbivoro). dieta(guanaco, herbivoro).
dieta(vicuna, herbivoro). dieta(chinchilla, herbivoro).
dieta(zorro_chilote, omnivoro). dieta(guina, carnivoro).
dieta(monito_del_monte, omnivoro). dieta(degu, herbivoro).
dieta(chungungo, carnivoro). dieta(huillin, carnivoro).
dieta(condor, carronero). dieta(picaflor_arica, nectarivoro).
dieta(pinguino_humboldt, piscivoro).
dieta(flamenco_chileno, filtrador).
dieta(carpintero_negro, insectivoro).
dieta(chucao, insectivoro). dieta(ranita_darwin, insectivoro).
dieta(culebra_cola_larga, carnivoro).

% estado_conservacion(Id, Categoria) categorías UICN
%   lc = Preocupación menor, nt = Casi amenazada, vu = Vulnerable,
%   en = En peligro, cr = En peligro crítico
estado_conservacion(puma, lc).
estado_conservacion(huemul, en).
estado_conservacion(pudu, nt).
estado_conservacion(guanaco, lc).
estado_conservacion(vicuna, lc).
estado_conservacion(chinchilla, en).
estado_conservacion(zorro_chilote, en).
estado_conservacion(guina, vu).
estado_conservacion(monito_del_monte, nt).
estado_conservacion(degu, lc).
estado_conservacion(chungungo, en).
estado_conservacion(huillin, en).
estado_conservacion(condor, vu).
estado_conservacion(picaflor_arica, en).
estado_conservacion(pinguino_humboldt, vu).
estado_conservacion(flamenco_chileno, nt).
estado_conservacion(carpintero_negro, lc).
estado_conservacion(chucao, lc).
estado_conservacion(ranita_darwin, en).
estado_conservacion(culebra_cola_larga, lc).

% habita_zona(Id, Zona)
%   Zona puede ser {norte_grande, norte_chico, zona_central, zona_sur, zona_austral}
habita_zona(puma, norte_grande). habita_zona(puma, norte_chico).
habita_zona(puma, zona_central). habita_zona(puma, zona_sur).
habita_zona(puma, zona_austral).
habita_zona(huemul, zona_sur). habita_zona(huemul, zona_austral).
habita_zona(pudu, zona_sur). habita_zona(pudu, zona_austral).
habita_zona(guanaco, norte_grande). habita_zona(guanaco, norte_chico).
habita_zona(guanaco, zona_central). habita_zona(guanaco, zona_austral).
habita_zona(vicuna, norte_grande). habita_zona(vicuna, norte_chico).
habita_zona(chinchilla, norte_chico).
habita_zona(zorro_chilote, zona_sur).
habita_zona(guina, zona_central). habita_zona(guina, zona_sur).
habita_zona(guina, zona_austral).
habita_zona(monito_del_monte, zona_sur).
habita_zona(degu, norte_chico). habita_zona(degu, zona_central).
habita_zona(chungungo, norte_grande). habita_zona(chungungo, norte_chico).
habita_zona(chungungo, zona_central). habita_zona(chungungo, zona_sur).
habita_zona(chungungo, zona_austral).
habita_zona(huillin, zona_sur). habita_zona(huillin, zona_austral).
habita_zona(condor, norte_grande). habita_zona(condor, norte_chico).
habita_zona(condor, zona_central). habita_zona(condor, zona_sur).
habita_zona(condor, zona_austral).
habita_zona(picaflor_arica, norte_grande).
habita_zona(pinguino_humboldt, norte_grande).
habita_zona(pinguino_humboldt, norte_chico).
habita_zona(pinguino_humboldt, zona_central).
habita_zona(flamenco_chileno, norte_grande).
habita_zona(flamenco_chileno, norte_chico).
habita_zona(flamenco_chileno, zona_austral).
habita_zona(carpintero_negro, zona_sur).
habita_zona(carpintero_negro, zona_austral).
habita_zona(chucao, zona_sur). habita_zona(chucao, zona_austral).
habita_zona(ranita_darwin, zona_sur).
habita_zona(culebra_cola_larga, norte_chico).
habita_zona(culebra_cola_larga, zona_central).
habita_zona(culebra_cola_larga, zona_sur).

% habita_ecosistema(Id, Ecosistema)
%   Ecosistema puede ser
%   {altiplano, desierto, matorral, bosque_templado,
%   costa, rios, estepa, cordillera, humedal}
habita_ecosistema(puma, cordillera).     habita_ecosistema(puma, matorral).
habita_ecosistema(puma, bosque_templado). habita_ecosistema(puma, estepa).
habita_ecosistema(huemul, bosque_templado).
habita_ecosistema(huemul, cordillera).
habita_ecosistema(pudu, bosque_templado).
habita_ecosistema(guanaco, altiplano).   habita_ecosistema(guanaco, desierto).
habita_ecosistema(guanaco, cordillera).  habita_ecosistema(guanaco, estepa).
habita_ecosistema(vicuna, altiplano).
habita_ecosistema(chinchilla, matorral).
habita_ecosistema(zorro_chilote, bosque_templado).
habita_ecosistema(guina, bosque_templado).
habita_ecosistema(guina, matorral).
habita_ecosistema(monito_del_monte, bosque_templado).
habita_ecosistema(degu, matorral).
habita_ecosistema(chungungo, costa).
habita_ecosistema(huillin, rios).        habita_ecosistema(huillin, costa).
habita_ecosistema(condor, cordillera).
habita_ecosistema(picaflor_arica, desierto).
habita_ecosistema(pinguino_humboldt, costa).
habita_ecosistema(flamenco_chileno, humedal).
habita_ecosistema(flamenco_chileno, altiplano).
habita_ecosistema(carpintero_negro, bosque_templado).
habita_ecosistema(chucao, bosque_templado).
habita_ecosistema(ranita_darwin, bosque_templado).
habita_ecosistema(culebra_cola_larga, matorral).

% endemica_de_chile(Id): solo vive en Chile
endemica_de_chile(chinchilla).
endemica_de_chile(zorro_chilote).
endemica_de_chile(degu).
endemica_de_chile(culebra_cola_larga).

% peso_kg(Id, PesoAdultoAproximado)
peso_kg(puma, 60). peso_kg(huemul, 70).
peso_kg(pudu, 9). peso_kg(guanaco, 110).
peso_kg(vicuna, 45). peso_kg(chinchilla, 0.5).
peso_kg(zorro_chilote, 3). peso_kg(guina, 2).
peso_kg(monito_del_monte, 0.03). peso_kg(degu, 0.25).
peso_kg(chungungo, 4.5). peso_kg(huillin, 9).
peso_kg(condor, 12). peso_kg(picaflor_arica, 0.0025).
peso_kg(pinguino_humboldt, 4.5). peso_kg(flamenco_chileno, 3).
peso_kg(carpintero_negro, 0.3). peso_kg(chucao, 0.04).
peso_kg(ranita_darwin, 0.002). peso_kg(culebra_cola_larga, 0.3).

% habito(Id, Actividad) Actividad puede ser {diurno, nocturno, crepuscular}
habito(puma, crepuscular). habito(huemul, diurno).
habito(pudu, crepuscular). habito(guanaco, diurno).
habito(vicuna, diurno). habito(chinchilla, nocturno).
habito(zorro_chilote, crepuscular). habito(guina, nocturno).
habito(monito_del_monte, nocturno). habito(degu, diurno).
habito(chungungo, diurno). habito(huillin, crepuscular).
habito(condor, diurno). habito(picaflor_arica, diurno).
habito(pinguino_humboldt, diurno). habito(flamenco_chileno, diurno).
habito(carpintero_negro, diurno). habito(chucao, diurno).
habito(ranita_darwin, diurno). habito(culebra_cola_larga, diurno).

% come(Depredador, Presa): relaciones de depredación entre especies
come(puma, guanaco).
come(puma, huemul).
come(puma, pudu).
come(puma, vicuna).
come(guina, degu).
come(guina, chucao).
come(culebra_cola_larga, degu).

% femenino(Id): el nombre común es femenino (para usar "la" en vez de "el")
femenino(vicuna).
femenino(chinchilla).
femenino(guina).
femenino(ranita_darwin).
femenino(culebra_cola_larga).

% simbolo_nacional(Id): aparece en el escudo de Chile
simbolo_nacional(huemul).
simbolo_nacional(condor).

% dato_curioso(Id, Texto)
dato_curioso(puma, 'Es el mayor felino de Chile y puede saltar más de 5 metros.').
dato_curioso(huemul, 'Junto al cóndor aparece en el escudo nacional.').
dato_curioso(pudu, 'Es uno de los ciervos más pequeños del mundo.').
dato_curioso(guanaco, 'Es el mamífero terrestre nativo más grande de Chile.').
dato_curioso(vicuna, 'Su fibra es una de las más finas del mundo.').
dato_curioso(chinchilla, 'Fue cazada casi hasta la extinción por su pelaje.').
dato_curioso(zorro_chilote, 'También se le llama zorro de Darwin, quien lo describió en Chiloé.').
dato_curioso(guina, 'Es el felino más pequeño de América.').
dato_curioso(monito_del_monte, 'Es un marsupial que hiberna y se le considera un fósil viviente.').
dato_curioso(degu, 'Es un roedor social que vive en colonias con madrigueras.').
dato_curioso(chungungo, 'Es la única nutria exclusivamente marina de Sudamérica.').
dato_curioso(huillin, 'Es una nutria de agua dulce que vive en ríos y lagos del sur.').
dato_curioso(condor, 'Es una de las aves voladoras más grandes del mundo.').
dato_curioso(picaflor_arica, 'Es una de las aves más pequeñas de Chile.').
dato_curioso(pinguino_humboldt, 'Anida en islas y costas rocosas del norte y centro.').
dato_curioso(flamenco_chileno, 'Filtra crustáceos y algas del agua con su pico.').
dato_curioso(carpintero_negro, 'Es el carpintero más grande de Sudamérica.').
dato_curioso(chucao, 'Según la tradición mapuche su canto anuncia buena o mala suerte.').
dato_curioso(ranita_darwin, 'El macho incuba a las crías en su saco vocal.').
dato_curioso(culebra_cola_larga, 'Es levemente venenosa pero no peligrosa para el ser humano.').

% alias(Id, ListaDePalabras): formas en que el usuario puede nombrar
% a cada especie (texto normalizado: minúsculas, sin tildes, ñ -> n)
alias(puma, [puma]). alias(puma, [pumas]).
alias(puma, [leon, de, montana]).
alias(huemul, [huemul]). alias(huemul, [huemules]).
alias(pudu, [pudu]). alias(pudu, [pudues]).  alias(pudu, [pudus]).
alias(guanaco, [guanaco]). alias(guanaco, [guanacos]).
alias(vicuna, [vicuna]). alias(vicuna, [vicunas]).
alias(chinchilla, [chinchilla]). alias(chinchilla, [chinchillas]).
alias(zorro_chilote, [zorro, chilote]).
alias(zorro_chilote, [zorro, de, darwin]).
alias(zorro_chilote, [zorro]).
alias(guina, [guina]). alias(guina, [guinas]).
alias(guina, [kodkod]).
alias(monito_del_monte, [monito, del, monte]).
alias(monito_del_monte, [monito]).
alias(degu, [degu]). alias(degu, [degus]).  alias(degu, [degues]).
alias(chungungo, [chungungo]). alias(chungungo, [chungungos]).
alias(chungungo, [nutria, marina]).
alias(huillin, [huillin]). alias(huillin, [huillines]).
alias(huillin, [nutria, de, rio]).
alias(condor, [condor]). alias(condor, [condores]).
alias(picaflor_arica, [picaflor, de, arica]).
alias(picaflor_arica, [picaflor]).
alias(picaflor_arica, [colibri]).
alias(pinguino_humboldt, [pinguino, de, humboldt]).
alias(pinguino_humboldt, [pinguino]).
alias(pinguino_humboldt, [pinguinos]).
alias(flamenco_chileno, [flamenco, chileno]).
alias(flamenco_chileno, [flamenco]).
alias(flamenco_chileno, [flamencos]).
alias(carpintero_negro, [carpintero, negro]).
alias(carpintero_negro, [carpintero]).
alias(chucao, [chucao]).
alias(ranita_darwin, [ranita, de, darwin]).
alias(ranita_darwin, [ranita]).
alias(ranita_darwin, [rana]).
alias(culebra_cola_larga, [culebra, de, cola, larga]).
alias(culebra_cola_larga, [culebra]).
alias(culebra_cola_larga, [serpiente]).

% Vocabulario del dominio: textos y sinónimos de categorías

% nombre_categoria(Codigo, Texto)
nombre_categoria(lc, 'Preocupación menor').
nombre_categoria(nt, 'Casi amenazada').
nombre_categoria(vu, 'Vulnerable').
nombre_categoria(en, 'En peligro').
nombre_categoria(cr, 'En peligro crítico').

% nombre_zona(Zona, Texto, Regiones)
nombre_zona(norte_grande, 'Norte Grande', 'Arica y Parinacota, Tarapacá y Antofagasta').
nombre_zona(norte_chico, 'Norte Chico', 'Atacama y Coquimbo').
nombre_zona(zona_central, 'Zona Central', 'Valparaíso, Metropolitana, O''Higgins y Maule').
nombre_zona(zona_sur, 'Zona Sur', 'Ñuble, Biobío, Araucanía, Los Ríos y Los Lagos').
nombre_zona(zona_austral, 'Zona Austral', 'Aysén y Magallanes').

nombre_ecosistema(altiplano, 'altiplano').
nombre_ecosistema(desierto, 'desierto y valles desérticos').
nombre_ecosistema(matorral, 'matorral y bosque esclerófilo').
nombre_ecosistema(bosque_templado, 'bosque templado').
nombre_ecosistema(costa, 'costa marina').
nombre_ecosistema(rios, 'ríos y lagos').
nombre_ecosistema(estepa, 'estepa patagónica').
nombre_ecosistema(cordillera, 'cordillera de los Andes').
nombre_ecosistema(humedal, 'humedales y salares').

nombre_clase(mamifero, 'mamífero', 'mamíferos').
nombre_clase(ave, 'ave', 'aves').
nombre_clase(anfibio, 'anfibio', 'anfibios').
nombre_clase(reptil, 'reptil', 'reptiles').

nombre_dieta(herbivoro, 'herbívoro').
nombre_dieta(carnivoro, 'carnívoro').
nombre_dieta(omnivoro, 'omnívoro').
nombre_dieta(insectivoro, 'insectívoro').
nombre_dieta(carronero, 'carroñero').
nombre_dieta(nectarivoro, 'nectarívoro').
nombre_dieta(piscivoro, 'piscívoro (come peces)').
nombre_dieta(filtrador, 'filtrador').

% Palabras normalizadas que activan cada categoría.
% prefijo_clase(Clase, Prefijo): basta que una palabra empiece así.
prefijo_clase(mamifero, mamifer).
prefijo_clase(ave, aves).
prefijo_clase(ave, ave).
prefijo_clase(anfibio, anfibi).
prefijo_clase(reptil, reptil).

prefijo_dieta(herbivoro, herbivor).
prefijo_dieta(carnivoro, carnivor).
prefijo_dieta(omnivoro, omnivor).
prefijo_dieta(insectivoro, insectivor).
prefijo_dieta(carronero, carron).
prefijo_dieta(nectarivoro, nectariv).
prefijo_dieta(piscivoro, piscivor).
prefijo_dieta(filtrador, filtrador).

% alias_zona(Zona, Palabras)
alias_zona(norte_grande, [norte, grande]).
alias_zona(norte_chico, [norte, chico]).
alias_zona(zona_central, [central]).
alias_zona(zona_central, [centro]).
alias_zona(zona_sur, [sur]).
alias_zona(zona_austral, [austral]).
alias_zona(zona_austral, [patagonia]).
alias_zona(norte_grande, [arica]).
alias_zona(norte_grande, [tarapaca]).
alias_zona(norte_grande, [iquique]).
alias_zona(norte_grande, [antofagasta]).
alias_zona(norte_chico, [atacama]).
alias_zona(norte_chico, [coquimbo]).
alias_zona(norte_chico, [la, serena]).
alias_zona(zona_central, [valparaiso]).
alias_zona(zona_central, [santiago]).
alias_zona(zona_central, [metropolitana]).
alias_zona(zona_central, [maule]).
alias_zona(zona_sur, [biobio]).
alias_zona(zona_sur, [araucania]).
alias_zona(zona_sur, [valdivia]).
alias_zona(zona_sur, [chiloe]).
alias_zona(zona_sur, [puerto, montt]).
alias_zona(zona_austral, [aysen]).
alias_zona(zona_austral, [magallanes]).
alias_zona(zona_austral, [punta, arenas]).

% alias_ecosistema(Ecosistema, Palabras)
alias_ecosistema(altiplano, [altiplano]).
alias_ecosistema(desierto, [desierto]).
alias_ecosistema(matorral, [matorral]).
alias_ecosistema(matorral, [esclerofilo]).
alias_ecosistema(bosque_templado, [bosque]).
alias_ecosistema(bosque_templado, [bosques]).
alias_ecosistema(costa, [costa]).
alias_ecosistema(costa, [mar]).
alias_ecosistema(costa, [litoral]).
alias_ecosistema(costa, [oceano]).
alias_ecosistema(rios, [rio]).
alias_ecosistema(rios, [rios]).
alias_ecosistema(estepa, [estepa]).
alias_ecosistema(cordillera, [cordillera]).
alias_ecosistema(cordillera, [andes]).
alias_ecosistema(cordillera, [montana]).
alias_ecosistema(humedal, [humedal]).
alias_ecosistema(humedal, [humedales]).
alias_ecosistema(humedal, [salar]).
alias_ecosistema(humedal, [salares]).
alias_ecosistema(humedal, [laguna]).


% [Plantilla] Para agregar una especie nueva, copiar y completar con sus datos
%
% especie(id, 'nombre común', 'Nombre científico').
% clase(id, mamifero|ave|anfibio|reptil).
% dieta(id, herbivoro|carnivoro|omnivoro|insectivoro|...).
% estado_conservacion(id, lc|nt|vu|en|cr).
% habita_zona(id, zona). % una línea por zona
% habita_ecosistema(id, ecosistema). % una línea por ecosistema
% endemica_de_chile(id). % solo si corresponde
% peso_kg(id, Peso).
% habito(id, diurno|nocturno|crepuscular).
% come(id, presa). % opcional
% dato_curioso(id, 'texto').
% alias(id, [palabra1, palabra2]). % cómo lo escribe el usuario
% femenino(id). % solo si el nombre es femenino
