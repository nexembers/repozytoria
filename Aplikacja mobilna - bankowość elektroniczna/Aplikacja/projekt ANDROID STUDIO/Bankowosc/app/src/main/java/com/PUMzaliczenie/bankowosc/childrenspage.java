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

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class childrenspage extends AppCompatActivity implements AdapterView.OnItemSelectedListener {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.childrenspage);
        try {
            refreshListChildrens();
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }


    public List<String> lista_dzieci = new ArrayList<String>();
    public List<String> lista_numerow = new ArrayList<String>();

    public void refreshListChildrens() throws SQLException {

        lista_dzieci.clear();
        lista_numerow.clear();
        Spinner spinner_dzieci=findViewById(R.id.spinner_dzieci);
        dbConnect conn=new dbConnect();
        ResultSet rs=conn.getChildrens();
        while(rs.next()){
            if(rs.getString("imie")==null) {
                lista_dzieci.add("PESEL dziecka: "+rs.getString("identyfikator")+".");
                lista_numerow.add("Identyfikator dziecka: "+rs.getString("identyfikator")+"\nImię i nazwisko do uzupełnienia przez dziecko.\nSaldo konta dziecka: "+rs.getFloat("saldo")+" PLN\nNr rachunku dziecka: "+rs.getString("nr_rachunku")+".");
            }
            else
            {
                lista_dzieci.add("PESEL dziecka: "+rs.getString("identyfikator")+", "+rs.getString("imie")+" "+rs.getString("nazwisko"));
                lista_numerow.add("Identyfikator dziecka: "+rs.getString("identyfikator")+"\nImię i nazwisko dziecka: "+rs.getString("imie")+" "+rs.getString("nazwisko")+"\nSaldo konta dziecka: "+rs.getFloat("saldo")+" PLN\nNr rachunku dziecka: "+rs.getString("nr_rachunku")+".");
            }

        }
        spinner_dzieci.setOnItemSelectedListener(this);
        ArrayAdapter<String> aa=new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item,lista_dzieci);
        aa.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner_dzieci.setAdapter(aa);
    }


    public void addchild(View w) throws NoSuchAlgorithmException, SQLException {

        EditText dodaj_peseldziecka=findViewById(R.id.dodaj_peseldziecka);
        EditText dodaj_haslodziecka=findViewById(R.id.dodaj_haslodziecka);

        TextView blad=findViewById(R.id.blad7);

        String pesel=dodaj_peseldziecka.getText().toString();
        String haslo=dodaj_haslodziecka.getText().toString();

        if(pesel.length()==11) {
            if(haslo.length()>3) {
                MessageDigest digest = MessageDigest.getInstance("SHA-256");
                byte[] hash = digest.digest(haslo.getBytes(StandardCharsets.UTF_8));
                StringBuffer hexString = new StringBuffer();

                for (int i = 0; i < hash.length; i++) {
                    String hex = Integer.toHexString(0xff & hash[i]);
                    if(hex.length() == 1) hexString.append('0');
                    hexString.append(hex);
                }
                dbConnect conn=new dbConnect();

                int id = conn.createUser(pesel,hexString.toString(),1);
                if(id>0) {
                    dodaj_peseldziecka.setText("");
                    dodaj_haslodziecka.setText("");
                    new CountDownTimer(5000, 1000) {
                        public void onTick(long millisUntilFinished) { blad.setText("Konto dziecka zostało założone!"); }
                        public void onFinish() { blad.setText(""); }
                    }.start();
                    refreshListChildrens();
                }
                else
                {
                    new CountDownTimer(5000, 1000) {
                        public void onTick(long millisUntilFinished) { blad.setText("Błąd."); }
                        public void onFinish() { blad.setText(""); }
                    }.start();
                }
            }
            else {
                new CountDownTimer(5000, 1000) {
                    public void onTick(long millisUntilFinished) { blad.setText("PESEL musi zawierać dokładnie 11 cyfr!!"); }
                    public void onFinish() { blad.setText(""); }
                }.start();
            }
        }
        else {
            new CountDownTimer(5000, 1000) {
                public void onTick(long millisUntilFinished) { blad.setText("Hasło musiz zawierać co najmniej 4 znaki oraz maksymalnie 16 znaków!"); }
                public void onFinish() { blad.setText(""); }
            }.start();
        }
    }

    public void back(View w) {
        Intent intent = new Intent(this, menu.class);
        startActivity(intent);
    }

    @Override
    public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
        Spinner spinner_dzieci=findViewById(R.id.spinner_dzieci);
        TextView info_dziecko=findViewById(R.id.info_dziecko);

        info_dziecko.setText(lista_numerow.get(spinner_dzieci.getSelectedItemPosition()));
    }

    @Override
    public void onNothingSelected(AdapterView<?> adapterView) {

    }
}