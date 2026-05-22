# 🎓 Sistema de Gestión de Cursos Online

**Proyecto Final – Bases de Datos 2026-10**
Pontificia Universidad Javeriana, Bogotá

## 👥 Integrantes

| Nombre | Código |
|---|---|
| Nicolas Jimenez Castiblanco | 00020572219 |
| Johan Santiago Cadena Goyeneche | 00020582219 |
| Jhon Sebastian Mejia Alvarez | 00020557840 |
| Alejandro Rodriguez Molina | 000205797180 |

## 🛠 Tecnologías

- **Java 17+** con **JavaFX 17**
- **Oracle Database 23** (Free / XE)
- **JDBC** con `ojdbc11`
- **Maven** como herramienta de build

---

## ⚙️ Configuración e Instalación

### Requisitos previos

| Herramienta | Versión mínima |
|---|---|
| JDK | 17 |
| Maven | 3.8 |
| Oracle DB | 23 Free / XE |

---

### Paso 1 – Clonar el repositorio

```bash
git clone <URL_DEL_REPO>
cd proyecto-bd
```

### Paso 2 – Configurar la base de datos Oracle

1. Abre **SQL Developer** o **DataGrip** y conéctate a tu instancia Oracle.

2. Ejecuta primero los scripts de la Entrega 1 (si no lo has hecho):
   ```
   sql/01_crear_estructura.sql
   sql/02_insertar_datos.sql
   ```

3. Si las secuencias no estaban incluidas, ejecuta:
   ```
   sql/00_secuencias.sql
   ```

### Paso 3 – Configurar credenciales de conexión

Edita el archivo:
```
src/main/resources/config/database.properties
```

```properties
# URL de conexión — ajusta HOST:PORT/SERVICE según tu entorno
db.url=jdbc:oracle:thin:@localhost:1521/FREEPDB1

# Credenciales del usuario Oracle
db.user=SYSTEM
db.password=TU_PASSWORD
```

> **Tip Javeriana:** Si usas el servidor de la universidad, cambia la URL a:
> `jdbc:oracle:thin:@servidor-bd.javeriana.edu.co:1521/XE`

### Paso 4 – Compilar y ejecutar

```bash
# Compilar
mvn clean compile

# Ejecutar con el plugin JavaFX
mvn javafx:run

# O generar un JAR ejecutable
mvn clean package
java --module-path $PATH_TO_FX --add-modules javafx.controls,javafx.fxml -jar target/proyecto-bd-1.0-SNAPSHOT.jar
```

---

## 📦 Estructura del Proyecto

```
proyecto-bd/
├── src/
│   └── main/
│       ├── java/com/universidad/proyecto/
│       │   ├── App.java                   ← Punto de entrada
│       │   ├── model/                     ← POJOs (Usuario, Curso, etc.)
│       │   ├── dao/                       ← Acceso a datos (JDBC)
│       │   ├── controller/                ← Controladores FXML
│       │   └── util/                      ← DatabaseConnection, AlertUtil
│       └── resources/
│           ├── fxml/                      ← Vistas JavaFX
│           ├── css/styles.css             ← Estilos de la UI
│           └── config/database.properties ← Configuración de BD
├── sql/
│   ├── 00_secuencias.sql                  ← Secuencias Oracle (si faltan)
│   ├── 01_crear_estructura.sql            ← DDL (entrega 1)
│   ├── 02_insertar_datos.sql              ← Datos de prueba
│   ├── 03_indices.sql                     ← Índices (entrega 2)
│   ├── 04_triggers_plsql.sql              ← Triggers/PL-SQL
│   └── 05_transacciones.sql              ← Demos de transacciones
├── pom.xml
└── README.md
```

---

## 🖥 Módulos implementados (Entrega 3)

### Módulo 1 – Gestión de Cursos
- ✅ Listado de cursos con filtro por título/categoría y estado
- ✅ Crear curso (con formulario validado)
- ✅ Editar curso existente
- ✅ Eliminar curso (con validación de estudiantes activos)
- ✅ Gestión de módulos del curso seleccionado (CRUD inline)
- ✅ Badges de estado (publicado / en_desarrollo / archivado)

### Módulo 2 – Gestión de Usuarios
- ✅ Listado de usuarios con filtro por nombre y rol
- ✅ Toggle "Solo activos"
- ✅ Registrar estudiante (con campos de herencia: áreas de interés, nivel, etc.)
- ✅ Registrar instructor (especialidad, biografía)
- ✅ Editar datos básicos de cualquier usuario
- ✅ Desactivación lógica (no borrado físico)
- ✅ Validación de unicidad: email y nickname
- ✅ Panel de resumen con contadores por rol y estado

---

## 🔒 Reglas de negocio implementadas

| Regla | Implementación |
|---|---|
| No borrar curso con estudiantes activos | Validación en `CursoDAO.delete()` |
| Email único por usuario | Validación antes de INSERT/UPDATE |
| Nickname único | Validación antes de INSERT/UPDATE |
| No borrar módulo con lecciones | Validación en `ModuloDAO.delete()` |
| Insertar estudiante/instructor es transacción | `conn.setAutoCommit(false)` + ROLLBACK |

---

## ⚠️ Solución de problemas

**Error: "Driver Oracle JDBC no encontrado"**
→ Verifica que el artefacto `ojdbc11` esté en tu repositorio Maven local:
```bash
mvn dependency:resolve
```

**Error: "ORA-12541: No listener"**
→ Oracle no está corriendo. Inicia el servicio:
```bash
# Windows
net start OracleServiceFREEPDB1

# Linux/Mac
sudo systemctl start oracle-xe
```

**Error al cargar FXML**
→ Asegúrate de ejecutar con `mvn javafx:run`, no con `java -jar` directamente sin el module-path.
