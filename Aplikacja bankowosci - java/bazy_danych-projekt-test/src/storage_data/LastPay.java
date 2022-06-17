package storage_data;

public class LastPay {

    String rodzaj,rachunek,tytul;
    String data;
    Float kwota;

    public LastPay(String rodzaj, String data, String rachunek, String tytul, Float kwota) {
        this.rodzaj=rodzaj;
        this.data=data;
        this.rachunek=rachunek;
        this.tytul=tytul;
        this.kwota=kwota;
    }

    public String getRodzaj() { return rodzaj; }
    public void setRodzaj(String rodzaj) { this.rodzaj = rodzaj; }

    public String getRachunek() { return rachunek; }
    public void setRachunek(String rachunek) { this.rachunek = rachunek; }

    public String getTytul() { return tytul; }
    public void setTytul(String tytul) { this.tytul = tytul; }

    public String getData() { return data; }
    public void setData(String data) { this.data = data; }

    public Float getKwota() { return kwota; }
    public void setKwota(Float kwota) { this.kwota = kwota; }



}
