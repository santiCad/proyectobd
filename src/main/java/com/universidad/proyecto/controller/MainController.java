package com.universidad.proyecto.controller;

import com.universidad.proyecto.App;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.control.Button;
import javafx.scene.layout.StackPane;

import java.io.IOException;

public class MainController {

    @FXML private StackPane contentArea;
    @FXML private Button    btnCursos;
    @FXML private Button    btnUsuarios;
    @FXML private Button    btnInscripciones;
    @FXML private Button    btnEvaluaciones;

    @FXML
    public void initialize() {
        showCursos();
    }

    @FXML public void showCursos()        { loadView("/fxml/CursosView.fxml");        setActiveButton(btnCursos); }
    @FXML public void showUsuarios()      { loadView("/fxml/UsuariosView.fxml");      setActiveButton(btnUsuarios); }
    @FXML public void showInscripciones() { loadView("/fxml/InscripcionesView.fxml"); setActiveButton(btnInscripciones); }
    @FXML public void showEvaluaciones()  { loadView("/fxml/EvaluacionesView.fxml");  setActiveButton(btnEvaluaciones); }

    private void loadView(String fxmlPath) {
        try {
            FXMLLoader loader = new FXMLLoader(App.class.getResource(fxmlPath));
            Node view = loader.load();
            contentArea.getChildren().setAll(view);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void setActiveButton(Button active) {
        btnCursos.getStyleClass().remove("nav-btn-active");
        btnUsuarios.getStyleClass().remove("nav-btn-active");
        btnInscripciones.getStyleClass().remove("nav-btn-active");
        btnEvaluaciones.getStyleClass().remove("nav-btn-active");
        active.getStyleClass().add("nav-btn-active");
    }
}
