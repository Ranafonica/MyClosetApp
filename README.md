# iCloset - Gestor de Prendas y Outfits

**iCloset** es una aplicación móvil desarrollada con Flutter que permite al usuario gestionar su propio clóset digital, organizando prendas por categoría, capturando imágenes desde la cámara, generando combinaciones (outfits) y visualizando closets de otros usuarios. Integrando un sistema para la organización de prendas de vestir, creación de conjuntos estilizados (outfits) y recomendaciones contextuales. La arquitectura sigue el patrón de repositorio con separación clara entre capas de presentación, lógica de negocio y acceso a datos.

---

##  Descripción del Proyecto

Esta aplicación busca brindar una experiencia práctica e intuitiva para que los usuarios puedan registrar y clasificar sus prendas de vestir, generando combinaciones personalizadas y visualmente atractivas. Su enfoque está orientado a personas interesadas en la moda, organización y reutilización inteligente de su ropa.

---

##  Requerimientos y Funcionalidades Implementadas

- Almacenamiento persistente de prendas utilizando **SQLite** (`sqflite`).
- Toma de fotografías desde la cámara del dispositivo.
- Clasificación de prendas por categorías predefinidas (Polera, Polerón, Pantalón, Accesorio).
- Registro de outfits personalizados que combinan parte superior, inferior, calzado y accesorios.
- Visualización del clóset personal en pantalla organizada por secciones.
- Pantalla de closets públicos con likes y nombres de usuarios ficticios.
- Interfaz de bienvenida (**SplashScreen**).
- Personalización de colores y fuentes mediante `theme.dart` y `util.dart`.
- Navegación entre pantallas mediante `Drawer`.
- Integración del archivo `apk` para instalación en Android.

---

##  Estructura del Proyecto

- `lib/pages/`: Contiene las pantallas principales (`home.dart`, `my_closet.dart`, `world_closets.dart`, etc.)
- `lib/db/`: Lógica de base de datos persistente (`closet_database.dart`)
- `lib/entity/`: Modelos de datos (`closet_item.dart`, `outfit.dart`)
- `lib/theme/`: Archivos de paleta de colores y fuentes (`theme.dart`, `util.dart`)
- `assets/`: Recursos gráficos utilizados (imágenes de prendas, íconos, logo)

---

## Instalación

Puedes instalar la app descargando el siguiente archivo APK e instalándolo en un dispositivo Android:

 [Descargar iCloset APK](https://github.com/Ranafonica/MyClosetApp/blob/main/flutter_myclosetapp/download/apk/app-v1.0.1.apk)

> Nota: Debes habilitar “Fuentes desconocidas” en el dispositivo para instalar manualmente.

---

## Capturas de Pantalla

### Página Principal

![Home](assets/screenshots/home.png)

### Clóset Personal

![My Closet](assets/screenshots/mycloset.png)

### World Closets

![World Closets](assets/screenshots/worldcloset.png)

### Agregar Prenda

![Agregar Prenda](assets/screenshots/outfit.png)

### Cuenta

![Cuenta](assets/screenshots/account.png)

### Preferencias

![Preferencias](assets/screenshots/preferences.png)

---

## Video de Exposición

[Ver presentación de la aplicación en YouTube](https://www.youtube.com/watch?v=TU_LINK_AQUI)

---

## Información Técnica

- Framework: **Flutter**
- Lenguaje: **Dart**
- Base de datos local: **sqflite**
- Gestión de imágenes: **image_picker**, **path_provider**
- Sistema operativo: **Android**
- Arquitectura: **StatefulWidgets + SQLite persistencia**
- Paleta de colores: personalizada desde `theme.dart` usando Material3
- Firma del paquete: `cl.mbascunan.icloset`

---

## Autor y Contacto

**Desarrollador:** Martín Bascuñán  
**Repositorio:** [github.com/Ranafonica/MyClosetApp](https://github.com/Ranafonica/MyClosetApp)

---

