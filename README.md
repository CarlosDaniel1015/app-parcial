# App Parcial - Flutter & Firebase TikTok Feed 📱🔥

Aplicación móvil y web desarrollada en Flutter con autenticación completa mediante **Firebase Authentication** y un **feed de videos vertical estilo TikTok**.

---

## 🎥 Video Demostrativo del Funcionamiento

> [!IMPORTANT]
> **Enlace al video de demostración en Google Drive:**
> 
> 👉 **[VER VIDEO DEMOSTRATIVO COMPLETO AQUÍ](https://drive.google.com/file/d/1jHO87W0jLE1T3t_pcPNV79EJFZQNZcef/view?usp=sharing)** 👈
>
> *El video muestra: Registro de usuario por correo/contraseña, inicio de sesión con Google (selector de cuentas), inicio de sesión con Facebook, feed vertical estilo TikTok con videos de Pexels, pausa/reproducción interactiva y cierre de sesión.*

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

## 🛠️ Configuración en Firebase y Meta Developers

### 1. Activar Métodos de Inicio de Sesión en Firebase Console
Ingresa a [Firebase Console](https://console.firebase.google.com/), abre tu proyecto (`app-parcial-6b24e`), ve a **Compilación / Build > Authentication > Sign-in method**:
1. **Correo electrónico/contraseña (Obligatorio para el registro y login con email):**
   - Haz clic en **Correo electrónico/contraseña**.
   - Activa el interruptor **Habilitar**.
   - Haz clic en **Guardar**.
   *(Si este paso no se realiza, Firebase arroja el error: `Este método de inicio de sesión no está habilitado en Firebase` / `operation-not-allowed`).*
2. **Google:**
   - Haz clic en **Google**, activa el interruptor **Habilitar**, selecciona el correo de asistencia del proyecto y haz clic en **Guardar**.
3. **Facebook:**
   - Haz clic en **Facebook**, activa el interruptor **Habilitar**.
   - Requiere el **Identificador de la aplicación (App ID)** y el **Secreto de la aplicación (App Secret)** de [Meta for Developers](https://developers.facebook.com/).
   - Copia la **URI de redireccionamiento de OAuth** provista por Firebase (ej. `https://app-parcial-6b24e.firebaseapp.com/__/auth/handler`) y pégala en Meta Developers.

### 2. Solución al error de Facebook: *"La aplicación no está activa"*
Si al iniciar sesión con Facebook aparece el mensaje *"La aplicación no está activa: Actualmente, esta aplicación no está disponible y el desarrollador está al corriente del problema"*, se debe a que la aplicación en [Meta for Developers](https://developers.facebook.com/) está en **Modo de desarrollo**:
- **Opción A (Recomendada para pruebas):** En Meta for Developers ve a **Roles de la app > Roles** y agrega tu cuenta personal de Facebook como **Tester (Evaluador)** o **Desarrollador**.
- **Opción B (Publicación):** En la parte superior del panel de Meta for Developers, cambia el switch de **Modo de desarrollo** a **En vivo (Live)** (requiere configurar una Política de Privacidad).

---

## 🎬 Videos Verticales Pexels (Sin recargar GitHub)

Cumpliendo con los requisitos del parcial y la recomendación docente para mantener el repositorio ligero en GitHub:
- Los videos se transmiten vía streaming directamente desde la CDN de [Pexels Videos Verticales](https://www.pexels.com/es-es/buscar/videos/vertical/).
- Se encuentran definidos en `lib/models/video_item_model.dart` con URLs directas en formato vertical 9:16 (1080x1920) y metadatos de autor, descripción y música.

---

## 📸 Demostración / Capturas de Pantalla

| Inicio de Sesión (`/login`) | Registro (`/registro`) | Feed TikTok (`/feed`) |
|:---:|:---:|:---:|
| Formulario validado con Google y Facebook | Registro con confirmación y display name | Videos verticales full screen con autoplay y controles |

* **Video de prueba completo:** [Abrir video en Google Drive](https://drive.google.com/file/d/1jHO87W0jLE1T3t_pcPNV79EJFZQNZcef/view?usp=sharing)
*(Asegúrate de que el enlace de Google Drive tenga permisos de "Cualquier persona con el enlace puede ver").*

---

## 💻 Cómo ejecutar la aplicación

```bash
# Obtener dependencias
flutter pub get

# Ejecutar en el dispositivo o navegador seleccionado
flutter run
```
