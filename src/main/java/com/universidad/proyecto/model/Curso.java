package com.universidad.proyecto.model;

import java.time.LocalDate;

/**
 * Modelo que representa la tabla CURSO.
 */
public class Curso {

    private int       idCurso;
    private String    titulo;
    private double    precio;
    private String    categoria;
    private String    estado;           // 'en_desarrollo', 'publicado', 'archivado'
    private double    puntajeMinCert;
    private LocalDate fechaCreacion;
    private int       idInstructor;

    // Campo de join (no columna propia): nombre del instructor para mostrar en tabla
    private String    nombreInstructor;

    // ──────────────────────────────────────────────
    // Constructores
    // ──────────────────────────────────────────────

    public Curso() {}

    public Curso(int idCurso, String titulo, double precio, String categoria,
                 String estado, double puntajeMinCert, LocalDate fechaCreacion,
                 int idInstructor) {
        this.idCurso        = idCurso;
        this.titulo         = titulo;
        this.precio         = precio;
        this.categoria      = categoria;
        this.estado         = estado;
        this.puntajeMinCert = puntajeMinCert;
        this.fechaCreacion  = fechaCreacion;
        this.idInstructor   = idInstructor;
    }

    // ──────────────────────────────────────────────
    // Getters & Setters
    // ──────────────────────────────────────────────

    public int getIdCurso()                             { return idCurso; }
    public void setIdCurso(int idCurso)                 { this.idCurso = idCurso; }

    public String getTitulo()                           { return titulo; }
    public void setTitulo(String titulo)                { this.titulo = titulo; }

    public double getPrecio()                           { return precio; }
    public void setPrecio(double precio)                { this.precio = precio; }

    public String getCategoria()                        { return categoria; }
    public void setCategoria(String categoria)          { this.categoria = categoria; }

    public String getEstado()                           { return estado; }
    public void setEstado(String estado)                { this.estado = estado; }

    public double getPuntajeMinCert()                   { return puntajeMinCert; }
    public void setPuntajeMinCert(double puntajeMinCert){ this.puntajeMinCert = puntajeMinCert; }

    public LocalDate getFechaCreacion()                 { return fechaCreacion; }
    public void setFechaCreacion(LocalDate fechaCreacion){ this.fechaCreacion = fechaCreacion; }

    public int getIdInstructor()                        { return idInstructor; }
    public void setIdInstructor(int idInstructor)       { this.idInstructor = idInstructor; }

    public String getNombreInstructor()                 { return nombreInstructor; }
    public void setNombreInstructor(String nombreInstructor) { this.nombreInstructor = nombreInstructor; }

    public String getPrecioTexto() {
        return precio == 0 ? "Gratis" : String.format("$%.2f", precio);
    }

    @Override
    public String toString() { return titulo; }
}
