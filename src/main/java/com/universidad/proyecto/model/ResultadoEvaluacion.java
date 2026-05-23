package com.universidad.proyecto.model;

import java.time.LocalDate;

public class ResultadoEvaluacion {

    private int       idResultado;
    private int       idEval;
    private int       idUsuario;
    private double    puntajeObtenido;
    private LocalDate fechaIntento;
    private int       aprobado;          // 0 o 1

    // Campos extra para JOIN
    private String tituloEval;
    private String nombreEstudiante;
    private String tituloCurso;



    public ResultadoEvaluacion() {}

    public ResultadoEvaluacion(int idResultado, int idEval, int idUsuario,
                               double puntajeObtenido, LocalDate fechaIntento, int aprobado) {
        this.idResultado     = idResultado;
        this.idEval          = idEval;
        this.idUsuario       = idUsuario;
        this.puntajeObtenido = puntajeObtenido;
        this.fechaIntento    = fechaIntento;
        this.aprobado        = aprobado;
    }



    public int getIdResultado()                               { return idResultado; }
    public void setIdResultado(int idResultado)               { this.idResultado = idResultado; }

    public int getIdEval()                                    { return idEval; }
    public void setIdEval(int idEval)                         { this.idEval = idEval; }

    public int getIdUsuario()                                 { return idUsuario; }
    public void setIdUsuario(int idUsuario)                   { this.idUsuario = idUsuario; }

    public double getPuntajeObtenido()                        { return puntajeObtenido; }
    public void setPuntajeObtenido(double puntajeObtenido)    { this.puntajeObtenido = puntajeObtenido; }

    public LocalDate getFechaIntento()                        { return fechaIntento; }
    public void setFechaIntento(LocalDate fechaIntento)       { this.fechaIntento = fechaIntento; }

    public int getAprobado()                                  { return aprobado; }
    public void setAprobado(int aprobado)                     { this.aprobado = aprobado; }

    public String getTituloEval()                             { return tituloEval; }
    public void setTituloEval(String t)                       { this.tituloEval = t; }

    public String getNombreEstudiante()                       { return nombreEstudiante; }
    public void setNombreEstudiante(String n)                 { this.nombreEstudiante = n; }

    public String getTituloCurso()                            { return tituloCurso; }
    public void setTituloCurso(String t)                      { this.tituloCurso = t; }

    public String getAprobadoTexto()                          { return aprobado == 1 ? "✅ Aprobado" : "❌ Reprobado"; }
    public String getPuntajeTexto()                           { return String.format("%.1f", puntajeObtenido); }
}
