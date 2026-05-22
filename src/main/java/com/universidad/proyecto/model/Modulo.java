package com.universidad.proyecto.model;

public class Modulo {

    private int    idModulo;
    private String titulo;
    private int    orden;
    private int    idCurso;

    
    private String tituloCurso;

    

    public Modulo() {}

    public Modulo(int idModulo, String titulo, int orden, int idCurso) {
        this.idModulo = idModulo;
        this.titulo   = titulo;
        this.orden    = orden;
        this.idCurso  = idCurso;
    }

    

    public int getIdModulo()                        { return idModulo; }
    public void setIdModulo(int idModulo)           { this.idModulo = idModulo; }

    public String getTitulo()                       { return titulo; }
    public void setTitulo(String titulo)            { this.titulo = titulo; }

    public int getOrden()                           { return orden; }
    public void setOrden(int orden)                 { this.orden = orden; }

    public int getIdCurso()                         { return idCurso; }
    public void setIdCurso(int idCurso)             { this.idCurso = idCurso; }

    public String getTituloCurso()                  { return tituloCurso; }
    public void setTituloCurso(String tituloCurso)  { this.tituloCurso = tituloCurso; }

    @Override
    public String toString()                        { return orden + ". " + titulo; }
}
