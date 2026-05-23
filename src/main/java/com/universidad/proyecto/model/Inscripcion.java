package com.universidad.proyecto.model;

import java.time.LocalDate;

public class Inscripcion {

    private int       idInscripcion;
    private int       idUsuario;
    private int       idCurso;
    private LocalDate fechaMatric;
    private double    progresoPct;
    private String    estado;           // activo, completado, abandonado

    // Campos extra para JOIN
    private String nombreEstudiante;
    private String tituloCurso;



    public Inscripcion() {}

    public Inscripcion(int idInscripcion, int idUsuario, int idCurso,
                       LocalDate fechaMatric, double progresoPct, String estado) {
        this.idInscripcion = idInscripcion;
        this.idUsuario     = idUsuario;
        this.idCurso       = idCurso;
        this.fechaMatric   = fechaMatric;
        this.progresoPct   = progresoPct;
        this.estado        = estado;
    }



    public int getIdInscripcion()                         { return idInscripcion; }
    public void setIdInscripcion(int idInscripcion)       { this.idInscripcion = idInscripcion; }

    public int getIdUsuario()                             { return idUsuario; }
    public void setIdUsuario(int idUsuario)               { this.idUsuario = idUsuario; }

    public int getIdCurso()                               { return idCurso; }
    public void setIdCurso(int idCurso)                   { this.idCurso = idCurso; }

    public LocalDate getFechaMatric()                     { return fechaMatric; }
    public void setFechaMatric(LocalDate fechaMatric)     { this.fechaMatric = fechaMatric; }

    public double getProgresoPct()                        { return progresoPct; }
    public void setProgresoPct(double progresoPct)        { this.progresoPct = progresoPct; }

    public String getEstado()                             { return estado; }
    public void setEstado(String estado)                  { this.estado = estado; }

    public String getNombreEstudiante()                   { return nombreEstudiante; }
    public void setNombreEstudiante(String n)             { this.nombreEstudiante = n; }

    public String getTituloCurso()                        { return tituloCurso; }
    public void setTituloCurso(String t)                  { this.tituloCurso = t; }

    public String getProgresoPctTexto()                   { return String.format("%.1f%%", progresoPct); }

    @Override
    public String toString()                              { return nombreEstudiante + " → " + tituloCurso; }
}
