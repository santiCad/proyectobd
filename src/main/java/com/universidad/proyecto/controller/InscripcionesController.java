package com.universidad.proyecto.controller;

import com.universidad.proyecto.dao.CursoDAO;
import com.universidad.proyecto.dao.InscripcionDAO;
import com.universidad.proyecto.dao.UsuarioDAO;
import com.universidad.proyecto.model.*;
import com.universidad.proyecto.util.AlertUtil;
import javafx.beans.property.SimpleStringProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.control.*;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.*;
import javafx.util.StringConverter;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public class InscripcionesController {

    // ---------------------------------------------------------------
    // FXML — Tabla principal de inscripciones
    // ---------------------------------------------------------------
    @FXML private TableView<Inscripcion>           tablaInscripciones;
    @FXML private TableColumn<Inscripcion, Integer> colId;
    @FXML private TableColumn<Inscripcion, String>  colEstudiante;
    @FXML private TableColumn<Inscripcion, String>  colCurso;
    @FXML private TableColumn<Inscripcion, String>  colFecha;
    @FXML private TableColumn<Inscripcion, String>  colProgreso;
    @FXML private TableColumn<Inscripcion, String>  colEstado;
    @FXML private TableColumn<Inscripcion, Void>    colAcciones;

    // ---------------------------------------------------------------
    // FXML — Barra de búsqueda
    // ---------------------------------------------------------------
    @FXML private TextField        txtBuscarEstudiante;
    @FXML private TextField        txtBuscarCurso;
    @FXML private ComboBox<String> cmbEstado;
    @FXML private Label            lblConteo;

    // ---------------------------------------------------------------
    // FXML — Panel de progreso de lecciones
    // ---------------------------------------------------------------
    @FXML private TitledPane                        panelProgreso;
    @FXML private Label                             lblInscripcionSeleccionada;
    @FXML private Button                            btnMarcarCompletada;
    @FXML private TableView<ProgresoLeccion>        tablaProgreso;
    @FXML private TableColumn<ProgresoLeccion, Integer> colPrgOrden;
    @FXML private TableColumn<ProgresoLeccion, String>  colPrgLeccion;
    @FXML private TableColumn<ProgresoLeccion, String>  colPrgTipo;
    @FXML private TableColumn<ProgresoLeccion, String>  colPrgOblig;
    @FXML private TableColumn<ProgresoLeccion, String>  colPrgEstado;
    @FXML private TableColumn<ProgresoLeccion, String>  colPrgFechaComp;

    // ---------------------------------------------------------------
    // FXML — Panel de resumen
    // ---------------------------------------------------------------
    @FXML private Label lblTotalActivos;
    @FXML private Label lblTotalCompletados;
    @FXML private Label lblTotalAbandonados;

    // ---------------------------------------------------------------
    // DAO y estado
    // ---------------------------------------------------------------
    private final InscripcionDAO inscripcionDAO = new InscripcionDAO();
    private final CursoDAO       cursoDAO       = new CursoDAO();
    private final UsuarioDAO     usuarioDAO     = new UsuarioDAO();

    private ObservableList<Inscripcion>    inscripcionesData = FXCollections.observableArrayList();
    private ObservableList<ProgresoLeccion> progresoData      = FXCollections.observableArrayList();
    private Inscripcion inscripcionSeleccionada = null;

    // ---------------------------------------------------------------
    // INICIALIZACIÓN
    // ---------------------------------------------------------------

    @FXML
    public void initialize() {
        configurarColumnasInscripciones();
        configurarColumnasProgreso();
        configurarFiltros();
        cargarInscripciones();

        tablaInscripciones.getSelectionModel().selectedItemProperty().addListener(
            (obs, old, nuevo) -> {
                inscripcionSeleccionada = nuevo;
                if (nuevo != null) {
                    lblInscripcionSeleccionada.setText(
                        nuevo.getNombreEstudiante() + "  →  " + nuevo.getTituloCurso());
                    btnMarcarCompletada.setDisable(false);
                    cargarProgreso(nuevo.getIdUsuario(), nuevo.getIdCurso());
                }
            }
        );
    }

    // ---------------------------------------------------------------
    // CONFIGURACIÓN DE COLUMNAS — Inscripciones
    // ---------------------------------------------------------------

    private void configurarColumnasInscripciones() {
        colId.setCellValueFactory(new PropertyValueFactory<>("idInscripcion"));
        colEstudiante.setCellValueFactory(new PropertyValueFactory<>("nombreEstudiante"));
        colCurso.setCellValueFactory(new PropertyValueFactory<>("tituloCurso"));

        colFecha.setCellValueFactory(c -> {
            var f = c.getValue().getFechaMatric();
            return new SimpleStringProperty(f != null ? f.toString() : "");
        });

        colProgreso.setCellValueFactory(c ->
            new SimpleStringProperty(c.getValue().getProgresoPctTexto()));
        colProgreso.setCellFactory(col -> new TableCell<>() {
            @Override protected void updateItem(String val, boolean empty) {
                super.updateItem(val, empty);
                if (empty || val == null) { setText(null); setGraphic(null); return; }
                Inscripcion ins = getTableView().getItems().get(getIndex());
                ProgressBar bar = new ProgressBar(ins.getProgresoPct() / 100.0);
                bar.setPrefWidth(90);
                bar.setMaxWidth(Double.MAX_VALUE);
                Label lbl = new Label(val);
                lbl.setStyle("-fx-font-size: 11px; -fx-text-fill: #374151;");
                HBox box = new HBox(6, bar, lbl);
                box.setAlignment(Pos.CENTER_LEFT);
                setGraphic(box);
                setText(null);
            }
        });

        colEstado.setCellValueFactory(new PropertyValueFactory<>("estado"));
        colEstado.setCellFactory(col -> new TableCell<>() {
            @Override protected void updateItem(String estado, boolean empty) {
                super.updateItem(estado, empty);
                if (empty || estado == null) { setText(null); setGraphic(null); return; }
                Label badge = new Label(estado);
                badge.getStyleClass().add("badge");
                badge.getStyleClass().add(switch (estado) {
                    case "activo"     -> "badge-green";
                    case "completado" -> "badge-orange";
                    default           -> "badge-gray";   // abandonado
                });
                setGraphic(badge);
                setText(null);
            }
        });

        colAcciones.setCellFactory(col -> new TableCell<>() {
            private final Button btnCancelar = new Button("🚫");
            {
                btnCancelar.getStyleClass().add("btn-icon-danger");
                btnCancelar.setTooltip(new Tooltip("Cancelar inscripción"));
                btnCancelar.setOnAction(e -> {
                    Inscripcion ins = getTableView().getItems().get(getIndex());
                    cancelarInscripcion(ins);
                });
            }
            @Override protected void updateItem(Void v, boolean empty) {
                super.updateItem(v, empty);
                if (empty) { setGraphic(null); return; }
                Inscripcion ins = getTableView().getItems().get(getIndex());
                btnCancelar.setDisable("abandonado".equals(ins.getEstado())
                                    || "completado".equals(ins.getEstado()));
                HBox box = new HBox(btnCancelar);
                box.setAlignment(Pos.CENTER);
                setGraphic(box);
            }
        });

        tablaInscripciones.setItems(inscripcionesData);
    }

    // ---------------------------------------------------------------
    // CONFIGURACIÓN DE COLUMNAS — Progreso de lecciones
    // ---------------------------------------------------------------

    private void configurarColumnasProgreso() {
        colPrgOrden.setCellValueFactory(new PropertyValueFactory<>("orden"));
        colPrgLeccion.setCellValueFactory(new PropertyValueFactory<>("tituloLeccion"));
        colPrgTipo.setCellValueFactory(new PropertyValueFactory<>("tipoContenido"));
        colPrgOblig.setCellValueFactory(c ->
            new SimpleStringProperty(c.getValue().getObligatoriaTexto()));

        colPrgEstado.setCellValueFactory(c ->
            new SimpleStringProperty(c.getValue().getCompletadaTexto()));
        colPrgEstado.setCellFactory(col -> new TableCell<>() {
            @Override protected void updateItem(String val, boolean empty) {
                super.updateItem(val, empty);
                if (empty || val == null) { setText(null); setGraphic(null); return; }
                ProgresoLeccion pl = getTableView().getItems().get(getIndex());
                Label badge = new Label(val);
                badge.getStyleClass().add("badge");
                badge.getStyleClass().add(pl.getCompletada() == 1 ? "badge-green" : "badge-gray");
                setGraphic(badge);
                setText(null);
            }
        });

        colPrgFechaComp.setCellValueFactory(c -> {
            var f = c.getValue().getFechaCompletado();
            return new SimpleStringProperty(f != null ? f.toString() : "—");
        });

        tablaProgreso.setItems(progresoData);
    }

    private void configurarFiltros() {
        cmbEstado.setItems(FXCollections.observableArrayList(
            "Todos", "activo", "completado", "abandonado"
        ));
        cmbEstado.setValue("Todos");
    }

    // ---------------------------------------------------------------
    // CARGA DE DATOS
    // ---------------------------------------------------------------

    private void cargarInscripciones() {
        try {
            String est  = txtBuscarEstudiante.getText();
            String cur  = txtBuscarCurso.getText();
            String stat = cmbEstado.getValue();

            List<Inscripcion> lista;
            if ((est == null || est.isBlank()) && (cur == null || cur.isBlank())
                    && (stat == null || stat.equals("Todos"))) {
                lista = inscripcionDAO.findAll();
            } else {
                lista = inscripcionDAO.findByFiltro(est, cur, stat);
            }

            inscripcionesData.setAll(lista);
            lblConteo.setText(lista.size() + " inscripción(es)");
            actualizarResumen();
        } catch (SQLException e) {
            AlertUtil.showError("Error al cargar inscripciones", e.getMessage());
        }
    }

    private void cargarProgreso(int idUsuario, int idCurso) {
        try {
            List<ProgresoLeccion> lista =
                inscripcionDAO.findProgresoByInscripcion(idUsuario, idCurso);
            progresoData.setAll(lista);
            panelProgreso.setExpanded(true);
        } catch (SQLException e) {
            AlertUtil.showError("Error al cargar progreso", e.getMessage());
        }
    }

    private void actualizarResumen() {
        try {
            List<Object[]> stats = inscripcionDAO.countByEstado();
            int activos = 0, completados = 0, abandonados = 0;
            for (Object[] row : stats) {
                String e = (String) row[0];
                int    n = (int)    row[1];
                switch (e) {
                    case "activo"     -> activos     = n;
                    case "completado" -> completados = n;
                    case "abandonado" -> abandonados = n;
                }
            }
            lblTotalActivos.setText("Activos: " + activos);
            lblTotalCompletados.setText("Completados: " + completados);
            lblTotalAbandonados.setText("Abandonados: " + abandonados);
        } catch (SQLException e) {
            // stats no críticas
        }
    }

    // ---------------------------------------------------------------
    // ACCIONES DE BÚSQUEDA
    // ---------------------------------------------------------------

    @FXML public void onBuscar()  { cargarInscripciones(); }

    @FXML public void onLimpiar() {
        txtBuscarEstudiante.clear();
        txtBuscarCurso.clear();
        cmbEstado.setValue("Todos");
        cargarInscripciones();
    }

    // ---------------------------------------------------------------
    // INSCRIBIR ESTUDIANTE — diálogo
    // ---------------------------------------------------------------

    @FXML public void openInscribirDialog() {
        List<Usuario> estudiantes;
        List<Curso>   cursos;
        try {
            estudiantes = usuarioDAO.findByFiltro(null, "Estudiante");
            cursos      = cursoDAO.findAll();
        } catch (SQLException e) {
            AlertUtil.showError("Error", "No se pudieron cargar los datos: " + e.getMessage());
            return;
        }

        Dialog<ButtonType> dialog = new Dialog<>();
        dialog.setTitle("Inscribir Estudiante");

        GridPane grid = new GridPane();
        grid.setHgap(12); grid.setVgap(10);
        grid.setPadding(new Insets(16));

        ComboBox<Usuario> fEstudiante = new ComboBox<>(
            FXCollections.observableArrayList(estudiantes));
        ComboBox<Curso>   fCurso      = new ComboBox<>(
            FXCollections.observableArrayList(cursos));

        fEstudiante.setConverter(new StringConverter<>() {
            @Override public String toString(Usuario u) {
                return u == null ? "" : u.getNombre() + " (" + u.getNickname() + ")";
            }
            @Override public Usuario fromString(String s) { return null; }
        });
        fCurso.setConverter(new StringConverter<>() {
            @Override public String toString(Curso c) {
                return c == null ? "" : c.getTitulo() + " [" + c.getEstado() + "]";
            }
            @Override public Curso fromString(String s) { return null; }
        });

        fEstudiante.setMaxWidth(Double.MAX_VALUE);
        fCurso.setMaxWidth(Double.MAX_VALUE);

        grid.addRow(0, label("Estudiante *"), fEstudiante);
        grid.addRow(1, label("Curso *"),      fCurso);
        GridPane.setHgrow(fEstudiante, Priority.ALWAYS);
        GridPane.setHgrow(fCurso,      Priority.ALWAYS);

        dialog.getDialogPane().setContent(grid);
        dialog.getDialogPane().getButtonTypes().addAll(ButtonType.OK, ButtonType.CANCEL);
        dialog.getDialogPane().getStylesheets().add(
            getClass().getResource("/css/styles.css").toExternalForm());

        Optional<ButtonType> result = dialog.showAndWait();
        if (result.isEmpty() || result.get() == ButtonType.CANCEL) return;

        if (fEstudiante.getValue() == null || fCurso.getValue() == null) {
            AlertUtil.showWarning("Validación", "Debes seleccionar un estudiante y un curso.");
            return;
        }

        try {
            String msg = inscripcionDAO.inscribirEstudiante(
                fEstudiante.getValue().getIdUsuario(),
                fCurso.getValue().getIdCurso());

            if (msg.startsWith("OK")) {
                cargarInscripciones();
                AlertUtil.showInfo("Inscripción exitosa", msg);
            } else {
                AlertUtil.showWarning("Resultado", msg);
            }
        } catch (SQLException e) {
            AlertUtil.showError("Error al inscribir", e.getMessage());
        }
    }

    // ---------------------------------------------------------------
    // CANCELAR INSCRIPCIÓN
    // ---------------------------------------------------------------

    private void cancelarInscripcion(Inscripcion ins) {
        if (!AlertUtil.showConfirmation("Confirmar cancelación",
            "¿Cancelar la inscripción de \"" + ins.getNombreEstudiante()
            + "\" en \"" + ins.getTituloCurso() + "\"?")) return;
        try {
            inscripcionDAO.cancelar(ins.getIdInscripcion());
            cargarInscripciones();
            progresoData.clear();
            lblInscripcionSeleccionada.setText("— selecciona una inscripción arriba —");
            btnMarcarCompletada.setDisable(true);
            AlertUtil.showInfo("Cancelada", "La inscripción fue marcada como abandonada.");
        } catch (SQLException e) {
            AlertUtil.showError("Error", e.getMessage());
        }
    }

    // ---------------------------------------------------------------
    // MARCAR LECCIÓN COMO COMPLETADA
    // ---------------------------------------------------------------

    @FXML public void onMarcarCompletada() {
        ProgresoLeccion pl = tablaProgreso.getSelectionModel().getSelectedItem();
        if (pl == null) {
            AlertUtil.showWarning("Selección", "Selecciona una lección en la tabla de abajo.");
            return;
        }
        if (pl.getCompletada() == 1) {
            AlertUtil.showInfo("Ya completada", "Esta lección ya estaba marcada como completada.");
            return;
        }
        try {
            inscripcionDAO.marcarLeccionCompletada(pl.getIdUsuario(), pl.getIdLeccion());
            // Recargar progreso e inscripción (el trigger actualiza progreso_pct)
            cargarProgreso(inscripcionSeleccionada.getIdUsuario(),
                           inscripcionSeleccionada.getIdCurso());
            cargarInscripciones();
            AlertUtil.showInfo("Lección completada", "\"" + pl.getTituloLeccion()
                + "\" marcada como completada. El progreso del curso se actualizó.");
        } catch (SQLException e) {
            AlertUtil.showError("Error", e.getMessage());
        }
    }

    // ---------------------------------------------------------------
    // HELPER
    // ---------------------------------------------------------------

    private Label label(String text) {
        Label l = new Label(text);
        l.setStyle("-fx-font-weight: bold; -fx-text-fill: #374151;");
        return l;
    }
}
