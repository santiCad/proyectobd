package com.universidad.proyecto.dao;

import com.universidad.proyecto.model.Inscripcion;
import com.universidad.proyecto.model.ProgresoLeccion;
import com.universidad.proyecto.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InscripcionDAO {

    // ---------------------------------------------------------------
    // CONSULTAS
    // ---------------------------------------------------------------

    public List<Inscripcion> findAll() throws SQLException {
        String sql = """
                SELECT ins.ID_INSCRIPCION, ins.ID_USUARIO, ins.ID_CURSO,
                       ins.FECHA_MATRIC, ins.PROGRESO_PCT, ins.ESTADO,
                       u.NOMBRE  AS NOMBRE_ESTUDIANTE,
                       c.TITULO  AS TITULO_CURSO
                  FROM INSCRIPCION ins
                  JOIN USUARIO u ON u.ID_USUARIO = ins.ID_USUARIO
                  JOIN CURSO   c ON c.ID_CURSO   = ins.ID_CURSO
                 ORDER BY ins.FECHA_MATRIC DESC
                """;
        List<Inscripcion> lista = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapRow(rs));
        }
        return lista;
    }

    public List<Inscripcion> findByFiltro(String nombreEstudiante,
                                          String tituloCurso,
                                          String estado) throws SQLException {
        StringBuilder sb = new StringBuilder("""
                SELECT ins.ID_INSCRIPCION, ins.ID_USUARIO, ins.ID_CURSO,
                       ins.FECHA_MATRIC, ins.PROGRESO_PCT, ins.ESTADO,
                       u.NOMBRE  AS NOMBRE_ESTUDIANTE,
                       c.TITULO  AS TITULO_CURSO
                  FROM INSCRIPCION ins
                  JOIN USUARIO u ON u.ID_USUARIO = ins.ID_USUARIO
                  JOIN CURSO   c ON c.ID_CURSO   = ins.ID_CURSO
                 WHERE 1=1
                """);
        List<Object> params = new ArrayList<>();

        if (nombreEstudiante != null && !nombreEstudiante.isBlank()) {
            sb.append(" AND UPPER(u.NOMBRE) LIKE UPPER(?)");
            params.add("%" + nombreEstudiante + "%");
        }
        if (tituloCurso != null && !tituloCurso.isBlank()) {
            sb.append(" AND UPPER(c.TITULO) LIKE UPPER(?)");
            params.add("%" + tituloCurso + "%");
        }
        if (estado != null && !estado.equals("Todos")) {
            sb.append(" AND ins.ESTADO = ?");
            params.add(estado);
        }
        sb.append(" ORDER BY ins.FECHA_MATRIC DESC");

        List<Inscripcion> lista = new ArrayList<>();
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
    // INSCRIBIR usando el procedimiento almacenado
    // ---------------------------------------------------------------

    /** Llama al SP inscribir_estudiante y retorna su mensaje OUT. */
    public String inscribirEstudiante(int idUsuario, int idCurso) throws SQLException {
        String sql = "{ CALL inscribir_estudiante(?, ?, ?) }";
        try (Connection conn = DatabaseConnection.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {
            cs.setInt(1, idUsuario);
            cs.setInt(2, idCurso);
            cs.registerOutParameter(3, Types.VARCHAR);
            cs.execute();
            return cs.getString(3);
        }
    }

    // ---------------------------------------------------------------
    // CANCELAR (estado → abandonado)
    // ---------------------------------------------------------------

    public void cancelar(int idInscripcion) throws SQLException {
        String sql = "UPDATE INSCRIPCION SET ESTADO = 'abandonado' WHERE ID_INSCRIPCION = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idInscripcion);
            ps.executeUpdate();
        }
    }

    // ---------------------------------------------------------------
    // PROGRESO DE LECCIONES para una inscripción
    // ---------------------------------------------------------------

    public List<ProgresoLeccion> findProgresoByInscripcion(int idUsuario,
                                                           int idCurso) throws SQLException {
        String sql = """
                SELECT pl.ID_PROGRESO, pl.ID_USUARIO, pl.ID_LECCION,
                       pl.COMPLETADA, pl.FECHA_INICIO, pl.FECHA_COMPLETADO,
                       l.TITULO      AS TITULO_LECCION,
                       l.TIPO_CONTENIDO,
                       l.ORDEN,
                       l.ES_OBLIGATORIA
                  FROM PROGRESO_LECCION pl
                  JOIN LECCION l  ON l.ID_LECCION = pl.ID_LECCION
                  JOIN MODULO  m  ON m.ID_MODULO  = l.ID_MODULO
                 WHERE pl.ID_USUARIO = ?
                   AND m.ID_CURSO   = ?
                 ORDER BY m.ORDEN, l.ORDEN
                """;
        List<ProgresoLeccion> lista = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setInt(2, idCurso);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapProgresoRow(rs));
            }
        }
        return lista;
    }

    /** Marca una lección como completada; el trigger recalcula progreso_pct. */
    public void marcarLeccionCompletada(int idUsuario, int idLeccion) throws SQLException {
        String sql = """
                UPDATE PROGRESO_LECCION
                   SET COMPLETADA       = 1,
                       FECHA_COMPLETADO = SYSDATE
                 WHERE ID_USUARIO = ?
                   AND ID_LECCION = ?
                """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setInt(2, idLeccion);
            ps.executeUpdate();
        }
    }

    // ---------------------------------------------------------------
    // ESTADÍSTICAS
    // ---------------------------------------------------------------

    public List<Object[]> countByEstado() throws SQLException {
        String sql = """
                SELECT ESTADO, COUNT(*) AS TOTAL
                  FROM INSCRIPCION
                 GROUP BY ESTADO
                 ORDER BY TOTAL DESC
                """;
        List<Object[]> resultado = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                resultado.add(new Object[]{rs.getString(1), rs.getInt(2)});
            }
        }
        return resultado;
    }

    // ---------------------------------------------------------------
    // MAPPERS
    // ---------------------------------------------------------------

    private Inscripcion mapRow(ResultSet rs) throws SQLException {
        Inscripcion ins = new Inscripcion();
        ins.setIdInscripcion(rs.getInt("ID_INSCRIPCION"));
        ins.setIdUsuario(rs.getInt("ID_USUARIO"));
        ins.setIdCurso(rs.getInt("ID_CURSO"));
        Date d = rs.getDate("FECHA_MATRIC");
        if (d != null) ins.setFechaMatric(d.toLocalDate());
        ins.setProgresoPct(rs.getDouble("PROGRESO_PCT"));
        ins.setEstado(rs.getString("ESTADO"));
        ins.setNombreEstudiante(rs.getString("NOMBRE_ESTUDIANTE"));
        ins.setTituloCurso(rs.getString("TITULO_CURSO"));
        return ins;
    }

    private ProgresoLeccion mapProgresoRow(ResultSet rs) throws SQLException {
        ProgresoLeccion pl = new ProgresoLeccion();
        pl.setIdProgreso(rs.getInt("ID_PROGRESO"));
        pl.setIdUsuario(rs.getInt("ID_USUARIO"));
        pl.setIdLeccion(rs.getInt("ID_LECCION"));
        pl.setCompletada(rs.getInt("COMPLETADA"));
        Date fi = rs.getDate("FECHA_INICIO");
        if (fi != null) pl.setFechaInicio(fi.toLocalDate());
        Date fc = rs.getDate("FECHA_COMPLETADO");
        if (fc != null) pl.setFechaCompletado(fc.toLocalDate());
        pl.setTituloLeccion(rs.getString("TITULO_LECCION"));
        pl.setTipoContenido(rs.getString("TIPO_CONTENIDO"));
        pl.setOrden(rs.getInt("ORDEN"));
        pl.setEsObligatoria(rs.getInt("ES_OBLIGATORIA"));
        return pl;
    }
}
