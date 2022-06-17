package storage_data;

public class Exchanges {

    Float kupno,sprzedaz;
    String nazwa,skrot,symbol;

    public Exchanges(String nazwa, String skrot, String symbol, Float kupno, Float sprzedaz) {
        this.nazwa = nazwa;
        this.skrot = skrot;
        this.symbol = symbol;
        this.kupno = kupno;
        this.sprzedaz = sprzedaz;
    }

    public Float getKupno() { return kupno; }
    public void setKupno(Float kupno) { this.kupno = kupno; }

    public Float getSprzedaz() { return sprzedaz; }
    public void setSprzedaz(Float sprzedaz) { this.sprzedaz = sprzedaz; }

    public String getNazwa() { return nazwa; }
    public void setNazwa(String nazwa) { this.nazwa = nazwa; }

    public String getSkrot() { return skrot; }
    public void setSkrot(String skrot) { this.skrot = skrot; }

    public String getSymbol() { return symbol; }
    public void setSymbol(String symbol) { this.symbol = symbol; }
}
