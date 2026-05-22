package com.universidad.proyecto.dao;

import com.universidad.proyecto.model.Modulo;
import com.universidad.proyecto.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para operaciones CRUD sobre la tabla MODULO.
 */
public class ModuloDAO {

    public List<Modulo> findByCurso(int idCurso) throws SQLException {
        String sql = """
                SELECT m.ID_MODULO, m.TITULO, m.ORDEN, m.ID_CURSO,
                       c.TITULO AS TITULO_CURSO
                  FROM MODULO m
                  JOIN CURSO c ON m.ID_CURSO = c.ID_CURSO
                 WHERE m.ID_CURSO = ?
                 ORDER BY m.ORDEN
                """;
        List<Modulo> lista = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idCurso);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapRow(rs));
            }
        }
        return lista;
    }

    public List<Modulo> findAll() throws SQLException {
        String sql = """
                SELECT m.ID_MODULO, m.TITULO, m.ORDEN, m.ID_CURSO,
                       c.TITULO AS TITULO_CURSO
                  FROM MODULO m
                  JOIN CURSO c ON m.ID_CURSO = c.ID_CURSO
                 ORDER BY c.TITULO, m.ORDEN
                """;
        List<Modulo> lista = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapRow(rs));
        }
        return lista;
    }

    public void insert(Modulo modulo) throws SQLException {
        String sql = """
                INSERT INTO MODULO (ID_MODULO, TITULO, ORDEN, ID_CURSO)
                VALUES (SEQ_MODULO.NEXTVAL, ?, ?, ?)
                """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, modulo.getTitulo());
            ps.setInt(2, modulo.getOrden());
            ps.setInt(3, modulo.getIdCurso());
            ps.executeUpdate();
        }
    }

    public void update(Modulo modulo) throws SQLException {
        String sql = "UPDATE MODULO SET TITULO = ?, ORDEN = ? WHERE ID_MODULO = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, modulo.getTitulo());
            ps.setInt(2, modulo.getOrden());
            ps.setInt(3, modulo.getIdModulo());
            ps.executeUpdate();
        }
    }

    public void delete(int idModulo) throws SQLException {
        // Verificar si tiene lecciones
        String checkSql = "SELECT COUNT(*) FROM LECCION WHERE ID_MODULO = ?";
        try (Connection conn = DatabaseConnection.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                ps.setInt(1, idModulo);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        throw new SQLException(
                            "No se puede eliminar: el módulo tiene lecciones asociadas.");
                    }
                }
            }
            try (PreparedStatement ps = conn.prepareStatement(
                    "DELETE FROM MODULO WHERE ID_MODULO = ?")) {
                ps.setInt(1, idModulo);
                ps.executeUpdate();
            }
        }
    }

    private Modulo mapRow(ResultSet rs) throws SQLException {
        Modulo m = new Modulo();
        m.setIdModulo(rs.getInt("ID_MODULO"));
        m.setTitulo(rs.getString("TITULO"));
        m.setOrden(rs.getInt("ORDEN"));
        m.setIdCurso(rs.getInt("ID_CURSO"));
        m.setTituloCurso(rs.getString("TITULO_CURSO"));
        return m;
    }
}
