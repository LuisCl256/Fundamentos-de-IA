# Chatbot de Fauna Nativa de Chile

Proyecto 2 - Fundamentos de Inteligencia Artificial
Diseño de un agente inteligente que usa conocimiento.

## Entrega 1 (puntos 1 a 3)

1. Dominio: fauna nativa de Chile (20 especies, 5 macrozonas, 9 ecosistemas).
2. Modelado del conocimiento en lógica de primer orden: `prolog/kb.pl` (hechos) y `prolog/reglas.pl` (reglas, con su fórmula LPO comentada).
3. Chatbot en Prolog que responde preguntas en español: `prolog/chatbot.pl`.

El informe está en `docs/Informe_Entrega1_Fauna_Chile.docx`.

## Requisitos

- [SWI-Prolog](https://www.swi-prolog.org/download/stable) 9.x

## Uso

```bash
cd prolog
swipl main.pl # conversación interactiva ("salir" para terminar)
swipl pruebas.pl # ejecuta el set de 20 preguntas de prueba
```

Desde la consola de Prolog:

```prolog
?- [chatbot].
?- preguntar("¿Qué mamíferos amenazados viven en la zona sur?").
?- amenazada(X).
?- cadena_alimenticia(puma, X).
```

## Estructura

| Archivo | Contenido |
|---|---|
| `prolog/kb.pl` | Hechos del dominio y vocabulario (alias) |
| `prolog/reglas.pl` | Reglas de inferencia en LPO |
| `prolog/nlp.pl` | Normalización del texto y reconocimiento de entidades |
| `prolog/chatbot.pl` | Intenciones, filtros y respuestas |
| `prolog/main.pl` | Punto de entrada interactivo |
| `prolog/pruebas.pl` | Set de 20 preguntas de prueba |

## Modificar el conocimiento

Editar `prolog/kb.pl` (hay una plantilla al final para agregar especies) y recargar con `?- make.`
También se puede cambiar en vivo: `?- assertz(come(puma, guina)).`

## Ejemplos de preguntas

- ¿Qué come el puma?
- ¿Dónde vive el huemul?
- ¿El pudú está en peligro de extinción?
- ¿Quién se come al guanaco?
- ¿Qué pesa más, el puma o el huemul?
- ¿Conviven el pudú y el huemul?
- ¿Cuál es el ave más pequeña?
- ¿Qué especies tienen prioridad de conservación?
