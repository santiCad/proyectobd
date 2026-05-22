package com.universidad.proyecto.dao;

import com.universidad.proyecto.model.Estudiante;
import com.universidad.proyecto.model.Instructor;
import com.universidad.proyecto.model.Usuario;
import com.universidad.proyecto.util.DatabaseConnection;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    
    
    

    public List<Usuario> findAll() throws SQLException {
        String sql = """
                SELECT ID_USUARIO, NOMBRE, EMAIL, NICKNAME,
                       CONTRASENA, ROL, ACTIVO, FECHA_REGISTRO
                  FROM USUARIO
                 ORDER BY NOMBRE
                """;
        List<Usuario> lista = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapUsuario(rs));
        }
        return lista;
    }

    
    
    

    public List<Usuario> findByFiltro(String nombre, String rol) throws SQLException {
        StringBuilder sb = new StringBuilder("""
                SELECT ID_USUARIO, NOMBRE, EMAIL, NICKNAME,
                       CONTRASENA, ROL, ACTIVO, FECHA_REGISTRO
                  FROM USUARIO WHERE 1=1
                """);
        List<Object> params = new ArrayList<>();

        if (nombre != null && !nombre.isBlank()) {
            sb.append(" AND UPPER(NOMBRE) LIKE UPPER(?)");
            params.add("%" + nombre + "%");
        }
        if (rol != null && !rol.equals("Todos")) {
            sb.append(" AND ROL = ?");
            params.add(rol.toLowerCase());
        }
        sb.append(" ORDER BY NOMBRE");

        List<Usuario> lista = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sb.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapUsuario(rs));
            }
        }
        return lista;
    }

    
    
    

    public List<Instructor> findAllInstructores() throws SQLException {
        String sql = """
                SELECT i.ID_INSTRUCTOR, u.ID_USUARIO, u.NOMBRE, u.EMAIL,
                       u.NICKNAME, u.CONTRASENA, u.ACTIVO, u.FECHA_REGISTRO,
                       i.ESPECIALIDAD, i.BIOGRAFIA, i.CALIFICACION_PROM
                  FROM INSTRUCTOR i
                  JOIN USUARIO u ON i.ID_USUARIO = u.ID_USUARIO
                 ORDER BY u.NOMBRE
                """;
        List<Instructor> lista = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapInstructor(rs));
        }
        return lista;
    }

    
    
    

    public void insertEstudiante(Estudiante e) throws SQLException {
        String sqlU = """
                INSERT INTO USUARIO
                    (ID_USUARIO, NOMBRE, EMAIL, NICKNAME, CONTRASENA,
                     ROL, ACTIVO, FECHA_REGISTRO)
                VALUES (SEQ_USUARIO.NEXTVAL, ?, ?, ?, ?, 'estudiante', 1, SYSDATE)
                """;
        String sqlE = """
                INSERT INTO ESTUDIANTE
                    (ID_USUARIO, AREAS_INTERES, FECHA_NACIM,
                     NIVEL_EDUCATIVO, NOTIF_EMAIL)
                VALUES (SEQ_USUARIO.CURRVAL, ?, ?, ?, ?)
                """;
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                try (PreparedStatement ps = conn.prepareStatement(sqlU)) {
                    ps.setString(1, e.getNombre());
                    ps.setString(2, e.getEmail());
                    ps.setString(3, e.getNickname());
                    ps.setString(4, e.getContrasena());
                    ps.executeUpdate();
                }
                try (PreparedStatement ps = conn.prepareStatement(sqlE)) {
                    ps.setString(1, e.getAreasInteres());
                    if (e.getFechaNacim() != null) {
                        ps.setDate(2, Date.valueOf(e.getFechaNacim()));
                    } else {
                        ps.setNull(2, Types.DATE);
                    }
                    ps.setString(3, e.getNivelEducativo());
                    ps.setInt(4, e.getNotifEmail());
                    ps.executeUpdate();
                }
                conn.commit();
            } catch (SQLException ex) {
                conn.rollback();
                throw ex;
            }
        }
    }

    public void insertInstructor(Instructor inst) throws SQLException {
        String sqlU = """
                INSERT INTO USUARIO
                    (ID_USUARIO, NOMBRE, EMAIL, NICKNAME, CONTRASENA,
                     ROL, ACTIVO, FECHA_REGISTRO)
                VALUES (SEQ_USUARIO.NEXTVAL, ?, ?, ?, ?, 'instructor', 1, SYSDATE)
                """;
        String sqlI = """
                INSERT INTO INSTRUCTOR
                    (ID_INSTRUCTOR, ID_USUARIO, ESPECIALIDAD, NOMBRE,
                     BIOGRAFIA, CALIFICACION_PROM)
                VALUES (SEQ_INSTRUCTOR.NEXTVAL, SEQ_USUARIO.CURRVAL, ?, ?, ?, 0)
                """;
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                try (PreparedStatement ps = conn.prepareStatement(sqlU)) {
                    ps.setString(1, inst.getNombre());
                    ps.setString(2, inst.getEmail());
                    ps.setString(3, inst.getNickname());
                    ps.setString(4, inst.getContrasena());
                    ps.executeUpdate();
                }
                try (PreparedStatement ps = conn.prepareStatement(sqlI)) {
                    ps.setString(1, inst.getEspecialidad());
                    ps.setString(2, inst.getNombre());
                    ps.setString(3, inst.getBiografia());
                    ps.executeUpdate();
                }
                conn.commit();
            } catch (SQLException ex) {
                conn.rollback();
                throw ex;
            }
        }
    }

    
    
    

    public void update(Usuario u) throws SQLException {
        String sql = """
                UPDATE USUARIO
                   SET NOMBRE   = ?,
                       EMAIL    = ?,
                       NICKNAME = ?,
                       ACTIVO   = ?
                 WHERE ID_USUARIO = ?
                """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, u.getNombre());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getNickname());
            ps.setInt(4, u.getActivo());
            ps.setInt(5, u.getIdUsuario());
            ps.executeUpdate();
        }
    }

    
    
    

    public void deactivate(int idUsuario) throws SQLException {
        String sql = "UPDATE USUARIO SET ACTIVO = 0 WHERE ID_USUARIO = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.executeUpdate();
        }
    }

    
    
    

    public boolean existeEmail(String email, int excludeId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM USUARIO WHERE EMAIL = ? AND ID_USUARIO != ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setInt(2, excludeId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    public boolean existeNickname(String nickname, int excludeId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM USUARIO WHERE NICKNAME = ? AND ID_USUARIO != ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nickname);
            ps.setInt(2, excludeId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    
    
    

    public List<Object[]> countByRol() throws SQLException {
        String sql = """
                SELECT ROL, COUNT(*) AS TOTAL
                  FROM USUARIO
                 GROUP BY ROL
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

    
    
    

    private Usuario mapUsuario(ResultSet rs) throws SQLException {
        Usuario u = new Usuario();
        u.setIdUsuario(rs.getInt("ID_USUARIO"));
        u.setNombre(rs.getString("NOMBRE"));
        u.setEmail(rs.getString("EMAIL"));
        u.setNickname(rs.getString("NICKNAME"));
        u.setContrasena(rs.getString("CONTRASENA"));
        u.setRol(rs.getString("ROL"));
        u.setActivo(rs.getInt("ACTIVO"));
        Date d = rs.getDate("FECHA_REGISTRO");
        if (d != null) u.setFechaRegistro(d.toLocalDate());
        return u;
    }

    private Instructor mapInstructor(ResultSet rs) throws SQLException {
        Instructor i = new Instructor();
        i.setIdInstructor(rs.getInt("ID_INSTRUCTOR"));
        i.setIdUsuario(rs.getInt("ID_USUARIO"));
        i.setNombre(rs.getString("NOMBRE"));
        i.setEmail(rs.getString("EMAIL"));
        i.setNickname(rs.getString("NICKNAME"));
        i.setRol("instructor");
        i.setActivo(rs.getInt("ACTIVO"));
        Date d = rs.getDate("FECHA_REGISTRO");
        if (d != null) i.setFechaRegistro(d.toLocalDate());
        i.setEspecialidad(rs.getString("ESPECIALIDAD"));
        i.setBiografia(rs.getString("BIOGRAFIA"));
        i.setCalificacionProm(rs.getDouble("CALIFICACION_PROM"));
        return i;
    }
}
