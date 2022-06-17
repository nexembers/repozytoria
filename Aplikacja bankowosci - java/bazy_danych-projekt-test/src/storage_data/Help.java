package storage_data;

import java.util.Date;

public class Help {
    Date data;
    String temat,zakonczono;
    int ilosc,id;

    public Help(int id, Date data, String zakonczono, String temat, int ilosc) {
        this.id = id;
        this.data = data;
        this.zakonczono = zakonczono;
        this.temat = temat;
        this.ilosc = ilosc;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Date getData() { return data; }
    public void setData(Date data) { this.data = data; }

    public String getZakonczono() { return zakonczono; }
    public void setZakonczono(String zakonczono) { this.zakonczono = zakonczono; }

    public int getIlosc() { return ilosc; }
    public void setIlosc(int ilosc) { this.ilosc = ilosc; }

    public String getTemat() { return temat; }
    public void setTemat(String temat) { this.temat = temat; }


}
