"""Base de conocimiento compartida.

La fuente única de verdad son los archivos Prolog de la Entrega 1 (prolog/kb.pl y
prolog/reglas.pl). Este módulo los exporta vía Prolog (prolog/api.pl --json), guarda el
resultado en caché mientras los archivos no cambien y lo convierte en texto para el LLM.
"""
from __future__ import annotations

from pathlib import Path

from .motor_prolog import MotorProlog

ARCHIVOS_FUENTE = ("kb.pl", "reglas.pl")


def _si_no(valor: bool) -> str:
    return "sí" if valor else "no"


def _lista(valores: list) -> str:
    return ", ".join(str(v) for v in valores) if valores else "sin registro"


def especie_a_texto(e: dict) -> str:
    peso = f"{e['peso_kg']} kg aprox." if e.get("peso_kg") is not None else "sin registro"
    lineas = [
        f"### {e['nombre']} ({e['nombre_cientifico']})",
        f"- Otros nombres: {_lista(e['otros_nombres'])}",
        f"- Clase: {e['clase']}",
        f"- Dieta: {e['dieta']}",
        f"- Peso adulto: {peso}",
        f"- Actividad: {e['habito'] or 'sin registro'}",
        f"- Zonas de Chile: {_lista(e['zonas'])}",
        f"- Ecosistemas: {_lista(e['ecosistemas'])}",
        f"- Estado de conservación (UICN): {e['estado_conservacion']}; amenazada: {_si_no(e['amenazada'])}",
        f"- Endémica de Chile: {_si_no(e['endemica_chile'])}; prioridad de conservación: {_si_no(e['prioridad_conservacion'])}",
        f"- Presas registradas en la base: {_lista(e['presas_en_la_base'])}",
        f"- Depredadores registrados en la base: {_lista(e['depredadores_en_la_base'])}",
        f"- Símbolo nacional (escudo de Chile): {_si_no(e['simbolo_nacional'])}",
    ]
    if e.get("dato_curioso"):
        lineas.append(f"- Dato curioso: {e['dato_curioso']}")
    return "\n".join(lineas)


def conocimiento_a_texto(base: dict) -> str:
    cabecera = [
        f"Fuente: {base.get('fuente', '')}",
        "Definiciones: 'amenazada' = estado VU, EN o CR; 'prioridad de conservación' = endémica y amenazada.",
        "Las relaciones de depredación solo incluyen especies que están en esta base.",
        f"Total de especies en la base: {len(base['especies'])}.",
        "",
    ]
    return "\n".join(cabecera) + "\n\n".join(especie_a_texto(e) for e in base["especies"])


class BaseConocimiento:
    """Carga la base desde Prolog y la recarga solo si kb.pl o reglas.pl cambiaron."""

    def __init__(self, motor: MotorProlog) -> None:
        self.motor = motor
        self._archivos = [Path(motor.carpeta) / a for a in ARCHIVOS_FUENTE]
        self._marca: float | None = None
        self._datos: dict | None = None
        self._texto: str = ""

    def _actualizar(self) -> None:
        marca = max(a.stat().st_mtime for a in self._archivos if a.exists())
        if self._datos is None or marca != self._marca:
            self._datos = self.motor.exportar_conocimiento()
            self._texto = conocimiento_a_texto(self._datos)
            self._marca = marca

    @property
    def datos(self) -> dict:
        self._actualizar()
        return self._datos

    @property
    def texto(self) -> str:
        self._actualizar()
        return self._texto
