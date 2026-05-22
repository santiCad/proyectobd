package com.universidad.proyecto.model;

import java.time.LocalDate;

public class Usuario {

    private int    idUsuario;
    private String nombre;
    private String email;
    private String nickname;
    private String contrasena;
    private String rol;          
    private int    activo;       
    private LocalDate fechaRegistro;

    
    
    

    public Usuario() {}

    public Usuario(int idUsuario, String nombre, String email,
                   String nickname, String contrasena, String rol,
                   int activo, LocalDate fechaRegistro) {
        this.idUsuario     = idUsuario;
        this.nombre        = nombre;
        this.email         = email;
        this.nickname      = nickname;
        this.contrasena    = contrasena;
        this.rol           = rol;
        this.activo        = activo;
        this.fechaRegistro = fechaRegistro;
    }

    
    
    

    public int getIdUsuario()                     { return idUsuario; }
    public void setIdUsuario(int idUsuario)       { this.idUsuario = idUsuario; }

    public String getNombre()                     { return nombre; }
    public void setNombre(String nombre)          { this.nombre = nombre; }

    public String getEmail()                      { return email; }
    public void setEmail(String email)            { this.email = email; }

    public String getNickname()                   { return nickname; }
    public void setNickname(String nickname)      { this.nickname = nickname; }

    public String getContrasena()                 { return contrasena; }
    public void setContrasena(String contrasena)  { this.contrasena = contrasena; }

    public String getRol()                        { return rol; }
    public void setRol(String rol)                { this.rol = rol; }

    public int getActivo()                        { return activo; }
    public void setActivo(int activo)             { this.activo = activo; }

    public LocalDate getFechaRegistro()                         { return fechaRegistro; }
    public void setFechaRegistro(LocalDate fechaRegistro)       { this.fechaRegistro = fechaRegistro; }

    public String getActivoTexto()                { return activo == 1 ? "Activo" : "Inactivo"; }

    @Override
    public String toString() {
        return nombre + " (" + email + ")";
    }
}
