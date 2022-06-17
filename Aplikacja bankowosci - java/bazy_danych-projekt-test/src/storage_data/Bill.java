package storage_data;

import java.math.BigDecimal;
import java.util.Date;

public class Bill {
    String nazwa,numer,waluta;
    java.util.Date data;
    BigDecimal saldo;
    int id_bill,dbid;

    public Bill(String nazwa, String numer, java.util.Date data, BigDecimal saldo, String waluta, int id_bill, int dbid) {
        this.nazwa=nazwa;
        this.numer=numer;
        this.data=data;
        this.saldo=saldo;
        this.waluta=waluta;
        this.id_bill=id_bill;
        this.dbid=dbid;
    }

    public String getNazwa() { return nazwa; }
    public void setNazwa(String nazwa) { this.nazwa = nazwa; }

    public String getNumer() { return numer; }
    public void setNumer(String numer) { this.numer = numer; }

    public String getWaluta() { return waluta; }
    public void setWaluta(String waluta) { this.waluta = waluta; }

    public java.util.Date getData() { return data; }
    public void setData(Date data) { this.data = data; }

    public BigDecimal getSaldo() { return saldo; }
    public void setSaldo(BigDecimal saldo) { this.saldo = saldo; }

    public int getIDBill() { return id_bill; }
    public void setIDBill(int id_bill) { this.id_bill = id_bill; }

    public int getDbid() { return dbid; }
    public void setDbid(int dbid) { this.dbid = dbid; }
}