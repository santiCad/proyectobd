package com.universidad.proyecto.dao;

import com.universidad.proyecto.model.Evaluacion;
import com.universidad.proyecto.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EvaluacionDAO {

    // ---------------------------------------------------------------
    // CONSULTAS
    // ---------------------------------------------------------------

    public List<Evaluacion> findAll() throws SQLException {
        String sql = """
                SELECT e.ID_EVAL, e.TITULO, e.TIPO, e.PUNTAJE_MIN,
                       e.TIEMPO_LIMITE_MIN, e.ID_CURSO,
                       c.TITULO AS TITULO_CURSO
                  FROM EVALUACION e
                  JOIN CURSO c ON c.ID_CURSO = e.ID_CURSO
                 ORDER BY c.TITULO, e.TIPO, e.TITULO
                """;
        List<Evaluacion> lista = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapRow(rs));
        }
        return lista;
    }

    public List<Evaluacion> findByCurso(int idCurso) throws SQLException {
        String sql = """
                SELECT e.ID_EVAL, e.TITULO, e.TIPO, e.PUNTAJE_MIN,
                       e.TIEMPO_LIMITE_MIN, e.ID_CURSO,
                       c.TITULO AS TITULO_CURSO
                  FROM EVALUACION e
                  JOIN CURSO c ON c.ID_CURSO = e.ID_CURSO
                 WHERE e.ID_CURSO = ?
                 ORDER BY e.TIPO, e.TITULO
                """;
        List<Evaluacion> lista = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idCurso);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapRow(rs));
            }
        }
        return lista;
    }

    public List<Evaluacion> findByFiltro(String titulo, int idCurso) throws SQLException {
        StringBuilder sb = new StringBuilder("""
                SELECT e.ID_EVAL, e.TITULO, e.TIPO, e.PUNTAJE_MIN,
                       e.TIEMPO_LIMITE_MIN, e.ID_CURSO,
                       c.TITULO AS TITULO_CURSO
                  FROM EVALUACION e
                  JOIN CURSO c ON c.ID_CURSO = e.ID_CURSO
                 WHERE 1=1
                """);
        List<Object> params = new ArrayList<>();

        if (titulo != null && !titulo.isBlank()) {
            sb.append(" AND UPPER(e.TITULO) LIKE UPPER(?)");
            params.add("%" + titulo + "%");
        }
        if (idCurso > 0) {
            sb.append(" AND e.ID_CURSO = ?");
            params.add(idCurso);
        }
        sb.append(" ORDER BY c.TITULO, e.TITULO");

        List<Evaluacion> lista = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sb.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapRow(rs));
            }
        }
        return lista;
    }

    // ---------------------------------------------------------------
    // INSERT / UPDATE / DELETE
    // ---------------------------------------------------------------

    public void insert(Evaluacion eval) throws SQLException {
        String sql = """
                INSERT INTO EVALUACION
                    (ID_EVAL, TITULO, TIPO, PUNTAJE_MIN, TIEMPO_LIMITE_MIN, ID_CURSO)
                VALUES (SEQ_EVALUACION.NEXTVAL, ?, ?, ?, ?, ?)
                """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, eval.getTitulo());
            ps.setString(2, eval.getTipo());
            ps.setDouble(3, eval.getPuntajeMin());
            if (eval.getTiempoLimiteMin() != null) {
                ps.setInt(4, eval.getTiempoLimiteMin());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            ps.setInt(5, eval.getIdCurso());
            ps.executeUpdate();
        }
    }

    public void update(Evaluacion eval) throws SQLException {
        String sql = """
                UPDATE EVALUACION
                   SET TITULO           = ?,
                       TIPO             = ?,
                       PUNTAJE_MIN      = ?,
                       TIEMPO_LIMITE_MIN = ?
                 WHERE ID_EVAL = ?
                """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, eval.getTitulo());
            ps.setString(2, eval.getTipo());
            ps.setDouble(3, eval.getPuntajeMin());
            if (eval.getTiempoLimiteMin() != null) {
                ps.setInt(4, eval.getTiempoLimiteMin());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            ps.setInt(5, eval.getIdEval());
            ps.executeUpdate();
        }
    }

    public void delete(int idEval) throws SQLException {
        String checkSql = "SELECT COUNT(*) FROM RESULTADO_EVALUACION WHERE ID_EVAL = ?";
        try (Connection conn = DatabaseConnection.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                ps.setInt(1, idEval);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        throw new SQLException(
                            "No se puede eliminar: la evaluación tiene resultados registrados.");
                    }
                }
            }
            try (PreparedStatement ps = conn.prepareStatement(
                    "DELETE FROM EVALUACION WHERE ID_EVAL = ?")) {
                ps.setInt(1, idEval);
                ps.executeUpdate();
            }
        }
    }

    // ---------------------------------------------------------------
    // MAPPER
    // ---------------------------------------------------------------

    private Evaluacion mapRow(ResultSet rs) throws SQLException {
        Evaluacion e = new Evaluacion();
        e.setIdEval(rs.getInt("ID_EVAL"));
        e.setTitulo(rs.getString("TITULO"));
        e.setTipo(rs.getString("TIPO"));
        e.setPuntajeMin(rs.getDouble("PUNTAJE_MIN"));
        int tiempo = rs.getInt("TIEMPO_LIMITE_MIN");
        e.setTiempoLimiteMin(rs.wasNull() ? null : tiempo);
        e.setIdCurso(rs.getInt("ID_CURSO"));
        e.setTituloCurso(rs.getString("TITULO_CURSO"));
        return e;
    }
}
