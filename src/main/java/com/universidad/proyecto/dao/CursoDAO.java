package com.universidad.proyecto.dao;

import com.universidad.proyecto.model.Curso;
import com.universidad.proyecto.util.DatabaseConnection;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class CursoDAO {

    
    
    

    public List<Curso> findAll() throws SQLException {
        String sql = """
                SELECT c.ID_CURSO, c.TITULO, c.PRECIO, c.CATEGORIA,
                       c.ESTADO, c.PUNTAJE_MIN_CERT, c.FECHA_CREACION,
                       c.ID_INSTRUCTOR,
                       u.NOMBRE AS NOMBRE_INSTRUCTOR
                  FROM CURSO c
                  LEFT JOIN INSTRUCTOR i ON c.ID_INSTRUCTOR = i.ID_INSTRUCTOR
                  LEFT JOIN USUARIO    u ON i.ID_USUARIO    = u.ID_USUARIO
                 ORDER BY c.FECHA_CREACION DESC
                """;
        List<Curso> lista = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapRow(rs));
            }
        }
        return lista;
    }

    
    
    

    public List<Curso> findByTituloOrCategoria(String filtro) throws SQLException {
        String sql = """
                SELECT c.ID_CURSO, c.TITULO, c.PRECIO, c.CATEGORIA,
                       c.ESTADO, c.PUNTAJE_MIN_CERT, c.FECHA_CREACION,
                       c.ID_INSTRUCTOR,
                       u.NOMBRE AS NOMBRE_INSTRUCTOR
                  FROM CURSO c
                  LEFT JOIN INSTRUCTOR i ON c.ID_INSTRUCTOR = i.ID_INSTRUCTOR
                  LEFT JOIN USUARIO    u ON i.ID_USUARIO    = u.ID_USUARIO
                 WHERE UPPER(c.TITULO)    LIKE UPPER(?)
                    OR UPPER(c.CATEGORIA) LIKE UPPER(?)
                 ORDER BY c.TITULO
                """;
        String like = "%" + filtro + "%";
        List<Curso> lista = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, like);
            ps.setString(2, like);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapRow(rs));
            }
        }
        return lista;
    }

    
    
    

    public Curso findById(int idCurso) throws SQLException {
        String sql = """
                SELECT c.ID_CURSO, c.TITULO, c.PRECIO, c.CATEGORIA,
                       c.ESTADO, c.PUNTAJE_MIN_CERT, c.FECHA_CREACION,
                       c.ID_INSTRUCTOR,
                       u.NOMBRE AS NOMBRE_INSTRUCTOR
                  FROM CURSO c
                  LEFT JOIN INSTRUCTOR i ON c.ID_INSTRUCTOR = i.ID_INSTRUCTOR
                  LEFT JOIN USUARIO    u ON i.ID_USUARIO    = u.ID_USUARIO
                 WHERE c.ID_CURSO = ?
                """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idCurso);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    
    
    

    public void insert(Curso curso) throws SQLException {
        String sql = """
                INSERT INTO CURSO
                    (ID_CURSO, TITULO, PRECIO, CATEGORIA, ESTADO,
                     PUNTAJE_MIN_CERT, FECHA_CREACION, ID_INSTRUCTOR)
                VALUES (SEQ_CURSO.NEXTVAL, ?, ?, ?, ?, ?, SYSDATE, ?)
                """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, curso.getTitulo());
            ps.setDouble(2, curso.getPrecio());
            ps.setString(3, curso.getCategoria());
            ps.setString(4, curso.getEstado());
            ps.setDouble(5, curso.getPuntajeMinCert());
            if (curso.getIdInstructor() == 0) {
                ps.setNull(6, Types.INTEGER);
            } else {
                ps.setInt(6, curso.getIdInstructor());
            }
            ps.executeUpdate();
        }
    }

    
    
    

    public void update(Curso curso) throws SQLException {
        String sql = """
                UPDATE CURSO
                   SET TITULO           = ?,
                       PRECIO           = ?,
                       CATEGORIA        = ?,
                       ESTADO           = ?,
                       PUNTAJE_MIN_CERT = ?,
                       ID_INSTRUCTOR    = ?
                 WHERE ID_CURSO = ?
                """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, curso.getTitulo());
            ps.setDouble(2, curso.getPrecio());
            ps.setString(3, curso.getCategoria());
            ps.setString(4, curso.getEstado());
            ps.setDouble(5, curso.getPuntajeMinCert());
            if (curso.getIdInstructor() == 0) {
                ps.setNull(6, Types.INTEGER);
            } else {
                ps.setInt(6, curso.getIdInstructor());
            }
            ps.setInt(7, curso.getIdCurso());
            ps.executeUpdate();
        }
    }

    
    
    

    
    public void delete(int idCurso) throws SQLException {
        
        String checkSql = """
                SELECT COUNT(*) FROM INSCRIPCION
                 WHERE ID_CURSO = ? AND ESTADO = 'activo'
                """;
        try (Connection conn = DatabaseConnection.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                ps.setInt(1, idCurso);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        throw new SQLException(
                            "No se puede eliminar: el curso tiene estudiantes activos inscritos.");
                    }
                }
            }
            
            String deleteSql = "DELETE FROM CURSO WHERE ID_CURSO = ?";
            try (PreparedStatement ps = conn.prepareStatement(deleteSql)) {
                ps.setInt(1, idCurso);
                ps.executeUpdate();
            }
        }
    }

    
    
    

    public List<Object[]> countByEstado() throws SQLException {
        String sql = """
                SELECT ESTADO, COUNT(*) AS TOTAL
                  FROM CURSO
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

    
    
    

    private Curso mapRow(ResultSet rs) throws SQLException {
        Curso c = new Curso();
        c.setIdCurso(rs.getInt("ID_CURSO"));
        c.setTitulo(rs.getString("TITULO"));
        c.setPrecio(rs.getDouble("PRECIO"));
        c.setCategoria(rs.getString("CATEGORIA"));
        c.setEstado(rs.getString("ESTADO"));
        c.setPuntajeMinCert(rs.getDouble("PUNTAJE_MIN_CERT"));
        Date fecha = rs.getDate("FECHA_CREACION");
        if (fecha != null) c.setFechaCreacion(fecha.toLocalDate());
        c.setIdInstructor(rs.getInt("ID_INSTRUCTOR"));
        c.setNombreInstructor(rs.getString("NOMBRE_INSTRUCTOR"));
        return c;
    }
}
