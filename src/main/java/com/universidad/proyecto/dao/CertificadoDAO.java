package com.universidad.proyecto.dao;

import com.universidad.proyecto.model.Certificado;
import com.universidad.proyecto.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CertificadoDAO {

    // ---------------------------------------------------------------
    // CONSULTAS
    // ---------------------------------------------------------------

    public List<Certificado> findAll() throws SQLException {
        String sql = """
                SELECT ce.ID_CERTIFICADO, ce.ID_USUARIO, ce.ID_CURSO,
                       ce.COD_VERIF, ce.FECHA_GEN, ce.URL_DESCARGA,
                       u.NOMBRE AS NOMBRE_ESTUDIANTE,
                       c.TITULO AS TITULO_CURSO
                  FROM CERTIFICADO ce
                  JOIN USUARIO u ON u.ID_USUARIO = ce.ID_USUARIO
                  JOIN CURSO   c ON c.ID_CURSO   = ce.ID_CURSO
                 ORDER BY ce.FECHA_GEN DESC
                """;
        List<Certificado> lista = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapRow(rs));
        }
        return lista;
    }

    public List<Certificado> findByFiltro(String nombreEstudiante,
                                          String tituloCurso) throws SQLException {
        StringBuilder sb = new StringBuilder("""
                SELECT ce.ID_CERTIFICADO, ce.ID_USUARIO, ce.ID_CURSO,
                       ce.COD_VERIF, ce.FECHA_GEN, ce.URL_DESCARGA,
                       u.NOMBRE AS NOMBRE_ESTUDIANTE,
                       c.TITULO AS TITULO_CURSO
                  FROM CERTIFICADO ce
                  JOIN USUARIO u ON u.ID_USUARIO = ce.ID_USUARIO
                  JOIN CURSO   c ON c.ID_CURSO   = ce.ID_CURSO
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
        sb.append(" ORDER BY ce.FECHA_GEN DESC");

        List<Certificado> lista = new ArrayList<>();
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
    // GENERAR usando el procedimiento almacenado
    // ---------------------------------------------------------------

    /** Llama al SP generar_certificado y retorna su mensaje OUT. */
    public String generarCertificado(int idUsuario, int idCurso) throws SQLException {
        String sql = "{ CALL generar_certificado(?, ?, ?) }";
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
    // MAPPER
    // ---------------------------------------------------------------

    private Certificado mapRow(ResultSet rs) throws SQLException {
        Certificado ce = new Certificado();
        ce.setIdCertificado(rs.getInt("ID_CERTIFICADO"));
        ce.setIdUsuario(rs.getInt("ID_USUARIO"));
        ce.setIdCurso(rs.getInt("ID_CURSO"));
        ce.setCodVerif(rs.getString("COD_VERIF"));
        Date d = rs.getDate("FECHA_GEN");
        if (d != null) ce.setFechaGen(d.toLocalDate());
        ce.setUrlDescarga(rs.getString("URL_DESCARGA"));
        ce.setNombreEstudiante(rs.getString("NOMBRE_ESTUDIANTE"));
        ce.setTituloCurso(rs.getString("TITULO_CURSO"));
        return ce;
    }
}
