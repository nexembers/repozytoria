package storage_data;
import java.util.Date;

public class Messages {
    private static int _sprawa_id;
    private static Date _odpowiedz_datazakonczenia=null;
    int odpowiedz_id;
    String odpowiedz_imie,odpowiedz_nazwisko,odpowiedz_identyfikator,odpowiedz_wiadomosc;
    Date odpowiedz_data;

    public static int getSprawa_id() {
        return _sprawa_id;
    }
    public static void setSprawa_id(int sprawa_id) {
        _sprawa_id = sprawa_id;
    }

    public static Date getDataZakonczenia() {
        return _odpowiedz_datazakonczenia;
    }
    public static void setDataZakonczenia() { _odpowiedz_datazakonczenia=new Date(); }

    public int getOdpowiedz_id() {
        return odpowiedz_id;
    }
    public void setOdpowiedz_id(int odpowiedz_id) { this.odpowiedz_id = odpowiedz_id; }

    public String getOdpowiedz_imie() {
        return odpowiedz_imie;
    }
    public void setOdpowiedz_imie(String odpowiedz_imie) {
        this.odpowiedz_imie = odpowiedz_imie;
    }

    public String getOdpowiedz_nazwisko() {
        return odpowiedz_nazwisko;
    }
    public void setOdpowiedz_nazwisko(String odpowiedz_nazwisko) {
        this.odpowiedz_nazwisko = odpowiedz_nazwisko;
    }

    public String getOdpowiedz_identyfikator() {
        return odpowiedz_identyfikator;
    }
    public void setOdpowiedz_identyfikator(String odpowiedz_identyfikator) { this.odpowiedz_identyfikator = odpowiedz_identyfikator; }

    public String getOdpowiedz_wiadomosc() {
        return odpowiedz_wiadomosc;
    }
    public void setOdpowiedz_wiadomosc(String odpowiedz_wiadomosc) {
        this.odpowiedz_wiadomosc = odpowiedz_wiadomosc;
    }

    public Date getOdpowiedz_data() {
        return odpowiedz_data;
    }
    public void setOdpowiedz_data(Date odpowiedz_data) {
        this.odpowiedz_data = odpowiedz_data;
    }

    public Messages(int id, Date data, String imie, String nazwisko, String identyfikator, String wiadomosc,Date odpowiedz_datazakonczenia) {
        this.odpowiedz_id = id;
        this.odpowiedz_data = data;
        this.odpowiedz_imie = imie;
        this.odpowiedz_nazwisko = nazwisko;
        this.odpowiedz_identyfikator = identyfikator;
        this.odpowiedz_wiadomosc = wiadomosc;
        _odpowiedz_datazakonczenia = odpowiedz_datazakonczenia;
    }
}
