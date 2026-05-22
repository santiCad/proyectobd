package com.universidad.proyecto;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;

import java.io.IOException;

/**
 * Punto de entrada principal de la aplicación
 * Sistema de Gestión de Cursos Online - Bases de Datos 2026-10
 *
 * @author Nicolas Jimenez, Johan Cadena, Jhon Mejia, Alejandro Rodriguez
 */
public class App extends Application {

    private static Stage primaryStage;

    @Override
    public void start(Stage stage) throws IOException {
        primaryStage = stage;
        showMainView();
    }

    public static void showMainView() throws IOException {
        FXMLLoader loader = new FXMLLoader(
            App.class.getResource("/fxml/MainView.fxml")
        );
        Parent root = loader.load();
        Scene scene = new Scene(root, 1200, 750);
        scene.getStylesheets().add(
            App.class.getResource("/css/styles.css").toExternalForm()
        );
        primaryStage.setTitle("Sistema de Gestión de Cursos Online");
        primaryStage.setScene(scene);
        primaryStage.setMinWidth(1000);
        primaryStage.setMinHeight(650);
        primaryStage.show();
    }

    public static Stage getPrimaryStage() {
        return primaryStage;
    }

    public static void main(String[] args) {
        launch(args);
    }
}
