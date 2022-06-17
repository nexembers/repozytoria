package storage_data;

public class Deposit {

    String nazwa,data_utworzenia,data_zakonczenia;
    Float oprocentowanie;
    int saldo,dbid,czas_trwania;

    public Deposit(String nazwa, Float oprocentowanie, String data_utworzenia, String data_zakonczenia, int saldo, int dbid, int czas_trwania) {
        this.nazwa=nazwa;
        this.oprocentowanie=oprocentowanie;
        this.data_utworzenia=data_utworzenia;
        this.data_zakonczenia=data_zakonczenia;
        this.saldo=saldo;
        this.dbid=dbid;
        this.czas_trwania=czas_trwania;
    }

    public String getNazwa() { return nazwa; }
    public void setNazwa(String nazwa) { this.nazwa = nazwa; }

    public Float getOprocentowanie() { return oprocentowanie; }
    public void setOprocentowanie(Float oprocentowanie) { this.oprocentowanie = oprocentowanie; }

    public int getSaldo() { return saldo; }
    public void setSaldo(int saldo) { this.saldo = saldo; }

    public String getData_utworzenia() { return data_utworzenia; }
    public void setData_utworzenia(String data_utworzenia) { this.data_utworzenia = data_utworzenia; }

    public String getData_zakonczenia() { return data_zakonczenia; }
    public void setData_zakonczenia(String data_zakonczenia) { this.data_zakonczenia = data_zakonczenia; }

    public int getDbid() { return dbid; }
    public void setDbid(int dbid) { this.dbid = dbid; }

    public int getCzas_trwania() { return czas_trwania; }
    public void setCzas_trwania(int czas_trwania) { this.czas_trwania = czas_trwania; }
}