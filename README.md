# App Parcial - Flutter & Firebase TikTok Feed 📱🔥

Aplicación móvil y web desarrollada en Flutter con autenticación completa mediante **Firebase Authentication** y un **feed de videos vertical estilo TikTok**.

---

## 🚀 Características Principales

### 1. Autenticación Multifactor con Firebase
- **Correo y Contraseña:**
  - Registro con validación en tiempo real (`Form` y `GlobalKey<FormState>`): campos obligatorios, formato de correo con regex, contraseña mínima de 6 caracteres y confirmación coincidente.
  - Creación de usuario con `createUserWithEmailAndPassword` y almacenamiento del nombre con `updateDisplayName`.
  - Inicio de sesión con `signInWithEmailAndPassword`.
  - Mensajes de error claros y en español (correo duplicado, contraseña débil, credenciales inválidas, etc.).
- **Inicio de Sesión con Google:** Integración con `google_sign_in` y credencial en Firebase (`GoogleAuthProvider`).
- **Inicio de Sesión con Facebook:** Integración con `flutter_facebook_auth` y credencial en Firebase (`FacebookAuthProvider`).

### 2. Enrutamiento y Protección de Rutas con `go_router`
- Rutas configuradas:
  - `/login`: Vista principal de acceso.
  - `/registro`: Formulario de registro con enlace directo a login.
  - `/feed`: Feed estilo TikTok con videos interactivos.
- **Redirección reactiva (`redirect`):**
  - Si no hay sesión iniciada, el usuario únicamente puede acceder a `/login` y `/registro`. Si intenta acceder a `/feed`, es redirigido a `/login`.
  - Si hay sesión activa, el usuario es redirigido automáticamente a `/feed`.
  - El router reacciona en tiempo real a los cambios en `FirebaseAuth.instance.authStateChanges()`.

### 3. Feed de Videos Vertical Estilo TikTok (`/feed`)
- **PageView vertical a pantalla completa** con al menos 4 videos en alta calidad.
- **Reproducción inteligente:** Solo se reproduce automáticamente el video visible en pantalla.
- **Control táctil:** Toca la pantalla para pausar o reanudar el video en cualquier momento con animación visual.
- **Doble toque:** Like interactivo con animación.
- **Overlays sobre el video:**
  - Nombre y usuario (`@usuario`).
  - Descripción y hashtags.
  - Pista de audio/música.
  - Botones de acción lateral: Like (con contador interactivo), Comentarios (con modal deslizante de comentarios) y Compartir.
- **Barra Superior & Logout:**
  - Muestra el nombre o correo del usuario autenticado.
  - Botón de cierre de sesión que desconecta Firebase, Google y Facebook, devolviendo el flujo al login.

---

## 📦 Paquetes Utilizados

```yaml
dependencies:
  flutter:
    sdk: flutter
  go_router: ^18.1.4
  firebase_core: ^5.2.0
  firebase_auth: ^7.1.0
  google_sign_in: ^7.2.0
  flutter_facebook_auth: ^7.3.3
  video_player: ^2.14.1
```

---

## 🛠️ Configuración de Firebase con `flutterfire configure`

1. **Iniciar sesión en Firebase CLI:**
   ```bash
   firebase login
   ```
2. **Configurar la aplicación:**
   ```bash
   flutterfire configure
   ```
   Selecciona tu proyecto de Firebase y las plataformas deseadas (Android, Web, etc.).
3. **En la consola de Firebase (Authentication > Sign-in method):**
   - Habilita **Correo electrónico/contraseña**.
   - Habilita **Google**.
   - Habilita **Facebook** (ingresando App ID y App Secret de Meta Developers).

---

## 📸 Demostración / Capturas de Pantalla

| Inicio de Sesión (`/login`) | Registro (`/registro`) | Feed TikTok (`/feed`) |
|:---:|:---:|:---:|
| Formulario validado con Google y Facebook | Registro con confirmación y display name | Videos verticales full screen con autoplay y controles |

> *Nota: Para la entrega en GitHub, puedes adjuntar las capturas de pantalla de tu emulador o dispositivo en la carpeta `screenshots/` o enlazar un video demostrativo de YouTube/Loom aquí.*

---

## 💻 Cómo ejecutar la aplicación

```bash
# Obtener dependencias
flutter pub get

# Ejecutar en el dispositivo o navegador seleccionado
flutter run
```
