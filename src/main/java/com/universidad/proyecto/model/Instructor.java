package com.universidad.proyecto.model;

import java.time.LocalDate;

public class Instructor extends Usuario {

    private int    idInstructor;
    private String especialidad;
    private String biografia;
    private double calificacionProm;

    
    
    

    public Instructor() {
        super();
        setRol("instructor");
    }

    public Instructor(int idInstructor, int idUsuario, String nombre,
                      String email, String nickname, String contrasena,
                      int activo, LocalDate fechaRegistro,
                      String especialidad, String biografia,
                      double calificacionProm) {
        super(idUsuario, nombre, email, nickname, contrasena,
              "instructor", activo, fechaRegistro);
        this.idInstructor    = idInstructor;
        this.especialidad    = especialidad;
        this.biografia       = biografia;
        this.calificacionProm = calificacionProm;
    }

    
    
    

    public int getIdInstructor()                            { return idInstructor; }
    public void setIdInstructor(int idInstructor)           { this.idInstructor = idInstructor; }

    public String getEspecialidad()                         { return especialidad; }
    public void setEspecialidad(String especialidad)        { this.especialidad = especialidad; }

    public String getBiografia()                            { return biografia; }
    public void setBiografia(String biografia)              { this.biografia = biografia; }

    public double getCalificacionProm()                     { return calificacionProm; }
    public void setCalificacionProm(double calificacionProm){ this.calificacionProm = calificacionProm; }
}
