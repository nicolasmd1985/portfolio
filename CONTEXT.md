# 📋 Registro de Contexto y Seguimiento Técnico

**Fecha:** 1 de Noviembre de 2026  
**Proyecto:** Portafolio Web Personal (Ruby on Rails 8.0)  
**Autor:** Nicolas Mahecha  
**Servidor GCP:** `35.255.35.187` (`nicolasmelectronic`)  
**Dominio Principal:** `https://nicolasmahecha.com`

---

## 🎯 1. Objetivo de la Sesión
Integrar de forma profesional y dinámica todos los microservicios y proyectos reales que se encuentran actualmente desplegados y corriendo en el servidor en la nube de Google Cloud Platform (GCP) en el sitio web de portafolio, tanto en la **sección de proyectos de la página principal (`/`)** como en la **página dedicada de proyectos (`/projects`)**.

---

## 🔍 2. Auditoría del Servidor y Mapeo Nginx

Se realizó una inspección vía SSH a las configuraciones de Nginx (`/etc/nginx/sites-available/` y `/etc/nginx/sites-enabled/`) y los contenedores Docker en ejecución:

| Puerto | Contenedor / Servicio | Ruta Nginx / Dominio | Descripción del Proyecto | Estado en Vivo |
| :---: | :--- | :--- | :--- | :---: |
| **3000** | `ordenapp_web_container` | `https://nicolasmahecha.com/ordenapp/` | **OrdenApp**: Plataforma SaaS empresarial de gestión de activos, mantenimiento y despacho de órdenes de trabajo en tiempo real. | 🟢 En línea |
| **3001** | `backyard_rails_web` (API) + `/var/www/backyard` (Expo Web) | `https://nicolasmahecha.com/backyard/` *(API en `/backyardAIAPI/`)* | **Backyard AI**: Rediseño paisajístico de exteriores con IA generativa multimodal (Google Gemini Vision y Nano Banana) adaptado a botánica nativa. | 🟢 En línea |
| **3002** | `portfolio-web-1` | `https://nicolasmahecha.com/` | **Portfolio**: Aplicación Rails 8 con arquitectura Hotwire, Tailwind CSS y servidor Puma. | 🟢 En línea |
| **5000** | `drumplay-app` | `https://nicolasmahecha.com/drumplay/` | **DrumPlay**: Plataforma interactiva de práctica para batería electrónica (Alesis Nitro Mesh) con pentagrama doble en tiempo real (MIDI vs DSP de audio con Librosa/Demucs). | 🟢 En línea |
| **8000** | `alarmtronics-receptionist` | `https://voz.nicolasmahecha.com` | **Alarmtronics Voice Dispatch**: Recepcionista telefónico de IA conversacional para alarmas de incendio/intrusión con Google Gemini Live API y telefonía Telnyx TeXML. | 🟢 En línea |
| **5432** | `portfolio-postgres-1` | `localhost:5432` | **PostgreSQL 15**: Motor de base de datos relacional compartido en el servidor. | 🟢 Activo |

---

## 📸 3. Generación y Captura de Assets Reales

Utilizando Chromium Headless directamente sobre los endpoints públicos en HTTPS, se extrajeron capturas de pantalla auténticas de alta resolución para evitar placeholders y reflejar el software real:
- `app/assets/images/projects/ordenapp.png`
- `app/assets/images/projects/backyard.png`
- `app/assets/images/projects/drumplay.png`
- `app/assets/images/projects/alarmtronics.png`

Todos los assets quedaron registrados en el pipeline moderno de Rails (Propshaft) y se digieren automáticamente en producción (`/assets/projects/...`).

---

## 🛠️ 4. Cambios Realizados en el Backend (Ruby on Rails)

### 4.1. Migración de Base de Datos
- **Archivo:** `db/migrate/20261101230000_add_details_to_projects.rb`
- **Nuevas Columnas en la tabla `projects`:**
  - `url`: Enlace directo al proyecto en producción.
  - `tags`: Tecnologías y dependencias clave en formato lista.
  - `status`: Estado del servicio (ej. *"Live Platform"*, *"Live Demo"*, *"Live Voice System"*).
  - `featured`: Booleano para destacar en el Home (`default: true`).
  - `position`: Entero para controlar el orden de visualización.
  - `category`: Categoría funcional (SaaS, IA, Audio, IoT).
  - `port`: Puerto de red en el host (ej. `3000`, `3001`, `5000`, `8000`).
  - `github_url`: Enlace opcional a código fuente.
- **Esquema:** Actualizado a la versión `2026_11_01_230000` en `db/schema.rb`.

### 4.2. Modelo `Project` (`app/models/project.rb`)
- Scopes: `scope :featured` y `scope :ordered`.
- Helpers: `tags_list`, `live?`, `key`.
- Soporte I18n Dinámico: Métodos `localized_title`, `localized_description`, `localized_category` que consultan automáticamente las traducciones según el idioma actual (`:es` / `:en`).
- Método de Resiliencia: `Project.display_projects` retorna los registros de la base de datos o, en caso de bases de datos vacías/frías, un conjunto de fallback estructurado para garantizar que la interfaz jamás quede vacía.

### 4.3. Semillas de Base de Datos (`db/seeds.rb`)
- Script idempotente con los 4 proyectos en vivo y el caso de estudio de hardware IoT (*Autonomous RV Off-Grid Energy Grid*), permitiendo inicializaciones y actualizaciones seguras en cualquier entorno mediante `rails db:seed`.

### 4.4. Controlador `PagesController` (`app/controllers/pages_controller.rb`)
- Acciones `home` y `projects` actualizadas para cargar `@projects = Project.display_projects`.

### 4.5. Internacionalización (`config/locales/en.yml` y `config/locales/es.yml`)
- Creados bloques completos de traducción bilingüe para:
  - Títulos y subtítulos de sección.
  - Textos descriptivos y categorías de cada proyecto en inglés y español.
  - Botones de acción (*"Launch Live App"* / *"Abrir Proyecto"*).
  - Filtros y etiquetas de infraestructura.

---

## 🎨 5. Cambios Realizados en el Frontend (UI / UX)

### 5.1. Página Principal (`app/views/pages/home.html.erb`)
- Sección `#projects` rediseñada con estética dark mode, baliza verde pulsante (*"Live in Production"*), mockup de ventana de navegador con dirección URL real y etiqueta del puerto.
- Imagen interactiva con efecto zoom y overlay: hacer clic en la fotografía o en el botón **"Launch Live App ↗"** abre la aplicación web en una nueva pestaña (`target="_blank"` con `rel="noopener noreferrer"`).
- Tarjetas ordenadas alternadas en diseño responsive (2 columnas en pantallas grandes).

### 5.2. Catálogo de Proyectos (`app/views/pages/projects.html.erb`)
- Rediseño completo reemplazando la lista horizontal básica anterior.
- Banner de especificaciones de infraestructura en la nube (GCP, Nginx SSL, Docker, PostgreSQL).
- **Filtros por Categoría en Tiempo Real:** Botones interactivos en JavaScript (Todos, IA & Multimodal, Web & SaaS, Audio & DSP, IoT & Hardware).
- Grid de 2 columnas con tarjetas completas, badges, etiquetas de tecnologías y botones de lanzamiento directo.

### 5.3. Build de Estilos (`package.json`)
- Se corrigió el comando `"build:css"` para apuntar explícitamente a `./config/tailwind.config.js`, eliminando la advertencia de utilidades no detectadas y generando la hoja de estilos minificada en `app/assets/builds/application.css`.

---

## 🚀 6. CI/CD y Pipeline de Despliegue

1. **Script de Despliegue (`deploy_script.sh`):**
   - Agregado el paso `rails db:seed` inmediatamente después de `rails db:migrate` para sincronizar automáticamente los nuevos proyectos al reiniciar contenedores.
2. **GitHub Actions Workflow (`.github/workflows/deploy.yml`):**
   - Actualizada la plantilla del script de despliegue en el runner para invocar `db:migrate` y `db:seed`.
3. **Commit Git:**
   - Commit creado localmente en la rama `main`:
     ```text
     commit 18d0484
     Author: Nicolas Mahecha
     Date:   Sun Nov 1 19:44:14 2026 -0500
     
     Add live running microservices to portfolio with Nginx links and authentic screenshots
     ```

---

## 📌 7. Próximos Pasos para Desplegar a Producción

Para aplicar los cambios en el servidor en vivo:
1. Enviar los cambios al repositorio remoto:
   ```bash
   git push origin main
   ```
2. GitHub Actions compilará la imagen de Docker `nicolasmd/portfolio:latest`, la subirá a Docker Hub y se conectará por SSH a `35.255.35.187` para ejecutar `deploy_script.sh`.
3. Validar la respuesta del sitio en producción:
   ```bash
   curl -I https://nicolasmahecha.com/
   curl -I https://nicolasmahecha.com/projects
   ```
