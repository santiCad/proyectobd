package com.universidad.proyecto.controller;

import com.universidad.proyecto.dao.*;
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

public class EvaluacionesController {

    // ---------------------------------------------------------------
    // FXML — Tab Evaluaciones
    // ---------------------------------------------------------------
    @FXML private TableView<Evaluacion>           tablaEvaluaciones;
    @FXML private TableColumn<Evaluacion, Integer> colEvalId;
    @FXML private TableColumn<Evaluacion, String>  colEvalTitulo;
    @FXML private TableColumn<Evaluacion, String>  colEvalTipo;
    @FXML private TableColumn<Evaluacion, String>  colEvalPuntaje;
    @FXML private TableColumn<Evaluacion, String>  colEvalTiempo;
    @FXML private TableColumn<Evaluacion, String>  colEvalCurso;
    @FXML private TableColumn<Evaluacion, Void>    colEvalAcciones;

    @FXML private TextField        txtBuscarEval;
    @FXML private ComboBox<Curso>  cmbCursoFiltroEval;
    @FXML private Label            lblConteoEval;

    // ---------------------------------------------------------------
    // FXML — Tab Resultados
    // ---------------------------------------------------------------
    @FXML private TableView<ResultadoEvaluacion>           tablaResultados;
    @FXML private TableColumn<ResultadoEvaluacion, Integer> colResId;
    @FXML private TableColumn<ResultadoEvaluacion, String>  colResEstudiante;
    @FXML private TableColumn<ResultadoEvaluacion, String>  colResEval;
    @FXML private TableColumn<ResultadoEvaluacion, String>  colResCurso;
    @FXML private TableColumn<ResultadoEvaluacion, String>  colResPuntaje;
    @FXML private TableColumn<ResultadoEvaluacion, String>  colResFecha;
    @FXML private TableColumn<ResultadoEvaluacion, String>  colResAprobado;

    @FXML private TextField           txtBuscarRes;
    @FXML private ComboBox<Evaluacion> cmbEvalFiltroRes;
    @FXML private Label                lblConteoRes;

    // ---------------------------------------------------------------
    // FXML — Tab Certificados
    // ---------------------------------------------------------------
    @FXML private TableView<Certificado>           tablaCertificados;
    @FXML private TableColumn<Certificado, Integer> colCertId;
    @FXML private TableColumn<Certificado, String>  colCertEstudiante;
    @FXML private TableColumn<Certificado, String>  colCertCurso;
    @FXML private TableColumn<Certificado, String>  colCertCodigo;
    @FXML private TableColumn<Certificado, String>  colCertFecha;
    @FXML private TableColumn<Certificado, String>  colCertUrl;

    @FXML private TextField txtBuscarCert;
    @FXML private TextField txtBuscarCertCurso;
    @FXML private Label     lblConteoCert;

    // ---------------------------------------------------------------
    // DAOs y datos
    // ---------------------------------------------------------------
    private final EvaluacionDAO          evaluacionDAO = new EvaluacionDAO();
    private final ResultadoEvaluacionDAO resultadoDAO  = new ResultadoEvaluacionDAO();
    private final CertificadoDAO         certificadoDAO= new CertificadoDAO();
    private final CursoDAO               cursoDAO      = new CursoDAO();
    private final UsuarioDAO             usuarioDAO    = new UsuarioDAO();

    private ObservableList<Evaluacion>          evaluacionesData = FXCollections.observableArrayList();
    private ObservableList<ResultadoEvaluacion> resultadosData   = FXCollections.observableArrayList();
    private ObservableList<Certificado>         certificadosData = FXCollections.observableArrayList();

    // ---------------------------------------------------------------
    // INICIALIZACIÓN
    // ---------------------------------------------------------------

    @FXML
    public void initialize() {
        configurarColumnasEvaluaciones();
        configurarColumnasResultados();
        configurarColumnasCertificados();
        configurarFiltros();
        cargarEvaluaciones();
        cargarResultados();
        cargarCertificados();
    }

    // ---------------------------------------------------------------
    // EVALUACIONES — columnas
    // ---------------------------------------------------------------

    private void configurarColumnasEvaluaciones() {
        colEvalId.setCellValueFactory(new PropertyValueFactory<>("idEval"));
        colEvalTitulo.setCellValueFactory(new PropertyValueFactory<>("titulo"));

        colEvalTipo.setCellValueFactory(new PropertyValueFactory<>("tipo"));
        colEvalTipo.setCellFactory(col -> new TableCell<>() {
            @Override protected void updateItem(String tipo, boolean empty) {
                super.updateItem(tipo, empty);
                if (empty || tipo == null) { setText(null); setGraphic(null); return; }
                Label badge = new Label(tipo);
                badge.getStyleClass().add("badge");
                badge.getStyleClass().add(switch (tipo) {
                    case "examen_final" -> "badge-orange";
                    case "quiz"         -> "badge-green";
                    default             -> "badge-gray";  // tarea
                });
                setGraphic(badge);
                setText(null);
            }
        });

        colEvalPuntaje.setCellValueFactory(c ->
            new SimpleStringProperty(c.getValue().getPuntajeMin() + " pts"));
        colEvalTiempo.setCellValueFactory(c ->
            new SimpleStringProperty(c.getValue().getTiempoTexto()));
        colEvalCurso.setCellValueFactory(new PropertyValueFactory<>("tituloCurso"));

        colEvalAcciones.setCellFactory(col -> new TableCell<>() {
            private final Button btnEdit   = new Button("✏️");
            private final Button btnDelete = new Button("🗑️");
            {
                btnEdit.getStyleClass().add("btn-icon");
                btnDelete.getStyleClass().add("btn-icon-danger");
                btnEdit.setOnAction(e -> {
                    Evaluacion ev = getTableView().getItems().get(getIndex());
                    openEvalDialog(ev);
                });
                btnDelete.setOnAction(e -> {
                    Evaluacion ev = getTableView().getItems().get(getIndex());
                    deleteEvaluacion(ev);
                });
            }
            @Override protected void updateItem(Void v, boolean empty) {
                super.updateItem(v, empty);
                if (empty) { setGraphic(null); return; }
                HBox box = new HBox(6, btnEdit, btnDelete);
                box.setAlignment(Pos.CENTER);
                setGraphic(box);
            }
        });

        tablaEvaluaciones.setItems(evaluacionesData);
    }

    // ---------------------------------------------------------------
    // RESULTADOS — columnas
    // ---------------------------------------------------------------

    private void configurarColumnasResultados() {
        colResId.setCellValueFactory(new PropertyValueFactory<>("idResultado"));
        colResEstudiante.setCellValueFactory(new PropertyValueFactory<>("nombreEstudiante"));
        colResEval.setCellValueFactory(new PropertyValueFactory<>("tituloEval"));
        colResCurso.setCellValueFactory(new PropertyValueFactory<>("tituloCurso"));
        colResPuntaje.setCellValueFactory(c ->
            new SimpleStringProperty(c.getValue().getPuntajeTexto() + " pts"));
        colResFecha.setCellValueFactory(c -> {
            var f = c.getValue().getFechaIntento();
            return new SimpleStringProperty(f != null ? f.toString() : "");
        });

        colResAprobado.setCellValueFactory(c ->
            new SimpleStringProperty(c.getValue().getAprobadoTexto()));
        colResAprobado.setCellFactory(col -> new TableCell<>() {
            @Override protected void updateItem(String val, boolean empty) {
                super.updateItem(val, empty);
                if (empty || val == null) { setText(null); setGraphic(null); return; }
                ResultadoEvaluacion r = getTableView().getItems().get(getIndex());
                Label badge = new Label(val);
                badge.getStyleClass().add("badge");
                badge.getStyleClass().add(r.getAprobado() == 1 ? "badge-green" : "badge-gray");
                setGraphic(badge);
                setText(null);
            }
        });

        tablaResultados.setItems(resultadosData);
    }

    // ---------------------------------------------------------------
    // CERTIFICADOS — columnas
    // ---------------------------------------------------------------

    private void configurarColumnasCertificados() {
        colCertId.setCellValueFactory(new PropertyValueFactory<>("idCertificado"));
        colCertEstudiante.setCellValueFactory(new PropertyValueFactory<>("nombreEstudiante"));
        colCertCurso.setCellValueFactory(new PropertyValueFactory<>("tituloCurso"));
        colCertCodigo.setCellValueFactory(new PropertyValueFactory<>("codVerif"));
        colCertFecha.setCellValueFactory(c -> {
            var f = c.getValue().getFechaGen();
            return new SimpleStringProperty(f != null ? f.toString() : "");
        });
        colCertUrl.setCellValueFactory(new PropertyValueFactory<>("urlDescarga"));

        tablaCertificados.setItems(certificadosData);
    }

    // ---------------------------------------------------------------
    // FILTROS
    // ---------------------------------------------------------------

    private void configurarFiltros() {
        try {
            List<Curso> cursos = cursoDAO.findAll();

            // Combo cursos para filtro de evaluaciones — incluye opción vacía
            Curso todos = new Curso();
            todos.setTitulo("Todos los cursos");
            todos.setIdCurso(0);
            cursos.add(0, todos);

            cmbCursoFiltroEval.setItems(FXCollections.observableArrayList(cursos));
            cmbCursoFiltroEval.setConverter(new StringConverter<>() {
                @Override public String toString(Curso c) { return c == null ? "" : c.getTitulo(); }
                @Override public Curso fromString(String s) { return null; }
            });
            cmbCursoFiltroEval.getSelectionModel().selectFirst();

            // Combo evaluaciones para filtro de resultados
            List<Evaluacion> evals = evaluacionDAO.findAll();
            Evaluacion todasEvals = new Evaluacion();
            todasEvals.setTitulo("Todas las evaluaciones");
            todasEvals.setIdEval(0);
            evals.add(0, todasEvals);
            cmbEvalFiltroRes.setItems(FXCollections.observableArrayList(evals));
            cmbEvalFiltroRes.setConverter(new StringConverter<>() {
                @Override public String toString(Evaluacion e) { return e == null ? "" : e.getTitulo(); }
                @Override public Evaluacion fromString(String s) { return null; }
            });
            cmbEvalFiltroRes.getSelectionModel().selectFirst();

        } catch (SQLException e) {
            AlertUtil.showError("Error al cargar filtros", e.getMessage());
        }
    }

    // ---------------------------------------------------------------
    // CARGA DE DATOS
    // ---------------------------------------------------------------

    private void cargarEvaluaciones() {
        try {
            String titulo  = txtBuscarEval.getText();
            Curso  cursoSel = cmbCursoFiltroEval.getValue();
            int    idCurso = (cursoSel != null) ? cursoSel.getIdCurso() : 0;

            List<Evaluacion> lista = evaluacionDAO.findByFiltro(titulo, idCurso);
            evaluacionesData.setAll(lista);
            lblConteoEval.setText(lista.size() + " evaluación(es)");
        } catch (SQLException e) {
            AlertUtil.showError("Error al cargar evaluaciones", e.getMessage());
        }
    }

    private void cargarResultados() {
        try {
            String     nombre  = txtBuscarRes.getText();
            Evaluacion evalSel = cmbEvalFiltroRes.getValue();
            int        idEval  = (evalSel != null) ? evalSel.getIdEval() : 0;

            List<ResultadoEvaluacion> lista = resultadoDAO.findByFiltro(nombre, idEval);
            resultadosData.setAll(lista);
            lblConteoRes.setText(lista.size() + " resultado(s)");
        } catch (SQLException e) {
            AlertUtil.showError("Error al cargar resultados", e.getMessage());
        }
    }

    private void cargarCertificados() {
        try {
            List<Certificado> lista = certificadoDAO.findByFiltro(
                txtBuscarCert.getText(), txtBuscarCertCurso.getText());
            certificadosData.setAll(lista);
            lblConteoCert.setText(lista.size() + " certificado(s)");
        } catch (SQLException e) {
            AlertUtil.showError("Error al cargar certificados", e.getMessage());
        }
    }

    // ---------------------------------------------------------------
    // ACCIONES — búsqueda
    // ---------------------------------------------------------------

    @FXML public void onBuscarEval()  { cargarEvaluaciones(); }
    @FXML public void onLimpiarEval() { txtBuscarEval.clear(); cmbCursoFiltroEval.getSelectionModel().selectFirst(); cargarEvaluaciones(); }

    @FXML public void onBuscarRes()   { cargarResultados(); }
    @FXML public void onLimpiarRes()  { txtBuscarRes.clear(); cmbEvalFiltroRes.getSelectionModel().selectFirst(); cargarResultados(); }

    @FXML public void onBuscarCert()  { cargarCertificados(); }
    @FXML public void onLimpiarCert() { txtBuscarCert.clear(); txtBuscarCertCurso.clear(); cargarCertificados(); }

    // ---------------------------------------------------------------
    // EVALUACIÓN — crear / editar
    // ---------------------------------------------------------------

    @FXML public void openCreateEvalDialog() { openEvalDialog(null); }

    private void openEvalDialog(Evaluacion existente) {
        boolean isEdit = (existente != null);

        List<Curso> cursos;
        try {
            cursos = cursoDAO.findAll();
        } catch (SQLException e) {
            AlertUtil.showError("Error", "No se pudieron cargar los cursos: " + e.getMessage());
            return;
        }

        Dialog<ButtonType> dialog = new Dialog<>();
        dialog.setTitle(isEdit ? "Editar Evaluación" : "Nueva Evaluación");

        GridPane grid = new GridPane();
        grid.setHgap(12); grid.setVgap(10);
        grid.setPadding(new Insets(16));

        TextField         fTitulo  = new TextField();
        ComboBox<String>  fTipo    = new ComboBox<>(
            FXCollections.observableArrayList("quiz", "tarea", "examen_final"));
        TextField         fPuntaje = new TextField("70");
        TextField         fTiempo  = new TextField();
        ComboBox<Curso>   fCurso   = new ComboBox<>(
            FXCollections.observableArrayList(cursos));

        fTitulo.setPromptText("Nombre de la evaluación");
        fTiempo.setPromptText("Minutos (vacío = sin límite)");
        fCurso.setConverter(new StringConverter<>() {
            @Override public String toString(Curso c)    { return c == null ? "" : c.getTitulo(); }
            @Override public Curso fromString(String s)  { return null; }
        });
        fCurso.setMaxWidth(Double.MAX_VALUE);

        if (isEdit) {
            fTitulo.setText(existente.getTitulo());
            fTipo.setValue(existente.getTipo());
            fPuntaje.setText(String.valueOf(existente.getPuntajeMin()));
            if (existente.getTiempoLimiteMin() != null) {
                fTiempo.setText(String.valueOf(existente.getTiempoLimiteMin()));
            }
            cursos.stream().filter(c -> c.getIdCurso() == existente.getIdCurso())
                  .findFirst().ifPresent(fCurso::setValue);
        } else {
            fTipo.setValue("quiz");
        }

        grid.addRow(0, label("Título *"),      fTitulo);
        grid.addRow(1, label("Tipo *"),         fTipo);
        grid.addRow(2, label("Puntaje mín. *"), fPuntaje);
        grid.addRow(3, label("Tiempo (min)"),   fTiempo);
        grid.addRow(4, label("Curso *"),         fCurso);
        GridPane.setHgrow(fTitulo, Priority.ALWAYS);
        GridPane.setHgrow(fCurso,  Priority.ALWAYS);

        dialog.getDialogPane().setContent(grid);
        dialog.getDialogPane().getButtonTypes().addAll(
            isEdit ? ButtonType.APPLY : ButtonType.OK, ButtonType.CANCEL);
        dialog.getDialogPane().getStylesheets().add(
            getClass().getResource("/css/styles.css").toExternalForm());

        Optional<ButtonType> result = dialog.showAndWait();
        if (result.isEmpty() || result.get() == ButtonType.CANCEL) return;

        if (fTitulo.getText().isBlank() || fTipo.getValue() == null || fCurso.getValue() == null) {
            AlertUtil.showWarning("Validación", "Título, tipo y curso son obligatorios.");
            return;
        }

        double puntaje;
        try {
            puntaje = Double.parseDouble(fPuntaje.getText().trim());
        } catch (NumberFormatException ex) {
            AlertUtil.showWarning("Validación", "El puntaje mínimo debe ser un número.");
            return;
        }

        Integer tiempo = null;
        if (!fTiempo.getText().isBlank()) {
            try {
                tiempo = Integer.parseInt(fTiempo.getText().trim());
            } catch (NumberFormatException ex) {
                AlertUtil.showWarning("Validación", "El tiempo debe ser un número entero de minutos.");
                return;
            }
        }

        try {
            Evaluacion ev = isEdit ? existente : new Evaluacion();
            ev.setTitulo(fTitulo.getText().trim());
            ev.setTipo(fTipo.getValue());
            ev.setPuntajeMin(puntaje);
            ev.setTiempoLimiteMin(tiempo);
            ev.setIdCurso(fCurso.getValue().getIdCurso());

            if (isEdit) evaluacionDAO.update(ev);
            else        evaluacionDAO.insert(ev);

            cargarEvaluaciones();
            AlertUtil.showInfo("Éxito", "Evaluación " + (isEdit ? "actualizada" : "creada") + " correctamente.");
        } catch (SQLException e) {
            AlertUtil.showError("Error al guardar", e.getMessage());
        }
    }

    private void deleteEvaluacion(Evaluacion ev) {
        if (!AlertUtil.showConfirmation("Confirmar",
            "¿Eliminar la evaluación \"" + ev.getTitulo() + "\"?")) return;
        try {
            evaluacionDAO.delete(ev.getIdEval());
            cargarEvaluaciones();
            AlertUtil.showInfo("Eliminada", "Evaluación eliminada correctamente.");
        } catch (SQLException e) {
            AlertUtil.showError("Error al eliminar", e.getMessage());
        }
    }

    // ---------------------------------------------------------------
    // RESULTADO — registrar
    // ---------------------------------------------------------------

    @FXML public void openRegistrarResultadoDialog() {
        List<Usuario>     estudiantes;
        List<Evaluacion>  evaluaciones;
        try {
            estudiantes  = usuarioDAO.findByFiltro(null, "Estudiante");
            evaluaciones = evaluacionDAO.findAll();
        } catch (SQLException e) {
            AlertUtil.showError("Error", "No se pudieron cargar los datos: " + e.getMessage());
            return;
        }

        Dialog<ButtonType> dialog = new Dialog<>();
        dialog.setTitle("Registrar Resultado");

        GridPane grid = new GridPane();
        grid.setHgap(12); grid.setVgap(10);
        grid.setPadding(new Insets(16));

        ComboBox<Usuario>    fEstudiante = new ComboBox<>(
            FXCollections.observableArrayList(estudiantes));
        ComboBox<Evaluacion> fEval       = new ComboBox<>(
            FXCollections.observableArrayList(evaluaciones));
        TextField            fPuntaje    = new TextField();

        fEstudiante.setConverter(new StringConverter<>() {
            @Override public String toString(Usuario u) {
                return u == null ? "" : u.getNombre() + " (" + u.getNickname() + ")";
            }
            @Override public Usuario fromString(String s) { return null; }
        });
        fEval.setConverter(new StringConverter<>() {
            @Override public String toString(Evaluacion e) {
                return e == null ? "" : e.getTitulo() + " — " + e.getTituloCurso();
            }
            @Override public Evaluacion fromString(String s) { return null; }
        });

        fEstudiante.setMaxWidth(Double.MAX_VALUE);
        fEval.setMaxWidth(Double.MAX_VALUE);
        fPuntaje.setPromptText("Ej: 85.5");

        grid.addRow(0, label("Estudiante *"),  fEstudiante);
        grid.addRow(1, label("Evaluación *"),  fEval);
        grid.addRow(2, label("Puntaje *"),     fPuntaje);
        GridPane.setHgrow(fEstudiante, Priority.ALWAYS);
        GridPane.setHgrow(fEval,       Priority.ALWAYS);
        GridPane.setHgrow(fPuntaje,    Priority.ALWAYS);

        dialog.getDialogPane().setContent(grid);
        dialog.getDialogPane().getButtonTypes().addAll(ButtonType.OK, ButtonType.CANCEL);
        dialog.getDialogPane().getStylesheets().add(
            getClass().getResource("/css/styles.css").toExternalForm());

        Optional<ButtonType> result = dialog.showAndWait();
        if (result.isEmpty() || result.get() == ButtonType.CANCEL) return;

        if (fEstudiante.getValue() == null || fEval.getValue() == null
                || fPuntaje.getText().isBlank()) {
            AlertUtil.showWarning("Validación", "Todos los campos son obligatorios.");
            return;
        }

        double puntaje;
        try {
            puntaje = Double.parseDouble(fPuntaje.getText().trim());
            if (puntaje < 0 || puntaje > 100) throw new NumberFormatException();
        } catch (NumberFormatException ex) {
            AlertUtil.showWarning("Validación", "El puntaje debe ser un número entre 0 y 100.");
            return;
        }

        try {
            Evaluacion    evalSel = fEval.getValue();
            int           aprobado = puntaje >= evalSel.getPuntajeMin() ? 1 : 0;
            ResultadoEvaluacion res = new ResultadoEvaluacion();
            res.setIdEval(evalSel.getIdEval());
            res.setIdUsuario(fEstudiante.getValue().getIdUsuario());
            res.setPuntajeObtenido(puntaje);
            res.setAprobado(aprobado);

            resultadoDAO.insert(res);
            cargarResultados();
            String estadoMsg = aprobado == 1 ? "✅ Aprobado" : "❌ Reprobado";
            AlertUtil.showInfo("Resultado registrado",
                "Puntaje: " + puntaje + " / " + evalSel.getPuntajeMin()
                + " mín. → " + estadoMsg);
        } catch (SQLException e) {
            AlertUtil.showError("Error al registrar", e.getMessage());
        }
    }

    // ---------------------------------------------------------------
    // CERTIFICADO — generar
    // ---------------------------------------------------------------

    @FXML public void openGenerarCertificadoDialog() {
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
        dialog.setTitle("Generar Certificado");

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
            @Override public String toString(Curso c)   { return c == null ? "" : c.getTitulo(); }
            @Override public Curso fromString(String s) { return null; }
        });

        fEstudiante.setMaxWidth(Double.MAX_VALUE);
        fCurso.setMaxWidth(Double.MAX_VALUE);

        Label nota = new Label("⚠ El estudiante debe tener el curso completado al 100%\ny el puntaje promedio ≥ al mínimo del curso.");
        nota.setStyle("-fx-text-fill: #6b7280; -fx-font-size: 11px;");

        grid.addRow(0, label("Estudiante *"), fEstudiante);
        grid.addRow(1, label("Curso *"),      fCurso);
        grid.add(nota, 0, 2, 2, 1);
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
            String msg = certificadoDAO.generarCertificado(
                fEstudiante.getValue().getIdUsuario(),
                fCurso.getValue().getIdCurso());

            if (msg.startsWith("OK")) {
                cargarCertificados();
                AlertUtil.showInfo("Certificado generado", msg);
            } else {
                AlertUtil.showWarning("No se pudo generar", msg);
            }
        } catch (SQLException e) {
            AlertUtil.showError("Error al generar certificado", e.getMessage());
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
