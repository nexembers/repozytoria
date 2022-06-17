package com.PUMzaliczenie.bankowosc;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.os.CountDownTimer;
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

public class contactspage extends AppCompatActivity implements AdapterView.OnItemSelectedListener {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.contactspage);

        try {
            refreshListContacts();
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }
    public List<String> lista_kontaktow = new ArrayList<String>();
    public List<String> lista_numerow = new ArrayList<String>();


    public void refreshListContacts() throws SQLException {

        lista_kontaktow.clear();
        lista_numerow.clear();
        Spinner spinner_kontakty=findViewById(R.id.spinner_kontakty);
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


    public void addnewcontact(View w) throws SQLException {
        EditText nazwa=findViewById(R.id.kontakt_nazwa);
        EditText numer=findViewById(R.id.kontakt_numer);
        TextView blad=findViewById(R.id.blad6);

        if(nazwa.getText().length()>=6 && nazwa.getText().length()<=64){
            if(numer.getText().length()==8) {
                dbConnect conn=new dbConnect();
                if(conn.getAccountNumber(numer.getText().toString(),nazwa.getText().toString())==1) {
                    new CountDownTimer(5000, 1000) {
                        public void onTick(long millisUntilFinished) { blad.setText("Kontakt "+nazwa.getText().toString()+" został dodany do bazy danych!"); }
                        public void onFinish() { blad.setText(""); }
                    }.start();
                    nazwa.setText("");
                    numer.setText("");

                    refreshListContacts();
                }
                else {
                    new CountDownTimer(5000, 1000) {
                        public void onTick(long millisUntilFinished) { blad.setText("Numer rachunku nie jest do nikogo przypisany! Sprawdź, czy posiadasz prawidłowe informacje na temat kontaktu."); }
                        public void onFinish() { blad.setText(""); }
                    }.start();
                }
            }
            else {
                new CountDownTimer(5000, 1000) {
                    public void onTick(long millisUntilFinished) { blad.setText("Numer rachunku powinien zawierać dokładnie 8 cyfr!"); }
                    public void onFinish() { blad.setText(""); }
                }.start();
            }
        }
        else {
            new CountDownTimer(5000, 1000) {
                public void onTick(long millisUntilFinished) { blad.setText("Nazwa kontaktu powinna zawierać od 8 do 64 znaków!"); }
                public void onFinish() { blad.setText(""); }
            }.start();
        }
    }

    public void back(View w) {
        Intent intent = new Intent(this, menu.class);
        startActivity(intent);
    }

    public void usun_kontakt(View w) throws SQLException {
        Spinner spinner_kontakty=findViewById(R.id.spinner_kontakty);

        //lista_numerow.get(spinner_kontakty.getSelectedItemPosition()) // numer rachunku bankowego.
        dbConnect conn=new dbConnect();
        int result=conn.deteleContact(lista_numerow.get(spinner_kontakty.getSelectedItemPosition()));
        if(result==1){
            TextView blad=findViewById(R.id.blad6);
            new CountDownTimer(5000, 1000) {
                public void onTick(long millisUntilFinished) { blad.setText("Kontakt został pozytywnie usunięty!"); }
                public void onFinish() { blad.setText(""); }
            }.start();
        }
        refreshListContacts();
    }

    @Override
    public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {

    }

    @Override
    public void onNothingSelected(AdapterView<?> adapterView) {

    }
}