package com.universidad.proyecto.dao;

import com.universidad.proyecto.model.ResultadoEvaluacion;
import com.universidad.proyecto.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ResultadoEvaluacionDAO {

    // ---------------------------------------------------------------
    // CONSULTAS
    // ---------------------------------------------------------------

    public List<ResultadoEvaluacion> findAll() throws SQLException {
        String sql = """
                SELECT re.ID_RESULTADO, re.ID_EVAL, re.ID_USUARIO,
                       re.PUNTAJE_OBTENIDO, re.FECHA_INTENTO, re.APROBADO,
                       e.TITULO  AS TITULO_EVAL,
                       u.NOMBRE  AS NOMBRE_ESTUDIANTE,
                       c.TITULO  AS TITULO_CURSO
                  FROM RESULTADO_EVALUACION re
                  JOIN EVALUACION e ON e.ID_EVAL    = re.ID_EVAL
                  JOIN USUARIO    u ON u.ID_USUARIO = re.ID_USUARIO
                  JOIN CURSO      c ON c.ID_CURSO   = e.ID_CURSO
                 ORDER BY re.FECHA_INTENTO DESC
                """;
        List<ResultadoEvaluacion> lista = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapRow(rs));
        }
        return lista;
    }

    public List<ResultadoEvaluacion> findByFiltro(String nombreEstudiante,
                                                  int idEval) throws SQLException {
        StringBuilder sb = new StringBuilder("""
                SELECT re.ID_RESULTADO, re.ID_EVAL, re.ID_USUARIO,
                       re.PUNTAJE_OBTENIDO, re.FECHA_INTENTO, re.APROBADO,
                       e.TITULO  AS TITULO_EVAL,
                       u.NOMBRE  AS NOMBRE_ESTUDIANTE,
                       c.TITULO  AS TITULO_CURSO
                  FROM RESULTADO_EVALUACION re
                  JOIN EVALUACION e ON e.ID_EVAL    = re.ID_EVAL
                  JOIN USUARIO    u ON u.ID_USUARIO = re.ID_USUARIO
                  JOIN CURSO      c ON c.ID_CURSO   = e.ID_CURSO
                 WHERE 1=1
                """);
        List<Object> params = new ArrayList<>();

        if (nombreEstudiante != null && !nombreEstudiante.isBlank()) {
            sb.append(" AND UPPER(u.NOMBRE) LIKE UPPER(?)");
            params.add("%" + nombreEstudiante + "%");
        }
        if (idEval > 0) {
            sb.append(" AND re.ID_EVAL = ?");
            params.add(idEval);
        }
        sb.append(" ORDER BY re.FECHA_INTENTO DESC");

        List<ResultadoEvaluacion> lista = new ArrayList<>();
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
    // INSERT
    // ---------------------------------------------------------------

    public void insert(ResultadoEvaluacion resultado) throws SQLException {
        String sql = """
                INSERT INTO RESULTADO_EVALUACION
                    (ID_RESULTADO, ID_EVAL, ID_USUARIO,
                     PUNTAJE_OBTENIDO, FECHA_INTENTO, APROBADO)
                VALUES (SEQ_RESULTADO.NEXTVAL, ?, ?, ?, SYSDATE, ?)
                """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, resultado.getIdEval());
            ps.setInt(2, resultado.getIdUsuario());
            ps.setDouble(3, resultado.getPuntajeObtenido());
            ps.setInt(4, resultado.getAprobado());
            ps.executeUpdate();
        }
    }

    // ---------------------------------------------------------------
    // MAPPER
    // ---------------------------------------------------------------

    private ResultadoEvaluacion mapRow(ResultSet rs) throws SQLException {
        ResultadoEvaluacion r = new ResultadoEvaluacion();
        r.setIdResultado(rs.getInt("ID_RESULTADO"));
        r.setIdEval(rs.getInt("ID_EVAL"));
        r.setIdUsuario(rs.getInt("ID_USUARIO"));
        r.setPuntajeObtenido(rs.getDouble("PUNTAJE_OBTENIDO"));
        Date d = rs.getDate("FECHA_INTENTO");
        if (d != null) r.setFechaIntento(d.toLocalDate());
        r.setAprobado(rs.getInt("APROBADO"));
        r.setTituloEval(rs.getString("TITULO_EVAL"));
        r.setNombreEstudiante(rs.getString("NOMBRE_ESTUDIANTE"));
        r.setTituloCurso(rs.getString("TITULO_CURSO"));
        return r;
    }
}
