package com.universidad.proyecto.model;

import java.time.LocalDate;

public class ProgresoLeccion {

    private int       idProgreso;
    private int       idUsuario;
    private int       idLeccion;
    private int       completada;         // 0 o 1
    private LocalDate fechaInicio;
    private LocalDate fechaCompletado;

    // Campos extra para JOIN con LECCION
    private String tituloLeccion;
    private String tipoContenido;
    private int    orden;
    private int    esObligatoria;



    public ProgresoLeccion() {}



    public int getIdProgreso()                              { return idProgreso; }
    public void setIdProgreso(int idProgreso)               { this.idProgreso = idProgreso; }

    public int getIdUsuario()                               { return idUsuario; }
    public void setIdUsuario(int idUsuario)                 { this.idUsuario = idUsuario; }

    public int getIdLeccion()                               { return idLeccion; }
    public void setIdLeccion(int idLeccion)                 { this.idLeccion = idLeccion; }

    public int getCompletada()                              { return completada; }
    public void setCompletada(int completada)               { this.completada = completada; }

    public LocalDate getFechaInicio()                       { return fechaInicio; }
    public void setFechaInicio(LocalDate fechaInicio)       { this.fechaInicio = fechaInicio; }

    public LocalDate getFechaCompletado()                   { return fechaCompletado; }
    public void setFechaCompletado(LocalDate f)             { this.fechaCompletado = f; }

    public String getTituloLeccion()                        { return tituloLeccion; }
    public void setTituloLeccion(String t)                  { this.tituloLeccion = t; }

    public String getTipoContenido()                        { return tipoContenido; }
    public void setTipoContenido(String t)                  { this.tipoContenido = t; }

    public int getOrden()                                   { return orden; }
    public void setOrden(int orden)                         { this.orden = orden; }

    public int getEsObligatoria()                           { return esObligatoria; }
    public void setEsObligatoria(int esObligatoria)         { this.esObligatoria = esObligatoria; }

    public String getCompletadaTexto()                      { return completada == 1 ? "✅ Completada" : "⏳ Pendiente"; }
    public String getObligatoriaTexto()                     { return esObligatoria == 1 ? "Sí" : "No"; }
}
