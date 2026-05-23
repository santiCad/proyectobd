package com.universidad.proyecto.model;

public class Evaluacion {

    private int     idEval;
    private String  titulo;
    private String  tipo;              // quiz, tarea, examen_final
    private double  puntajeMin;
    private Integer tiempoLimiteMin;   // nullable
    private int     idCurso;

    // Campo extra para JOIN
    private String tituloCurso;



    public Evaluacion() {}

    public Evaluacion(int idEval, String titulo, String tipo,
                      double puntajeMin, Integer tiempoLimiteMin, int idCurso) {
        this.idEval          = idEval;
        this.titulo          = titulo;
        this.tipo            = tipo;
        this.puntajeMin      = puntajeMin;
        this.tiempoLimiteMin = tiempoLimiteMin;
        this.idCurso         = idCurso;
    }



    public int getIdEval()                              { return idEval; }
    public void setIdEval(int idEval)                   { this.idEval = idEval; }

    public String getTitulo()                           { return titulo; }
    public void setTitulo(String titulo)                { this.titulo = titulo; }

    public String getTipo()                             { return tipo; }
    public void setTipo(String tipo)                    { this.tipo = tipo; }

    public double getPuntajeMin()                       { return puntajeMin; }
    public void setPuntajeMin(double puntajeMin)        { this.puntajeMin = puntajeMin; }

    public Integer getTiempoLimiteMin()                 { return tiempoLimiteMin; }
    public void setTiempoLimiteMin(Integer t)           { this.tiempoLimiteMin = t; }

    public int getIdCurso()                             { return idCurso; }
    public void setIdCurso(int idCurso)                 { this.idCurso = idCurso; }

    public String getTituloCurso()                      { return tituloCurso; }
    public void setTituloCurso(String t)                { this.tituloCurso = t; }

    public String getTiempoTexto() {
        return tiempoLimiteMin != null ? tiempoLimiteMin + " min" : "Sin límite";
    }

    @Override
    public String toString()                            { return titulo + " (" + tipo + ")"; }
}
