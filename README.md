# Chatbot de Fauna Nativa de Chile

Proyecto 2 - Fundamentos de Inteligencia Artificial
Diseño de un agente inteligente que usa conocimiento.

## Entrega 1 (puntos 1 a 3)

1. Dominio: fauna nativa de Chile (20 especies, 5 macrozonas, 9 ecosistemas).
2. Modelado del conocimiento en lógica de primer orden: `prolog/kb.pl` (hechos) y `prolog/reglas.pl` (reglas, con su fórmula LPO comentada).
3. Chatbot en Prolog que responde preguntas en español: `prolog/chatbot.pl`.

El informe está en `docs/Informe_Entrega1_Fauna_Chile.docx`.

## Entrega 2 (puntos 4 a 6)

4. Chatbot con un LLM en Python que responde usando el mismo conocimiento de `prolog/kb.pl` y `prolog/reglas.pl` (`backend/motor_llm.py`).
5. Interfaz web para usar el chatbot Prolog, el LLM o ambos lado a lado (`frontend/` + `backend/app.py`).
6. Evaluación con las 20 preguntas de la Entrega 1 (más 10 de robustez) e informe de desempeño: `docs/Informe_Entrega2_Fauna_Chile.docx`.

El chatbot Prolog de la Entrega 1 no se modificó: se agregó `prolog/api.pl` para usarlo desde Python.

## Requisitos

- [SWI-Prolog](https://www.swi-prolog.org/download/stable) 9.x
- Python 3.10+ (solo para la Entrega 2)

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

## Entrega 2: instalación y uso

```bash
python3 -m venv .venv && source .venv/bin/activate     # Windows: .venv\Scripts\activate
pip install -r requirements.txt
cp .env.example .env        # pegar la API key del LLM (Gemini gratis: https://aistudio.google.com/apikey)
python -m backend.app       # abrir http://localhost:5000
```

Evaluación (corre las 30 preguntas en ambos chatbots y regenera el informe):

```bash
python -m evaluacion.evaluar              # todo
python -m evaluacion.evaluar --completar  # solo las respuestas del LLM que falten (si se agotó la cuota)
python -m pytest -q                       # pruebas del backend
```

El LLM se configura en `.env` (`LLM_PROVEEDOR` = gemini, groq, openai u ollama). Si el modelo indicado no existe, se elige automáticamente uno disponible.

## Estructura

| Archivo | Contenido |
|---|---|
| `prolog/kb.pl` | Hechos del dominio y vocabulario (alias) |
| `prolog/reglas.pl` | Reglas de inferencia en LPO |
| `prolog/nlp.pl` | Normalización del texto y reconocimiento de entidades |
| `prolog/chatbot.pl` | Intenciones, filtros y respuestas |
| `prolog/main.pl` | Punto de entrada interactivo |
| `prolog/pruebas.pl` | Set de 20 preguntas de prueba |
| `prolog/api.pl` | (E2) Interfaz para Python: responde por entrada estándar y exporta la base en JSON |
| `backend/` | (E2) Motores Prolog y LLM, servicio y API web (Flask) |
| `frontend/` | (E2) Interfaz web del chatbot |
| `evaluacion/` | (E2) Preguntas, script de evaluación y resultados |
| `informe/generar_informe.py` | (E2) Genera el informe Word a partir de los resultados |
| `tests/` | (E2) Pruebas automáticas del backend |

## Modificar el conocimiento

Editar `prolog/kb.pl` (hay una plantilla al final para agregar especies) y recargar con `?- make.`
En la interfaz web el cambio se ve de inmediato en ambos chatbots (Prolog y LLM), sin reiniciar el servidor.
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
