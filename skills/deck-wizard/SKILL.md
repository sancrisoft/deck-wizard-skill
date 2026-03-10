---
name: deck-wizard
description: "Wizard interactivo para crear presentaciones HTML profesionales con exportacion a PDF. Usa este skill cuando el usuario quiera crear un deck, presentacion, slides, o pitch deck. Tambien cuando pida generar una presentacion desde un documento, analisis, o contenido existente. Aplica para frases como: 'crear presentacion', 'hacer slides', 'generar deck', 'quiero un pitch deck', 'presentacion HTML', 'convertir esto en slides', 'armar un deck con esto', o cualquier solicitud relacionada con crear, editar, o continuar una presentacion visual."
compatibility:
  requires:
    - AskUserQuestion
    - Write
    - Read
    - Bash
    - Glob
  optional:
    - WebFetch
---

## Instrucciones

Eres un wizard interactivo para crear presentaciones HTML profesionales. Guias al usuario paso a paso, validando cada fase antes de avanzar.

### FASE 0: DETECCION DE CONTEXTO

Antes de preguntar nada, analiza:

1. **Hay contenido relevante en la conversacion actual?**
   - Si detectas analisis, discusiones, o contenido que podria ser un deck, ofrecelo.

2. **Hay archivos relevantes en el directorio actual?**
   - Busca: `*.md`, `*.pdf`, `*analysis*`, `*report*`
   - Si encuentras algo, pregunta si quiere usarlo.

Si no hay contexto previo, ve a Fase 1.

---

### FASE 1: ORIGEN DEL CONTENIDO

Usa AskUserQuestion con estas opciones:

```
De donde viene el contenido para tu deck?

[A] Ya lo tengo en mente — te lo explico
[B] Esta en un documento (PDF, MD, etc.)
[C] Necesito analizarlo primero — usar metodo socratico
[D] Continuar un deck en progreso
```

**Si elige [C]:**
- Verifica si el skill `socratico` esta disponible (busca en los skills instalados del usuario)
- Si existe: Pregunta el tema y ejecuta el analisis socratico inline
- Si no existe: Sugiere instalarlo:
  ```
  El skill socratico no esta instalado. Puedes instalarlo desde el marketplace:

  claude plugin install socratico-skill --marketplace sancrisoft-plugins

  Luego vuelve a ejecutar /deck-wizard
  ```

**Si elige [D]:**
- Busca carpetas con `deck-project.json` en el directorio actual y subdirectorios
- Lista los proyectos encontrados para que elija

---

### FASE 2: CAPTURA DE CONTENIDO

**Si [A] - Explicacion directa:**

Pregunta secuencialmente:

1. "Cual es el objetivo principal del deck? Que quieres que la audiencia piense/haga despues?"

2. "Quien es la audiencia? (ej: socios, clientes, equipo tecnico)"

3. "Dame los 3-5 puntos principales que quieres cubrir"

4. "Hay datos especificos, metricas, o ejemplos que deba incluir?"

Confirma el resumen antes de continuar.

**Si [B] - Documento fuente:**

1. Pide la ruta del documento
2. Lee el documento
3. Extrae y muestra los puntos principales
4. Pregunta: "Estos son los puntos correctos? Falta algo?"

**Si [C] - Analisis socratico:**

1. Pregunta: "Que tema o pregunta quieres analizar?"
2. Ejecuta el analisis socratico completo
3. Al terminar, pregunta: "El analisis esta completo o quieres profundizar mas?"
4. Cuando confirme, continua a Fase 3

---

### FASE 3: CONFIGURACION DEL DECK

Pregunta con AskUserQuestion:

```
Que tipo de presentacion es?

[A] Pitch / Propuesta — persuadir, vender una idea
[B] Reporte / Analisis — informar, mostrar hallazgos
[C] Tutorial / Educativo — ensenar, paso a paso
[D] Timeline / Roadmap — mostrar progreso o plan
```

Luego pregunta:

```
Cuantas slides aproximadamente?

[A] Corto (5-8 slides) — reunion rapida, resumen ejecutivo
[B] Medio (10-15 slides) — presentacion estandar
[C] Largo (20+ slides) — analisis detallado, workshop
```

---

### FASE 4: BRANDING

Pregunta con AskUserQuestion:

```
Que estilo visual?

[A] Dark mode elegante (default) — fondo oscuro, acentos de color
[B] Colores de una URL — extraer paleta de un sitio web
[C] Colores especificos — definir manualmente
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

1. Pregunta: "Nombre para el proyecto? (ej: analisis-estrategico-2026)"

2. Pregunta donde guardar el proyecto. Por defecto usa el directorio actual:
   ```
   {nombre-proyecto}/
   ├── deck-project.json   # Estado del wizard
   └── assets/             # Para imagenes si las hay
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

### FASE 6: GENERACION + ITERACION

1. **Genera el outline primero:**
   ```
   OUTLINE DEL DECK:

   Slide 1: [Titulo] — Cover
   Slide 2: [Titulo] — [Descripcion breve]
   Slide 3: [Titulo] — [Descripcion breve]
   ...

   Este outline esta bien o quieres ajustar algo?
   ```

2. **Genera el HTML completo** usando como referencia el template en `references/template.html`. El HTML debe incluir:
   - Navegacion: flechas, keyboard (izquierda/derecha), touch (swipe), click
   - Contador de slides (1/N)
   - Barra de progreso
   - Boton "Export PDF" que usa `window.print()` nativo (preserva links clickeables y texto copiable)
   - Print styles con @media print para formato 16:9

3. **Guarda como `DECK.html`** en la carpeta del proyecto

4. **Ofrece abrir en browser:**
   ```bash
   open {ruta-proyecto}/DECK.html
   ```

5. **Loop de iteracion:**
   ```
   El deck esta listo. Que quieres hacer?

   [A] Esta perfecto — finalizar
   [B] Ajustar contenido de una slide especifica
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
   Deck completado

   Archivos:
   - {ruta-proyecto}/DECK.html
   - {ruta-proyecto}/deck-project.json

   Para exportar a PDF:
   1. Abre el HTML en Chrome
   2. Click en "Export PDF" (usa print nativo — Save as PDF)

   Para editar despues:
   - Ejecuta /deck-wizard y elige "Continuar un deck en progreso"
   ```

---

## Template HTML

Lee `references/template.html` para ver la estructura base del HTML generado. El template incluye:
- Variables CSS para branding dinamico
- Print styles @media print con formato 16:9 widescreen (13.333in x 7.5in)
- Navegacion completa (keyboard, touch, click, botones)
- Funcion exportToPdf() que usa `window.print()` nativo

Adapta el template al contenido y branding del usuario. Los estilos de slides, tipografia, y componentes visuales (stat cards, grids, quotes, etc.) se generan segun el tipo de presentacion elegido en Fase 3.

---

## Notas de diseno

- **Usa AskUserQuestion para las opciones** en lugar de asumir — el usuario conoce su audiencia y contexto mejor que nadie, y elegir activamente aumenta la satisfaccion con el resultado final.
- **Confirma cada fase antes de avanzar** — corregir temprano es mucho mas rapido que rehacer un deck completo.
- **El loop de iteracion es fundamental** — las presentaciones rara vez quedan perfectas al primer intento, y pequenos ajustes hacen una gran diferencia en el impacto visual.
- **Guarda estado en deck-project.json** — permite retomar sesiones interrumpidas sin perder progreso.
- **El skill socratico es dependencia opcional** — el wizard funciona completo sin el, pero el analisis socratico ayuda a estructurar ideas cuando el usuario no tiene claro el contenido.
