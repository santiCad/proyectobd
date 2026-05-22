package com.universidad.proyecto.model;

import java.time.LocalDate;

/**
 * Modelo que representa la tabla ESTUDIANTE.
 * Extiende USUARIO mediante relación IS-A (herencia).
 */
public class Estudiante extends Usuario {

    private String    areasInteres;
    private LocalDate fechaNacim;
    private String    nivelEducativo;
    private int       notifEmail;   // 1 = sí, 0 = no

    // ──────────────────────────────────────────────
    // Constructores
    // ──────────────────────────────────────────────

    public Estudiante() {
        super();
        setRol("estudiante");
    }

    public Estudiante(int idUsuario, String nombre, String email,
                      String nickname, String contrasena,
                      int activo, LocalDate fechaRegistro,
                      String areasInteres, LocalDate fechaNacim,
                      String nivelEducativo, int notifEmail) {
        super(idUsuario, nombre, email, nickname, contrasena,
              "estudiante", activo, fechaRegistro);
        this.areasInteres   = areasInteres;
        this.fechaNacim     = fechaNacim;
        this.nivelEducativo = nivelEducativo;
        this.notifEmail     = notifEmail;
    }

    // ──────────────────────────────────────────────
    // Getters & Setters
    // ──────────────────────────────────────────────

    public String getAreasInteres()                         { return areasInteres; }
    public void setAreasInteres(String areasInteres)        { this.areasInteres = areasInteres; }

    public LocalDate getFechaNacim()                        { return fechaNacim; }
    public void setFechaNacim(LocalDate fechaNacim)         { this.fechaNacim = fechaNacim; }

    public String getNivelEducativo()                       { return nivelEducativo; }
    public void setNivelEducativo(String nivelEducativo)    { this.nivelEducativo = nivelEducativo; }

    public int getNotifEmail()                              { return notifEmail; }
    public void setNotifEmail(int notifEmail)               { this.notifEmail = notifEmail; }

    public String getNotifEmailTexto()                      { return notifEmail == 1 ? "Sí" : "No"; }
}
