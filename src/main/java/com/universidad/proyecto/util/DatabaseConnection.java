package com.universidad.proyecto.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Gestiona la conexión a la base de datos Oracle.
 * Lee los parámetros de conexión desde database.properties.
 */
public class DatabaseConnection {

    private static final String PROPERTIES_FILE = "/config/database.properties";
    private static String url;
    private static String user;
    private static String password;

    static {
        loadProperties();
    }

    private static void loadProperties() {
        try (InputStream input = DatabaseConnection.class.getResourceAsStream(PROPERTIES_FILE)) {
            if (input == null) {
                throw new RuntimeException("No se encontró el archivo: " + PROPERTIES_FILE);
            }
            Properties props = new Properties();
            props.load(input);
            url      = props.getProperty("db.url");
            user     = props.getProperty("db.user");
            password = props.getProperty("db.password");
        } catch (IOException e) {
            throw new RuntimeException("Error al cargar database.properties: " + e.getMessage(), e);
        }
    }

    /**
     * Obtiene una nueva conexión a Oracle.
     *
     * @return Connection activa
     * @throws SQLException si la conexión falla
     */
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("oracle.jdbc.OracleDriver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver Oracle JDBC no encontrado. "
                + "Asegúrate de tener ojdbc11 en las dependencias.", e);
        }
        return DriverManager.getConnection(url, user, password);
    }

    /**
     * Verifica si la conexión es posible.
     *
     * @return true si conecta correctamente
     */
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            return false;
        }
    }

    /**
     * Cierra un Connection de forma segura (sin lanzar excepción).
     */
    public static void closeQuietly(Connection conn) {
        if (conn != null) {
            try { conn.close(); } catch (SQLException ignored) {}
        }
    }
}
