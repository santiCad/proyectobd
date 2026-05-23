package com.universidad.proyecto.model;

import java.time.LocalDate;

public class Certificado {

    private int       idCertificado;
    private int       idUsuario;
    private int       idCurso;
    private String    codVerif;
    private LocalDate fechaGen;
    private String    urlDescarga;

    // Campos extra para JOIN
    private String nombreEstudiante;
    private String tituloCurso;



    public Certificado() {}

    public Certificado(int idCertificado, int idUsuario, int idCurso,
                       String codVerif, LocalDate fechaGen, String urlDescarga) {
        this.idCertificado = idCertificado;
        this.idUsuario     = idUsuario;
        this.idCurso       = idCurso;
        this.codVerif      = codVerif;
        this.fechaGen      = fechaGen;
        this.urlDescarga   = urlDescarga;
    }



    public int getIdCertificado()                           { return idCertificado; }
    public void setIdCertificado(int idCertificado)         { this.idCertificado = idCertificado; }

    public int getIdUsuario()                               { return idUsuario; }
    public void setIdUsuario(int idUsuario)                 { this.idUsuario = idUsuario; }

    public int getIdCurso()                                 { return idCurso; }
    public void setIdCurso(int idCurso)                     { this.idCurso = idCurso; }

    public String getCodVerif()                             { return codVerif; }
    public void setCodVerif(String codVerif)                { this.codVerif = codVerif; }

    public LocalDate getFechaGen()                          { return fechaGen; }
    public void setFechaGen(LocalDate fechaGen)             { this.fechaGen = fechaGen; }

    public String getUrlDescarga()                          { return urlDescarga; }
    public void setUrlDescarga(String urlDescarga)          { this.urlDescarga = urlDescarga; }

    public String getNombreEstudiante()                     { return nombreEstudiante; }
    public void setNombreEstudiante(String n)               { this.nombreEstudiante = n; }

    public String getTituloCurso()                          { return tituloCurso; }
    public void setTituloCurso(String t)                    { this.tituloCurso = t; }

    @Override
    public String toString()                                { return codVerif; }
}
