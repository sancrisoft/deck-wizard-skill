# Deck Wizard

Wizard interactivo para crear presentaciones HTML profesionales con Claude Code.

## Características

- **Wizard paso a paso** — guía al usuario desde el contenido hasta el deck final
- **Múltiples fuentes de contenido** — explicación directa, documentos, o análisis socrático
- **Branding personalizable** — extrae colores de URLs o define manualmente
- **Iteración integrada** — ajusta slides hasta que queden perfectas
- **Export PDF** — botón integrado en el HTML usando html2canvas + jspdf
- **Persistencia** — guarda estado para retomar sesiones

## Uso

```
/deck-wizard
```

O con triggers naturales:
- "crear presentación"
- "generar deck"
- "hacer slides"

## Flujo

```
┌────────────────┐
│ Detección de   │ ← Busca contenido en conversación/archivos
│ Contexto       │
└───────┬────────┘
        ↓
┌────────────────┐
│ Origen del     │ ← ¿Explicar, documento, o análisis socrático?
│ Contenido      │
└───────┬────────┘
        ↓
┌────────────────┐
│ Captura de     │ ← Preguntas guiadas o lectura de documento
│ Contenido      │
└───────┬────────┘
        ↓
┌────────────────┐
│ Configuración  │ ← Tipo de deck, cantidad de slides
│ del Deck       │
└───────┬────────┘
        ↓
┌────────────────┐
│ Branding       │ ← Colores, estilo visual
└───────┬────────┘
        ↓
┌────────────────┐
│ Generación +   │ ← Loop hasta confirmación
│ Iteración      │
└───────┬────────┘
        ↓
┌────────────────┐
│ Cierre         │ ← Archivos finales, instrucciones
└────────────────┘
```

## Output

Crea una carpeta en `~/Documents/decks/{nombre-proyecto}/`:

```
mi-presentacion/
├── DECK.html           # Presentación final
├── deck-project.json   # Estado del proyecto
└── assets/             # Imágenes si las hay
```

## Dependencias

### Requerida
- Claude Code CLI

### Opcional (recomendada)
- **Skill socrático** — para análisis profundo antes del deck

```bash
gh repo clone sancrisoft/socratico-skill
cd socratico-skill && ./install.sh
```

## Instalación

```bash
# Clonar el repo
gh repo clone sancrisoft/deck-wizard-skill
cd deck-wizard-skill

# Instalar
./install.sh
```

O manual:
```bash
mkdir -p ~/.claude/skills/deck-wizard
cp SKILL.md ~/.claude/skills/deck-wizard/
```

## Ejemplos de Output

El HTML generado incluye:

- **Navegación completa:**
  - Flechas ←/→
  - Keyboard (arrows, space, home, end)
  - Touch (swipe left/right)
  - Click (mitad izquierda/derecha de pantalla)

- **UI:**
  - Contador de slides (1/N)
  - Barra de progreso
  - Botón "Export PDF"

- **Estilos:**
  - Dark mode por defecto
  - Font Inter
  - Gradientes sutiles
  - Responsive

## Tips

1. **Usa el socrático primero** si no tienes claro el contenido
2. **Menos es más** — una idea por slide
3. **Itera sin miedo** — es normal ajustar 3-5 veces
4. **El PDF se exporta mejor en Chrome** — otros browsers pueden variar

## Troubleshooting

| Problema | Solución |
|----------|----------|
| PDF no exporta | Abrir en Chrome, verificar conexión (CDNs) |
| Slides cortadas | Pedir dividir slide en dos |
| Colores incorrectos | Usar opción de colores específicos |
| Quiero retomar | Elegir "Continuar deck en progreso" |

## Relacionado

- [socratico-skill](https://github.com/sancrisoft/socratico-skill) — Dependencia opcional para análisis profundo antes del deck

---

Creado por Samuel Granja para Sancrisoft.
