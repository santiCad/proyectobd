package com.universidad.proyecto.controller;

import com.universidad.proyecto.dao.CursoDAO;
import com.universidad.proyecto.dao.ModuloDAO;
import com.universidad.proyecto.dao.UsuarioDAO;
import com.universidad.proyecto.model.Curso;
import com.universidad.proyecto.model.Instructor;
import com.universidad.proyecto.model.Modulo;
import com.universidad.proyecto.util.AlertUtil;
import javafx.beans.property.SimpleStringProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.geometry.Insets;
import javafx.scene.control.*;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.*;
import javafx.util.StringConverter;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public class CursosController {

    
    @FXML private TableView<Curso>      tablaCursos;
    @FXML private TableColumn<Curso,Integer> colId;
    @FXML private TableColumn<Curso,String>  colTitulo;
    @FXML private TableColumn<Curso,String>  colCategoria;
    @FXML private TableColumn<Curso,String>  colInstructor;
    @FXML private TableColumn<Curso,String>  colPrecio;
    @FXML private TableColumn<Curso,String>  colEstado;
    @FXML private TableColumn<Curso,String>  colFecha;
    @FXML private TableColumn<Curso,Void>    colAcciones;

    
    @FXML private TextField   txtBuscar;
    @FXML private ComboBox<String> cmbEstadoFiltro;
    @FXML private Label       lblConteo;

    
    @FXML private TitledPane  panelModulos;
    @FXML private Label       lblCursoSeleccionado;
    @FXML private Button      btnAddModulo;
    @FXML private TableView<Modulo>     tablaModulos;
    @FXML private TableColumn<Modulo,Integer> colModId;
    @FXML private TableColumn<Modulo,Integer> colModOrden;
    @FXML private TableColumn<Modulo,String>  colModTitulo;
    @FXML private TableColumn<Modulo,Void>    colModAcciones;

    
    private final CursoDAO    cursoDAO    = new CursoDAO();
    private final ModuloDAO   moduloDAO   = new ModuloDAO();
    private final UsuarioDAO  usuarioDAO  = new UsuarioDAO();

    private ObservableList<Curso>  cursosData   = FXCollections.observableArrayList();
    private ObservableList<Modulo> modulosData  = FXCollections.observableArrayList();
    private Curso cursoSeleccionado = null;

    
    
    

    @FXML
    public void initialize() {
        configurarColumnasCursos();
        configurarColumnasModulos();
        configurarFiltros();
        cargarCursos();

        
        tablaCursos.getSelectionModel().selectedItemProperty().addListener(
            (obs, old, nuevo) -> {
                cursoSeleccionado = nuevo;
                if (nuevo != null) {
                    lblCursoSeleccionado.setText(nuevo.getTitulo());
                    btnAddModulo.setDisable(false);
                    cargarModulos(nuevo.getIdCurso());
                }
            }
        );
    }

    
    
    

    private void configurarColumnasCursos() {
        colId.setCellValueFactory(new PropertyValueFactory<>("idCurso"));
        colTitulo.setCellValueFactory(new PropertyValueFactory<>("titulo"));
        colCategoria.setCellValueFactory(new PropertyValueFactory<>("categoria"));
        colInstructor.setCellValueFactory(new PropertyValueFactory<>("nombreInstructor"));
        colPrecio.setCellValueFactory(c ->
            new SimpleStringProperty(c.getValue().getPrecioTexto()));
        colEstado.setCellValueFactory(new PropertyValueFactory<>("estado"));
        colFecha.setCellValueFactory(c -> {
            var f = c.getValue().getFechaCreacion();
            return new SimpleStringProperty(f != null ? f.toString() : "");
        });

        
        colEstado.setCellFactory(col -> new TableCell<>() {
            @Override protected void updateItem(String estado, boolean empty) {
                super.updateItem(estado, empty);
                if (empty || estado == null) { setText(null); setGraphic(null); return; }
                Label badge = new Label(estado);
                badge.getStyleClass().add("badge");
                badge.getStyleClass().add(switch (estado) {
                    case "publicado"    -> "badge-green";
                    case "en_desarrollo"-> "badge-orange";
                    default             -> "badge-gray";
                });
                setGraphic(badge);
                setText(null);
            }
        });

        
        colAcciones.setCellFactory(col -> new TableCell<>() {
            private final Button btnEdit   = new Button("✏️");
            private final Button btnDelete = new Button("🗑️");
            {
                btnEdit.getStyleClass().add("btn-icon");
                btnDelete.getStyleClass().add("btn-icon-danger");
                btnEdit.setOnAction(e -> {
                    Curso c = getTableView().getItems().get(getIndex());
                    openEditDialog(c);
                });
                btnDelete.setOnAction(e -> {
                    Curso c = getTableView().getItems().get(getIndex());
                    deleteCurso(c);
                });
            }
            @Override protected void updateItem(Void v, boolean empty) {
                super.updateItem(v, empty);
                if (empty) { setGraphic(null); return; }
                HBox box = new HBox(6, btnEdit, btnDelete);
                box.setAlignment(javafx.geometry.Pos.CENTER);
                setGraphic(box);
            }
        });

        tablaCursos.setItems(cursosData);
    }

    private void configurarColumnasModulos() {
        colModId.setCellValueFactory(new PropertyValueFactory<>("idModulo"));
        colModOrden.setCellValueFactory(new PropertyValueFactory<>("orden"));
        colModTitulo.setCellValueFactory(new PropertyValueFactory<>("titulo"));

        colModAcciones.setCellFactory(col -> new TableCell<>() {
            private final Button btnEdit   = new Button("✏️");
            private final Button btnDelete = new Button("🗑️");
            {
                btnEdit.getStyleClass().add("btn-icon");
                btnDelete.getStyleClass().add("btn-icon-danger");
                btnEdit.setOnAction(e -> {
                    Modulo m = getTableView().getItems().get(getIndex());
                    openModuloEditDialog(m);
                });
                btnDelete.setOnAction(e -> {
                    Modulo m = getTableView().getItems().get(getIndex());
                    deleteModulo(m);
                });
            }
            @Override protected void updateItem(Void v, boolean empty) {
                super.updateItem(v, empty);
                if (empty) { setGraphic(null); return; }
                HBox box = new HBox(6, btnEdit, btnDelete);
                box.setAlignment(javafx.geometry.Pos.CENTER);
                setGraphic(box);
            }
        });

        tablaModulos.setItems(modulosData);
    }

    private void configurarFiltros() {
        cmbEstadoFiltro.setItems(FXCollections.observableArrayList(
            "Todos", "publicado", "en_desarrollo", "archivado"
        ));
        cmbEstadoFiltro.setValue("Todos");
    }

    
    
    

    private void cargarCursos() {
        try {
            String filtro = txtBuscar.getText();
            List<Curso> todos;
            if (filtro != null && !filtro.isBlank()) {
                todos = cursoDAO.findByTituloOrCategoria(filtro);
            } else {
                todos = cursoDAO.findAll();
            }
            
            String estado = cmbEstadoFiltro.getValue();
            if (estado != null && !estado.equals("Todos")) {
                todos = todos.stream()
                    .filter(c -> estado.equals(c.getEstado()))
                    .toList();
            }
            cursosData.setAll(todos);
            lblConteo.setText(todos.size() + " registro(s)");
        } catch (SQLException e) {
            AlertUtil.showError("Error de base de datos", e.getMessage());
        }
    }

    private void cargarModulos(int idCurso) {
        try {
            modulosData.setAll(moduloDAO.findByCurso(idCurso));
        } catch (SQLException e) {
            AlertUtil.showError("Error", e.getMessage());
        }
    }

    
    
    

    @FXML public void onBuscar() { cargarCursos(); }

    @FXML public void onLimpiar() {
        txtBuscar.clear();
        cmbEstadoFiltro.setValue("Todos");
        cargarCursos();
    }

    
    
    

    @FXML public void openCreateDialog() { showCursoDialog(null); }

    private void openEditDialog(Curso curso) { showCursoDialog(curso); }

    private void showCursoDialog(Curso cursoExistente) {
        boolean isEdit = (cursoExistente != null);
        Dialog<ButtonType> dialog = new Dialog<>();
        dialog.setTitle(isEdit ? "Editar Curso" : "Nuevo Curso");

        
        List<Instructor> instructores;
        try {
            instructores = usuarioDAO.findAllInstructores();
        } catch (SQLException e) {
            AlertUtil.showError("Error", "No se pudieron cargar los instructores: " + e.getMessage());
            return;
        }

        
        GridPane grid = new GridPane();
        grid.setHgap(12); grid.setVgap(10);
        grid.setPadding(new Insets(16));

        TextField   fTitulo    = new TextField();
        TextField   fCategoria = new TextField();
        TextField   fPrecio    = new TextField("0");
        TextField   fPuntaje   = new TextField("70");
        ComboBox<String> fEstado = new ComboBox<>(
            FXCollections.observableArrayList("en_desarrollo","publicado","archivado"));
        ComboBox<Instructor> fInstructor = new ComboBox<>(
            FXCollections.observableArrayList(instructores));

        fInstructor.setConverter(new StringConverter<>() {
            @Override public String toString(Instructor i) {
                return i == null ? "" : i.getNombre() + " (" + i.getEspecialidad() + ")";
            }
            @Override public Instructor fromString(String s) { return null; }
        });

        fTitulo.setPromptText("Título del curso");
        fCategoria.setPromptText("Ej: Programación, Diseño…");
        fEstado.setValue("en_desarrollo");
        fInstructor.setMaxWidth(Double.MAX_VALUE);

        if (isEdit) {
            fTitulo.setText(cursoExistente.getTitulo());
            fCategoria.setText(cursoExistente.getCategoria());
            fPrecio.setText(String.valueOf(cursoExistente.getPrecio()));
            fPuntaje.setText(String.valueOf(cursoExistente.getPuntajeMinCert()));
            fEstado.setValue(cursoExistente.getEstado());
            
            instructores.stream()
                .filter(i -> i.getIdInstructor() == cursoExistente.getIdInstructor())
                .findFirst().ifPresent(fInstructor::setValue);
        }

        grid.addRow(0, label("Título *"),    fTitulo);
        grid.addRow(1, label("Categoría"),   fCategoria);
        grid.addRow(2, label("Precio ($)"),  fPrecio);
        grid.addRow(3, label("Puntaje mín. cert."), fPuntaje);
        grid.addRow(4, label("Estado *"),    fEstado);
        grid.addRow(5, label("Instructor"),  fInstructor);
        GridPane.setHgrow(fTitulo,      Priority.ALWAYS);
        GridPane.setHgrow(fCategoria,   Priority.ALWAYS);
        GridPane.setHgrow(fInstructor,  Priority.ALWAYS);

        dialog.getDialogPane().setContent(grid);
        dialog.getDialogPane().getButtonTypes().addAll(
            isEdit ? ButtonType.APPLY : ButtonType.OK, ButtonType.CANCEL);
        dialog.getDialogPane().getStylesheets().add(
            getClass().getResource("/css/styles.css").toExternalForm());

        Optional<ButtonType> result = dialog.showAndWait();
        if (result.isEmpty() || result.get() == ButtonType.CANCEL) return;

        
        if (fTitulo.getText().isBlank()) {
            AlertUtil.showWarning("Validación", "El título es obligatorio.");
            return;
        }
        double precio, puntaje;
        try {
            precio  = Double.parseDouble(fPrecio.getText().trim());
            puntaje = Double.parseDouble(fPuntaje.getText().trim());
        } catch (NumberFormatException ex) {
            AlertUtil.showWarning("Validación", "Precio y puntaje mínimo deben ser números.");
            return;
        }

        
        try {
            Curso c = isEdit ? cursoExistente : new Curso();
            c.setTitulo(fTitulo.getText().trim());
            c.setCategoria(fCategoria.getText().trim());
            c.setPrecio(precio);
            c.setPuntajeMinCert(puntaje);
            c.setEstado(fEstado.getValue());
            Instructor inst = fInstructor.getValue();
            c.setIdInstructor(inst != null ? inst.getIdInstructor() : 0);

            if (isEdit) cursoDAO.update(c);
            else        cursoDAO.insert(c);

            cargarCursos();
            AlertUtil.showInfo("Éxito", "Curso " + (isEdit ? "actualizado" : "creado") + " correctamente.");
        } catch (SQLException e) {
            AlertUtil.showError("Error al guardar", e.getMessage());
        }
    }

    private void deleteCurso(Curso curso) {
        if (!AlertUtil.showConfirmation("Confirmar eliminación",
            "¿Eliminar el curso \"" + curso.getTitulo() + "\"?\n"
            + "Esta acción no se puede deshacer.")) return;
        try {
            cursoDAO.delete(curso.getIdCurso());
            cargarCursos();
            modulosData.clear();
            lblCursoSeleccionado.setText("— selecciona un curso arriba —");
            btnAddModulo.setDisable(true);
            AlertUtil.showInfo("Eliminado", "Curso eliminado correctamente.");
        } catch (SQLException e) {
            AlertUtil.showError("Error al eliminar", e.getMessage());
        }
    }

    
    
    

    @FXML public void openModuloDialog() { showModuloDialog(null); }

    private void openModuloEditDialog(Modulo m) { showModuloDialog(m); }

    private void showModuloDialog(Modulo existente) {
        if (cursoSeleccionado == null) return;
        boolean isEdit = (existente != null);

        Dialog<ButtonType> dialog = new Dialog<>();
        dialog.setTitle(isEdit ? "Editar Módulo" : "Nuevo Módulo");

        GridPane grid = new GridPane();
        grid.setHgap(12); grid.setVgap(10);
        grid.setPadding(new Insets(16));

        TextField fTitulo = new TextField();
        Spinner<Integer> fOrden = new Spinner<>(1, 100, 1);
        fTitulo.setPromptText("Título del módulo");

        if (isEdit) {
            fTitulo.setText(existente.getTitulo());
            fOrden.getValueFactory().setValue(existente.getOrden());
        }

        grid.addRow(0, label("Título *"), fTitulo);
        grid.addRow(1, label("Orden"),    fOrden);
        GridPane.setHgrow(fTitulo, Priority.ALWAYS);

        dialog.getDialogPane().setContent(grid);
        dialog.getDialogPane().getButtonTypes().addAll(
            isEdit ? ButtonType.APPLY : ButtonType.OK, ButtonType.CANCEL);
        dialog.getDialogPane().getStylesheets().add(
            getClass().getResource("/css/styles.css").toExternalForm());

        Optional<ButtonType> result = dialog.showAndWait();
        if (result.isEmpty() || result.get() == ButtonType.CANCEL) return;

        if (fTitulo.getText().isBlank()) {
            AlertUtil.showWarning("Validación", "El título es obligatorio.");
            return;
        }

        try {
            Modulo m = isEdit ? existente : new Modulo();
            m.setTitulo(fTitulo.getText().trim());
            m.setOrden(fOrden.getValue());
            m.setIdCurso(cursoSeleccionado.getIdCurso());

            if (isEdit) moduloDAO.update(m);
            else        moduloDAO.insert(m);

            cargarModulos(cursoSeleccionado.getIdCurso());
        } catch (SQLException e) {
            AlertUtil.showError("Error", e.getMessage());
        }
    }

    private void deleteModulo(Modulo modulo) {
        if (!AlertUtil.showConfirmation("Confirmar",
            "¿Eliminar el módulo \"" + modulo.getTitulo() + "\"?")) return;
        try {
            moduloDAO.delete(modulo.getIdModulo());
            cargarModulos(cursoSeleccionado.getIdCurso());
        } catch (SQLException e) {
            AlertUtil.showError("Error al eliminar", e.getMessage());
        }
    }

    
    
    

    private Label label(String text) {
        Label l = new Label(text);
        l.setStyle("-fx-font-weight: bold; -fx-text-fill: #374151;");
        return l;
    }
}
