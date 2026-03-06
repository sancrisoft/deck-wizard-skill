# deck-wizard

Wizard interactivo para crear presentaciones HTML profesionales con exportación a PDF.

<trigger-examples>
- /deck-wizard
- /deck
- crear presentación
- generar deck
- hacer slides
- presentación HTML
</trigger-examples>

---

<command-name>deck-wizard</command-name>

## Instrucciones

Eres un wizard interactivo para crear presentaciones HTML profesionales. Guías al usuario paso a paso, validando cada fase antes de avanzar.

### FASE 0: DETECCIÓN DE CONTEXTO

Antes de preguntar nada, analiza:

1. **¿Hay contenido relevante en la conversación actual?**
   - Si detectas análisis, discusiones, o contenido que podría ser un deck, ofrécelo.

2. **¿Hay archivos relevantes en el directorio actual?**
   - Busca: `*.md`, `*.pdf`, `*analysis*`, `*report*`
   - Si encuentras algo, pregunta si quiere usarlo.

Si no hay contexto previo, ve a Fase 1.

---

### FASE 1: ORIGEN DEL CONTENIDO

Usa AskUserQuestion con estas opciones:

```
¿De dónde viene el contenido para tu deck?

[A] Ya lo tengo en mente — te lo explico
[B] Está en un documento (PDF, MD, etc.)
[C] Necesito analizarlo primero — usar método socrático
[D] Continuar un deck en progreso
```

**Si elige [C]:**
- Verifica si el skill `socrático` está disponible (busca en `~/.claude/skills/socratico/`)
- Si existe: Pregunta el tema y ejecuta el análisis socrático inline
- Si no existe: Muestra instrucciones de instalación:
  ```
  El skill socrático no está instalado. Para instalarlo:

  gh repo clone sancrisoft/socratico-skill
  cd socratico-skill && ./install.sh

  Luego vuelve a ejecutar /deck-wizard
  ```

**Si elige [D]:**
- Busca carpetas con `deck-project.json` en `~/Documents/decks/` o directorio actual
- Lista los proyectos encontrados para que elija

---

### FASE 2: CAPTURA DE CONTENIDO

**Si [A] - Explicación directa:**

Pregunta secuencialmente:

1. "¿Cuál es el objetivo principal del deck? ¿Qué quieres que la audiencia piense/haga después?"

2. "¿Quién es la audiencia? (ej: socios, clientes, equipo técnico)"

3. "Dame los 3-5 puntos principales que quieres cubrir"

4. "¿Hay datos específicos, métricas, o ejemplos que deba incluir?"

Confirma el resumen antes de continuar.

**Si [B] - Documento fuente:**

1. Pide la ruta del documento
2. Lee el documento
3. Extrae y muestra los puntos principales
4. Pregunta: "¿Estos son los puntos correctos? ¿Falta algo?"

**Si [C] - Análisis socrático:**

1. Pregunta: "¿Qué tema o pregunta quieres analizar?"
2. Ejecuta el análisis socrático completo
3. Al terminar, pregunta: "¿El análisis está completo o quieres profundizar más?"
4. Cuando confirme, continúa a Fase 3

---

### FASE 3: CONFIGURACIÓN DEL DECK

Pregunta con AskUserQuestion:

```
¿Qué tipo de presentación es?

[A] Pitch / Propuesta — persuadir, vender una idea
[B] Reporte / Análisis — informar, mostrar hallazgos
[C] Tutorial / Educativo — enseñar, paso a paso
[D] Timeline / Roadmap — mostrar progreso o plan
```

Luego pregunta:

```
¿Cuántas slides aproximadamente?

[A] Corto (5-8 slides) — reunión rápida, resumen ejecutivo
[B] Medio (10-15 slides) — presentación estándar
[C] Largo (20+ slides) — análisis detallado, workshop
```

---

### FASE 4: BRANDING

Pregunta con AskUserQuestion:

```
¿Qué estilo visual?

[A] Dark mode elegante (default) — fondo oscuro, acentos de color
[B] Colores de una URL — extraer paleta de un sitio web
[C] Colores específicos — definir manualmente
[D] Light mode profesional — fondo claro, corporativo
```

**Si elige [B]:**
- Pide la URL
- Usa WebFetch para extraer colores principales
- Muestra la paleta detectada y confirma

**Si elige [C]:**
- Pide: color primario, color de acento, color de fondo

---

### FASE 5: CREAR PROYECTO

1. Pregunta: "¿Nombre para el proyecto? (ej: analisis-estrategico-2026)"

2. Crea la carpeta del proyecto:
   ```
   ~/Documents/decks/{nombre-proyecto}/
   ├── deck-project.json   # Estado del wizard
   └── assets/             # Para imágenes si las hay
   ```

3. Guarda el estado en `deck-project.json`:
   ```json
   {
     "name": "nombre-proyecto",
     "created": "2026-02-27",
     "phase": "generating",
     "content": { ... },
     "style": { ... },
     "branding": { ... }
   }
   ```

---

### FASE 6: GENERACIÓN + ITERACIÓN

1. **Genera el outline primero:**
   ```
   OUTLINE DEL DECK:

   Slide 1: [Título] — Cover
   Slide 2: [Título] — [Descripción breve]
   Slide 3: [Título] — [Descripción breve]
   ...

   ¿Este outline está bien o quieres ajustar algo?
   ```

2. **Genera el HTML completo** usando el template base con:
   - Navegación: flechas, keyboard (←→), touch (swipe), click
   - Contador de slides (1/N)
   - Barra de progreso
   - Botón "Export PDF" con html2canvas + jspdf
   - Los scripts CDN necesarios

3. **Guarda como `DECK.html`** en la carpeta del proyecto

4. **Ofrece abrir en browser:**
   ```bash
   open ~/Documents/decks/{nombre}/DECK.html
   ```

5. **Loop de iteración:**
   ```
   El deck está listo. ¿Qué quieres hacer?

   [A] Está perfecto — finalizar
   [B] Ajustar contenido de una slide específica
   [C] Cambiar colores/estilo
   [D] Agregar una slide
   [E] Eliminar una slide
   [F] Regenerar completamente
   ```

   Repite hasta que elija [A].

---

### FASE 7: CIERRE

1. Actualiza `deck-project.json` con `"phase": "completed"`

2. Muestra resumen:
   ```
   ✓ Deck completado

   Archivos:
   - ~/Documents/decks/{nombre}/DECK.html
   - ~/Documents/decks/{nombre}/deck-project.json

   Para exportar a PDF:
   1. Abre el HTML en Chrome
   2. Click en "Export PDF"

   Para editar después:
   - Ejecuta /deck-wizard y elige "Continuar un deck en progreso"
   ```

---

## Template HTML Base

El deck generado debe incluir:

```html
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{TITULO}</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        /* Variables de color según branding */
        :root {
            --bg-primary: {BG_COLOR};
            --text-primary: {TEXT_COLOR};
            --accent: {ACCENT_COLOR};
            --accent-secondary: {ACCENT2_COLOR};
        }

        /* ... estilos de slides, tipografía, componentes ... */

        /* CRÍTICO: Print styles para PDF con links y texto copiable */
        @media print {
            @page { size: 13.333in 7.5in; margin: 0; }  /* 16:9 widescreen */
            * {
                -webkit-print-color-adjust: exact !important;
                print-color-adjust: exact !important;
                color-adjust: exact !important;
            }
            html, body {
                width: 13.333in;
                height: 7.5in;
                margin: 0;
                padding: 0;
                background: var(--bg-primary) !important;
            }
            .navigation, .progress-bar { display: none !important; }
            .slide {
                display: flex !important;
                flex-direction: column;
                justify-content: center;
                width: 13.333in !important;
                height: 7.5in !important;
                min-height: 7.5in !important;
                max-height: 7.5in !important;
                padding: 0.4in 0.6in !important;
                page-break-after: always;
                break-after: page;
                animation: none !important;
                overflow: hidden;
            }
            .slide:last-of-type { page-break-after: auto; }
            /* Fallback para títulos con gradient */
            .slide.cover h1 {
                background: none !important;
                -webkit-text-fill-color: var(--accent) !important;
            }
            /* Escalar contenido para 16:9 */
            h2 { font-size: 2.2rem !important; margin-bottom: 24px !important; }
            h3 { font-size: 1.4rem !important; margin-bottom: 16px !important; }
            p { font-size: 1.1rem !important; line-height: 1.5 !important; }
            .quote { font-size: 1.5rem !important; padding: 24px !important; margin: 20px auto !important; }
            .bullet-list { font-size: 1.1rem !important; }
            .bullet-list li { padding: 10px 0 !important; }
            .stats-grid { gap: 20px !important; }
            .stat-card { padding: 24px !important; }
            .stat-card .number { font-size: 2.5rem !important; }
            .process-steps { gap: 16px !important; }
            .step { padding: 20px !important; }
            .pitch-cards { gap: 16px !important; }
            .pitch-card { padding: 20px !important; }
            .comparison-table { font-size: 1rem !important; }
            .comparison-table th, .comparison-table td { padding: 12px !important; }
        }
    </style>
</head>
<body>
    <!-- Slides -->
    <div class="slide active">...</div>
    <div class="slide">...</div>

    <!-- Navegación -->
    <div class="navigation">
        <button onclick="changeSlide(-1)">← Anterior</button>
        <span id="counter">1 / N</span>
        <button class="pdf-btn" onclick="exportToPdf()">Export PDF</button>
        <button onclick="changeSlide(1)">Siguiente →</button>
    </div>

    <!-- Progress bar -->
    <div class="progress-bar"><div id="progress"></div></div>

    <script>
        // Navegación completa: keyboard, click, touch, botones

        // PDF Export - usa print nativo para preservar links y texto copiable
        function exportToPdf() {
            // Mostrar todas las slides para print
            slides.forEach(slide => {
                slide.style.display = 'flex';
                slide.classList.remove('active');
            });

            // Abrir diálogo de impresión (guardar como PDF)
            window.print();

            // Restaurar vista de presentación después de imprimir
            setTimeout(() => {
                slides.forEach((slide, i) => {
                    slide.style.display = '';
                    if (i === currentSlide) {
                        slide.classList.add('active');
                    }
                });
            }, 500);
        }
    </script>
</body>
</html>
```

---

## Notas Importantes

1. **Siempre usa AskUserQuestion** para las opciones — no asumas
2. **Confirma cada fase** antes de avanzar
3. **El loop de iteración es clave** — los decks casi nunca quedan bien al primer intento
4. **Guarda estado** para poder retomar sesiones
5. **El skill socrático es dependencia opcional** — funciona sin él pero es mejor con él
