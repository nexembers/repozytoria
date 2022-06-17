package com.PUMzaliczenie.bankowosc;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.text.Editable;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class transferspage extends AppCompatActivity implements AdapterView.OnItemSelectedListener {
    Spinner spinner;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.transferspage);

        TextView saldo=findViewById(R.id.info_saldo);
        saldo.setText("Saldo konta: "+session_data.get_saldo()+" PLN");

        System.out.println("ok");

        try {
            refreshListContacts();
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }


        Intent intent = getIntent();
        Bundle bundle = intent.getExtras();
        if(bundle != null) {
            EditText przelew_nazwa=findViewById(R.id.przelew_nazwa);
            EditText przelew_numer=findViewById(R.id.przelew_rachunek);

            String nazwa_odbiorcy = bundle.getString("nazwa_odbiorcy");
            String rachunek_odbiorcy = bundle.getString("rachunek_odbiorcy");

            przelew_nazwa.setText(nazwa_odbiorcy);
            przelew_numer.setText(rachunek_odbiorcy);
        }


    }
    public List<String> lista_kontaktow = new ArrayList<String>();
    public List<String> lista_numerow = new ArrayList<String>();

    public void refreshListContacts() throws SQLException {

        lista_kontaktow.clear();
        lista_numerow.clear();
        Spinner spinner_kontakty=findViewById(R.id.przelew_kontakty_spinner);
        dbConnect conn=new dbConnect();
        ResultSet rs=conn.getContacts();
        while(rs.next()){
            lista_kontaktow.add(rs.getString("uzytkownicy_rachunki_odbiorca")+": "+rs.getString("nazwa"));
            lista_numerow.add(rs.getString("uzytkownicy_rachunki_odbiorca"));
        }
        spinner_kontakty.setOnItemSelectedListener(this);
        ArrayAdapter<String> aa=new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item,lista_kontaktow);
        aa.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner_kontakty.setAdapter(aa);
    }

    public void back(View w) {
        Intent intent = new Intent(this, menu.class);
        startActivity(intent);
    }

    public void makeTransfer(View w) throws SQLException {
        EditText przelew_nazwa=findViewById(R.id.przelew_nazwa);
        EditText przelew_adres=findViewById(R.id.przelew_adres);
        EditText przelew_numer=findViewById(R.id.przelew_rachunek);
        EditText przelew_tytul=findViewById(R.id.przelew_tytul);
        EditText przelew_kwota=findViewById(R.id.przelew_kwota);

        TextView info_blad=findViewById(R.id.info_blad);

        if(przelew_nazwa.getText().length()>=4){
            if(przelew_adres.getText().length()>=4){
                if(przelew_numer.getText().length()==8){
                    if(przelew_tytul.getText().length()>=2){
                        if(przelew_kwota.getText().length()>0){
                            float value= Float.parseFloat(przelew_kwota.getText().toString());
                            if(session_data.get_saldo()>=value){
                                if(session_data.get_limitprzelewu()>=value){
                                    dbConnect conn=new dbConnect();
                                    ResultSet rs=conn.getAccount_is(przelew_numer.getText().toString());
                                    if (rs.next()) {
                                        //Float kwota,String rachunek_nadawcy,String rachunek_odbiorcy,String adresat,String tytul,int rachunek_id
                                        int wynik=conn.makeTransfer(value,session_data.get_defaultbill(),przelew_numer.getText().toString(),przelew_nazwa.getText().toString(),przelew_tytul.getText().toString(),rs.getInt("id"));
                                        System.out.println("default bill: "+session_data.get_defaultbill());
                                        if(wynik==1){
                                            session_data.set_saldo(session_data.get_saldo()-value);
                                            przelew_adres.setText("");
                                            przelew_kwota.setText("");
                                            przelew_nazwa.setText("");
                                            przelew_numer.setText("");
                                            przelew_tytul.setText("");
                                            new CountDownTimer(5000, 1000) {
                                                public void onTick(long millisUntilFinished) { info_blad.setText("Przelew został zlecony!"); }
                                                public void onFinish() { info_blad.setText("Wybierz kontakt z listy rozwijanej poniżej lub wprowadź dane do przelewu samodzielnie."); }
                                            }.start();
                                            TextView saldo=findViewById(R.id.info_saldo);
                                            saldo.setText("Saldo konta: "+session_data.get_saldo()+" PLN");
                                        }
                                        else
                                            System.out.println("nie wykonano przelewu.");
                                    }
                                    else
                                    {
                                        new CountDownTimer(5000, 1000) {
                                            public void onTick(long millisUntilFinished) { info_blad.setText("Nie znaleziono osoby z podanym numerem rachunku w bazie!"); }
                                            public void onFinish() { info_blad.setText("Wybierz kontakt z listy rozwijanej poniżej lub wprowadź dane do przelewu samodzielnie."); }
                                        }.start();
                                    }
                                }
                                else {
                                    new CountDownTimer(5000, 1000) {
                                        public void onTick(long millisUntilFinished) { info_blad.setText("Limit przelewu jest niższy niż kwota zadeklarowana w przelewie!"); }
                                        public void onFinish() { info_blad.setText("Wybierz kontakt z listy rozwijanej poniżej lub wprowadź dane do przelewu samodzielnie."); }
                                    }.start();
                                }
                            }
                            else {
                                new CountDownTimer(5000, 1000) {
                                    public void onTick(long millisUntilFinished) { info_blad.setText("Saldo Twojego konta jest mniejsze niż kwota przelewu!"); }
                                    public void onFinish() { info_blad.setText("Wybierz kontakt z listy rozwijanej poniżej lub wprowadź dane do przelewu samodzielnie."); }
                                }.start();
                            }
                        }
                        else
                        {
                            new CountDownTimer(5000, 1000) {
                                public void onTick(long millisUntilFinished) { info_blad.setText("Kwota przelewu do odbiorcy musi być większa od 0!"); }
                                public void onFinish() { info_blad.setText("Wybierz kontakt z listy rozwijanej poniżej lub wprowadź dane do przelewu samodzielnie."); }
                            }.start();
                        }
                    }
                    else
                    {
                        new CountDownTimer(5000, 1000) {
                            public void onTick(long millisUntilFinished) { info_blad.setText("Tytuł przelewu musi zawierać co najmniej 2 znaki!"); }
                            public void onFinish() { info_blad.setText("Wybierz kontakt z listy rozwijanej poniżej lub wprowadź dane do przelewu samodzielnie."); }
                        }.start();
                    }
                }
                else
                {
                    new CountDownTimer(5000, 1000) {
                        public void onTick(long millisUntilFinished) { info_blad.setText("Numer rachunku odbiorcy musi zawierać dokładnie 8 cyfr!"); }
                        public void onFinish() { info_blad.setText("Wybierz kontakt z listy rozwijanej poniżej lub wprowadź dane do przelewu samodzielnie."); }
                    }.start();
                }
            }
            else
            {
                new CountDownTimer(5000, 1000) {
                    public void onTick(long millisUntilFinished) { info_blad.setText("Adres musi zawierać co najmniej 4 znaki!"); }
                    public void onFinish() { info_blad.setText("Wybierz kontakt z listy rozwijanej poniżej lub wprowadź dane do przelewu samodzielnie."); }
                }.start();
            }
        }
        else
        {
            new CountDownTimer(5000, 1000) {
                public void onTick(long millisUntilFinished) { info_blad.setText("Nazwa odbiorcy musi zawierać co najmniej 4 znaki!"); }
                public void onFinish() { info_blad.setText("Wybierz kontakt z listy rozwijanej poniżej lub wprowadź dane do przelewu samodzielnie."); }
            }.start();
        }
    }

    /**
     EditText przelew_nazwa=findViewById(R.id.przelew_nazwa);
     EditText przelew_adres=findViewById(R.id.przelew_adres);
     EditText przelew_numer=findViewById(R.id.przelew_rachunek);
     EditText przelew_tytul=findViewById(R.id.przelew_tytul);
     EditText przelew_kwota=findViewById(R.id.przelew_kwota);
     */

    public void setInfoContact(View w){
        Spinner spinner_kontakty=findViewById(R.id.przelew_kontakty_spinner);

        dbConnect conn=new dbConnect();
        try {
            ResultSet rs=conn.getInfoAboutContact(lista_numerow.get(spinner_kontakty.getSelectedItemPosition())); // filtruj po nr. rachunku bankowego
            if(rs.next()){
                EditText przelew_nazwa=findViewById(R.id.przelew_nazwa);
                EditText przelew_numer=findViewById(R.id.przelew_rachunek);

                przelew_nazwa.setText(rs.getString("nazwa"));
                przelew_numer.setText(rs.getString("uzytkownicy_rachunki_odbiorca"));
            }
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }

    @Override
    public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {

    }

    @Override
    public void onNothingSelected(AdapterView<?> adapterView) {

    }

    @Override
    public void onPointerCaptureChanged(boolean hasCapture) {

    }
}