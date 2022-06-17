package com.PUMzaliczenie.bankowosc;

import java.util.ArrayList;
import java.util.Date;

public class Note {
    public static ArrayList<Note> noteArrayList=new ArrayList<>();

    private int id;
    private String title,description,data,typ;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getData() { return data; }
    public void setData(String data) { this.data = data; }

    public String getTyp() { return typ; }
    public void setTyp(String typ) { this.typ = typ; }


    public Note(int id, String title, String description, String data,String typ) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.data = data;
        this.typ = typ;
    }

    public Note(int id, String title, String description) {
        this.id = id;
        this.title = title;
        this.description = description;
    }
}
