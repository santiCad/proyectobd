package com.universidad.proyecto.controller;

import com.universidad.proyecto.App;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.control.Button;
import javafx.scene.layout.StackPane;

import java.io.IOException;

/**
 * Controlador de la ventana principal.
 * Gestiona la navegación entre módulos cargando los FXML en el contentArea.
 */
public class MainController {

    @FXML private StackPane contentArea;
    @FXML private Button    btnCursos;
    @FXML private Button    btnUsuarios;

    @FXML
    public void initialize() {
        // Cargar el módulo de cursos por defecto
        showCursos();
    }

    @FXML
    public void showCursos() {
        loadView("/fxml/CursosView.fxml");
        setActiveButton(btnCursos);
    }

    @FXML
    public void showUsuarios() {
        loadView("/fxml/UsuariosView.fxml");
        setActiveButton(btnUsuarios);
    }

    // ──────────────────────────────────────────────
    // Helpers
    // ──────────────────────────────────────────────

    private void loadView(String fxmlPath) {
        try {
            FXMLLoader loader = new FXMLLoader(
                App.class.getResource(fxmlPath)
            );
            Node view = loader.load();
            contentArea.getChildren().setAll(view);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void setActiveButton(Button active) {
        btnCursos.getStyleClass().remove("nav-btn-active");
        btnUsuarios.getStyleClass().remove("nav-btn-active");
        active.getStyleClass().add("nav-btn-active");
    }
}
