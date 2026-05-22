package com.universidad.proyecto.controller;

import com.universidad.proyecto.dao.UsuarioDAO;
import com.universidad.proyecto.model.Estudiante;
import com.universidad.proyecto.model.Instructor;
import com.universidad.proyecto.model.Usuario;
import com.universidad.proyecto.util.AlertUtil;
import javafx.beans.property.SimpleStringProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.geometry.Insets;
import javafx.scene.control.*;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.*;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 * Controlador del Módulo 2: Gestión de Usuarios.
 * CRUD de usuarios respetando la jerarquía USUARIO → ESTUDIANTE / INSTRUCTOR.
 */
public class UsuariosController {

    @FXML private TableView<Usuario>         tablaUsuarios;
    @FXML private TableColumn<Usuario,Integer> colId;
    @FXML private TableColumn<Usuario,String>  colNombre;
    @FXML private TableColumn<Usuario,String>  colEmail;
    @FXML private TableColumn<Usuario,String>  colNickname;
    @FXML private TableColumn<Usuario,String>  colRol;
    @FXML private TableColumn<Usuario,String>  colActivo;
    @FXML private TableColumn<Usuario,String>  colFecha;
    @FXML private TableColumn<Usuario,Void>    colAcciones;

    @FXML private TextField        txtBuscar;
    @FXML private ComboBox<String> cmbRol;
    @FXML private ToggleButton     toggleSoloActivos;
    @FXML private Label            lblConteo;

    // Resumen
    @FXML private Label lblTotalUsuarios;
    @FXML private Label lblTotalEstudiantes;
    @FXML private Label lblTotalInstructores;
    @FXML private Label lblTotalActivos;

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private ObservableList<Usuario> usuariosData = FXCollections.observableArrayList();

    // ──────────────────────────────────────────────

    @FXML
    public void initialize() {
        configurarColumnas();
        cmbRol.setItems(FXCollections.observableArrayList(
            "Todos", "estudiante", "instructor", "administrador"
        ));
        cmbRol.setValue("Todos");
        cargarUsuarios();
    }

    // ──────────────────────────────────────────────
    // Configuración columnas
    // ──────────────────────────────────────────────

    private void configurarColumnas() {
        colId.setCellValueFactory(new PropertyValueFactory<>("idUsuario"));
        colNombre.setCellValueFactory(new PropertyValueFactory<>("nombre"));
        colEmail.setCellValueFactory(new PropertyValueFactory<>("email"));
        colNickname.setCellValueFactory(new PropertyValueFactory<>("nickname"));
        colRol.setCellValueFactory(new PropertyValueFactory<>("rol"));
        colActivo.setCellValueFactory(c ->
            new SimpleStringProperty(c.getValue().getActivoTexto()));
        colFecha.setCellValueFactory(c -> {
            var f = c.getValue().getFechaRegistro();
            return new SimpleStringProperty(f != null ? f.toString() : "");
        });

        // Badge para rol
        colRol.setCellFactory(col -> new TableCell<>() {
            @Override protected void updateItem(String rol, boolean empty) {
                super.updateItem(rol, empty);
                if (empty || rol == null) { setText(null); setGraphic(null); return; }
                Label badge = new Label(rol);
                badge.getStyleClass().add("badge");
                badge.getStyleClass().add(switch (rol) {
                    case "instructor"    -> "badge-blue";
                    case "administrador" -> "badge-purple";
                    default              -> "badge-gray";
                });
                setGraphic(badge); setText(null);
            }
        });

        // Badge para estado
        colActivo.setCellFactory(col -> new TableCell<>() {
            @Override protected void updateItem(String estado, boolean empty) {
                super.updateItem(estado, empty);
                if (empty || estado == null) { setText(null); setGraphic(null); return; }
                Label badge = new Label(estado);
                badge.getStyleClass().add("badge");
                badge.getStyleClass().add("Activo".equals(estado) ? "badge-green" : "badge-red");
                setGraphic(badge); setText(null);
            }
        });

        // Acciones
        colAcciones.setCellFactory(col -> new TableCell<>() {
            private final Button btnEdit       = new Button("✏️");
            private final Button btnDeactivate = new Button("🚫");
            {
                btnEdit.getStyleClass().add("btn-icon");
                btnDeactivate.getStyleClass().add("btn-icon-danger");
                btnDeactivate.setTooltip(new Tooltip("Desactivar usuario"));
                btnEdit.setOnAction(e -> {
                    Usuario u = getTableView().getItems().get(getIndex());
                    openEditDialog(u);
                });
                btnDeactivate.setOnAction(e -> {
                    Usuario u = getTableView().getItems().get(getIndex());
                    deactivateUsuario(u);
                });
            }
            @Override protected void updateItem(Void v, boolean empty) {
                super.updateItem(v, empty);
                if (empty) { setGraphic(null); return; }
                Usuario u = getTableView().getItems().get(getIndex());
                btnDeactivate.setDisable(u.getActivo() == 0);
                HBox box = new HBox(6, btnEdit, btnDeactivate);
                box.setAlignment(javafx.geometry.Pos.CENTER);
                setGraphic(box);
            }
        });

        tablaUsuarios.setItems(usuariosData);
    }

    // ──────────────────────────────────────────────
    // Carga de datos
    // ──────────────────────────────────────────────

    private void cargarUsuarios() {
        try {
            String nombre = txtBuscar.getText();
            String rol    = cmbRol.getValue();
            List<Usuario> lista = usuarioDAO.findByFiltro(nombre, rol);

            // Filtro solo activos
            if (toggleSoloActivos != null && toggleSoloActivos.isSelected()) {
                lista = lista.stream().filter(u -> u.getActivo() == 1).toList();
            }

            usuariosData.setAll(lista);
            lblConteo.setText(lista.size() + " registro(s)");
            actualizarResumen(lista);
        } catch (SQLException e) {
            AlertUtil.showError("Error de base de datos", e.getMessage());
        }
    }

    private void actualizarResumen(List<Usuario> lista) {
        long total       = lista.size();
        long estudiantes = lista.stream().filter(u -> "estudiante".equals(u.getRol())).count();
        long instructores= lista.stream().filter(u -> "instructor".equals(u.getRol())).count();
        long activos     = lista.stream().filter(u -> u.getActivo() == 1).count();

        lblTotalUsuarios.setText("Total: " + total);
        lblTotalEstudiantes.setText("Estudiantes: " + estudiantes);
        lblTotalInstructores.setText("Instructores: " + instructores);
        lblTotalActivos.setText("Activos: " + activos);
    }

    // ──────────────────────────────────────────────
    // Búsqueda
    // ──────────────────────────────────────────────

    @FXML public void onBuscar()  { cargarUsuarios(); }

    @FXML public void onLimpiar() {
        txtBuscar.clear();
        cmbRol.setValue("Todos");
        if (toggleSoloActivos != null) toggleSoloActivos.setSelected(false);
        cargarUsuarios();
    }

    // ──────────────────────────────────────────────
    // CREATE – Estudiante
    // ──────────────────────────────────────────────

    @FXML public void openCreateEstudiante() {
        Dialog<ButtonType> dialog = new Dialog<>();
        dialog.setTitle("Nuevo Estudiante");

        GridPane grid = buildBaseUserGrid();
        TextField   fNombre   = (TextField)   grid.getChildren().get(1);
        TextField   fEmail    = (TextField)   grid.getChildren().get(3);
        TextField   fNickname = (TextField)   grid.getChildren().get(5);
        PasswordField fPass   = (PasswordField) grid.getChildren().get(7);

        // Campos específicos de estudiante
        TextArea    fAreas    = new TextArea();
        fAreas.setPromptText("Ej: Java, Bases de datos, IA");
        fAreas.setPrefRowCount(2);
        DatePicker  fNacim    = new DatePicker();
        ComboBox<String> fNivel = new ComboBox<>(FXCollections.observableArrayList(
            "Bachillerato", "Técnico", "Tecnólogo", "Pregrado", "Posgrado", "Otro"
        ));
        CheckBox    fNotif    = new CheckBox("Recibir notificaciones por correo");
        fNotif.setSelected(true);

        grid.addRow(4, label("Áreas de interés"), fAreas);
        grid.addRow(5, label("Fecha nacimiento"),  fNacim);
        grid.addRow(6, label("Nivel educativo"),   fNivel);
        grid.addRow(7, label(""),                  fNotif);
        GridPane.setHgrow(fAreas, Priority.ALWAYS);

        dialog.getDialogPane().setContent(grid);
        dialog.getDialogPane().getButtonTypes().addAll(ButtonType.OK, ButtonType.CANCEL);
        styleDialog(dialog);

        Optional<ButtonType> result = dialog.showAndWait();
        if (result.isEmpty() || result.get() == ButtonType.CANCEL) return;

        if (!validarBase(fNombre, fEmail, fNickname, fPass)) return;

        try {
            // Regla RN01/RN02: email y nickname únicos
            if (usuarioDAO.existeEmail(fEmail.getText().trim(), 0)) {
                AlertUtil.showWarning("Email duplicado", "Ya existe un usuario con ese email.");
                return;
            }
            if (usuarioDAO.existeNickname(fNickname.getText().trim(), 0)) {
                AlertUtil.showWarning("Nickname duplicado", "Ese nickname ya está en uso.");
                return;
            }

            Estudiante e = new Estudiante();
            e.setNombre(fNombre.getText().trim());
            e.setEmail(fEmail.getText().trim());
            e.setNickname(fNickname.getText().trim());
            e.setContrasena(fPass.getText());
            e.setAreasInteres(fAreas.getText().trim());
            e.setFechaNacim(fNacim.getValue());
            e.setNivelEducativo(fNivel.getValue());
            e.setNotifEmail(fNotif.isSelected() ? 1 : 0);

            usuarioDAO.insertEstudiante(e);
            cargarUsuarios();
            AlertUtil.showInfo("Éxito", "Estudiante registrado correctamente.");
        } catch (SQLException ex) {
            AlertUtil.showError("Error al guardar", ex.getMessage());
        }
    }

    // ──────────────────────────────────────────────
    // CREATE – Instructor
    // ──────────────────────────────────────────────

    @FXML public void openCreateInstructor() {
        Dialog<ButtonType> dialog = new Dialog<>();
        dialog.setTitle("Nuevo Instructor");

        GridPane grid = buildBaseUserGrid();
        TextField     fNombre   = (TextField)     grid.getChildren().get(1);
        TextField     fEmail    = (TextField)     grid.getChildren().get(3);
        TextField     fNickname = (TextField)     grid.getChildren().get(5);
        PasswordField fPass     = (PasswordField) grid.getChildren().get(7);

        TextField fEspecialidad = new TextField();
        fEspecialidad.setPromptText("Ej: Java, Machine Learning…");
        TextArea fBiografia = new TextArea();
        fBiografia.setPromptText("Breve descripción del instructor");
        fBiografia.setPrefRowCount(3);

        grid.addRow(4, label("Especialidad"),  fEspecialidad);
        grid.addRow(5, label("Biografía"),     fBiografia);
        GridPane.setHgrow(fEspecialidad, Priority.ALWAYS);
        GridPane.setHgrow(fBiografia,    Priority.ALWAYS);

        dialog.getDialogPane().setContent(grid);
        dialog.getDialogPane().getButtonTypes().addAll(ButtonType.OK, ButtonType.CANCEL);
        styleDialog(dialog);

        Optional<ButtonType> result = dialog.showAndWait();
        if (result.isEmpty() || result.get() == ButtonType.CANCEL) return;

        if (!validarBase(fNombre, fEmail, fNickname, fPass)) return;

        try {
            if (usuarioDAO.existeEmail(fEmail.getText().trim(), 0)) {
                AlertUtil.showWarning("Email duplicado", "Ya existe un usuario con ese email.");
                return;
            }
            if (usuarioDAO.existeNickname(fNickname.getText().trim(), 0)) {
                AlertUtil.showWarning("Nickname duplicado", "Ese nickname ya está en uso.");
                return;
            }

            Instructor inst = new Instructor();
            inst.setNombre(fNombre.getText().trim());
            inst.setEmail(fEmail.getText().trim());
            inst.setNickname(fNickname.getText().trim());
            inst.setContrasena(fPass.getText());
            inst.setEspecialidad(fEspecialidad.getText().trim());
            inst.setBiografia(fBiografia.getText().trim());

            usuarioDAO.insertInstructor(inst);
            cargarUsuarios();
            AlertUtil.showInfo("Éxito", "Instructor registrado correctamente.");
        } catch (SQLException ex) {
            AlertUtil.showError("Error al guardar", ex.getMessage());
        }
    }

    // ──────────────────────────────────────────────
    // UPDATE – datos básicos
    // ──────────────────────────────────────────────

    private void openEditDialog(Usuario usuario) {
        Dialog<ButtonType> dialog = new Dialog<>();
        dialog.setTitle("Editar Usuario");

        GridPane grid = new GridPane();
        grid.setHgap(12); grid.setVgap(10);
        grid.setPadding(new Insets(16));

        TextField fNombre   = new TextField(usuario.getNombre());
        TextField fEmail    = new TextField(usuario.getEmail());
        TextField fNickname = new TextField(usuario.getNickname());
        ComboBox<String> fActivo = new ComboBox<>(
            FXCollections.observableArrayList("Activo", "Inactivo"));
        fActivo.setValue(usuario.getActivo() == 1 ? "Activo" : "Inactivo");

        grid.addRow(0, label("Nombre *"),   fNombre);
        grid.addRow(1, label("Email *"),    fEmail);
        grid.addRow(2, label("Nickname *"), fNickname);
        grid.addRow(3, label("Estado"),     fActivo);
        GridPane.setHgrow(fNombre,   Priority.ALWAYS);
        GridPane.setHgrow(fEmail,    Priority.ALWAYS);
        GridPane.setHgrow(fNickname, Priority.ALWAYS);

        dialog.getDialogPane().setContent(grid);
        dialog.getDialogPane().getButtonTypes().addAll(ButtonType.APPLY, ButtonType.CANCEL);
        styleDialog(dialog);

        Optional<ButtonType> result = dialog.showAndWait();
        if (result.isEmpty() || result.get() == ButtonType.CANCEL) return;

        if (fNombre.getText().isBlank() || fEmail.getText().isBlank()) {
            AlertUtil.showWarning("Validación", "Nombre y email son obligatorios.");
            return;
        }

        try {
            if (usuarioDAO.existeEmail(fEmail.getText().trim(), usuario.getIdUsuario())) {
                AlertUtil.showWarning("Email duplicado", "Ese email ya está en uso.");
                return;
            }
            if (usuarioDAO.existeNickname(fNickname.getText().trim(), usuario.getIdUsuario())) {
                AlertUtil.showWarning("Nickname duplicado", "Ese nickname ya está en uso.");
                return;
            }
            usuario.setNombre(fNombre.getText().trim());
            usuario.setEmail(fEmail.getText().trim());
            usuario.setNickname(fNickname.getText().trim());
            usuario.setActivo("Activo".equals(fActivo.getValue()) ? 1 : 0);

            usuarioDAO.update(usuario);
            cargarUsuarios();
            AlertUtil.showInfo("Éxito", "Usuario actualizado.");
        } catch (SQLException ex) {
            AlertUtil.showError("Error al actualizar", ex.getMessage());
        }
    }

    // ──────────────────────────────────────────────
    // DELETE lógico
    // ──────────────────────────────────────────────

    private void deactivateUsuario(Usuario usuario) {
        if (!AlertUtil.showConfirmation("Desactivar usuario",
            "¿Desactivar a \"" + usuario.getNombre() + "\"?\n"
            + "El usuario no podrá acceder al sistema.")) return;
        try {
            usuarioDAO.deactivate(usuario.getIdUsuario());
            cargarUsuarios();
            AlertUtil.showInfo("Desactivado", "Usuario desactivado correctamente.");
        } catch (SQLException ex) {
            AlertUtil.showError("Error", ex.getMessage());
        }
    }

    // ──────────────────────────────────────────────
    // Helpers
    // ──────────────────────────────────────────────

    private GridPane buildBaseUserGrid() {
        GridPane grid = new GridPane();
        grid.setHgap(12); grid.setVgap(10);
        grid.setPadding(new Insets(16));

        TextField     fNombre   = new TextField();
        TextField     fEmail    = new TextField();
        TextField     fNickname = new TextField();
        PasswordField fPass     = new PasswordField();
        fNombre.setPromptText("Nombre completo");
        fEmail.setPromptText("correo@ejemplo.com");
        fNickname.setPromptText("alias único");
        fPass.setPromptText("Contraseña");

        grid.addRow(0, label("Nombre *"),   fNombre);
        grid.addRow(1, label("Email *"),    fEmail);
        grid.addRow(2, label("Nickname *"), fNickname);
        grid.addRow(3, label("Contraseña *"), fPass);
        GridPane.setHgrow(fNombre,   Priority.ALWAYS);
        GridPane.setHgrow(fEmail,    Priority.ALWAYS);
        GridPane.setHgrow(fNickname, Priority.ALWAYS);
        GridPane.setHgrow(fPass,     Priority.ALWAYS);

        return grid;
    }

    private boolean validarBase(TextField fNombre, TextField fEmail,
                                TextField fNickname, PasswordField fPass) {
        if (fNombre.getText().isBlank() || fEmail.getText().isBlank()
            || fNickname.getText().isBlank() || fPass.getText().isBlank()) {
            AlertUtil.showWarning("Validación", "Todos los campos marcados con * son obligatorios.");
            return false;
        }
        if (!fEmail.getText().contains("@")) {
            AlertUtil.showWarning("Validación", "Ingresa un email válido.");
            return false;
        }
        return true;
    }

    private Label label(String text) {
        Label l = new Label(text);
        l.setStyle("-fx-font-weight: bold; -fx-text-fill: #374151;");
        return l;
    }

    private void styleDialog(Dialog<?> d) {
        d.getDialogPane().getStylesheets().add(
            getClass().getResource("/css/styles.css").toExternalForm());
        d.getDialogPane().setPrefWidth(480);
    }
}
