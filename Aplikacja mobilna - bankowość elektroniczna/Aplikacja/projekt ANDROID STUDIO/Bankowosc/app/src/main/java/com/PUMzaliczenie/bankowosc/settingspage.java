package com.PUMzaliczenie.bankowosc;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.ResultSet;
import java.sql.SQLException;

public class settingspage extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.settingspage);

        EditText imie=findViewById(R.id.opcje_imie);
        EditText nazwisko=findViewById(R.id.opcje_nazwisko);
        EditText adres=findViewById(R.id.opcje_adres);
        Button zmiendane=findViewById(R.id.button_zmiendane);

        dbConnect conn=new dbConnect();
        try{
            ResultSet rs=conn.getClientDate();
            if(rs.next()){
                if(rs.getString("imie").length()>0) imie.setText(rs.getString("imie"));
                if(rs.getString("nazwisko").length()>0) nazwisko.setText(rs.getString("nazwisko"));
                if(rs.getString("adres").length()>0) adres.setText(rs.getString("adres"));

                if(rs.getString("imie")==null) imie.setText("");
                if(rs.getString("nazwisko")==null) nazwisko.setText("");
                if(rs.getString("adres")==null) adres.setText("");

                    if((imie.getText().length()>3) && (nazwisko.getText().length()>3) && (adres.getText().length()>6)) {
                        imie.setEnabled(false);
                        nazwisko.setEnabled(false);
                        adres.setEnabled(false);
                        zmiendane.setVisibility(View.INVISIBLE);
                    }
            }
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    public void changepassword(View w) throws NoSuchAlgorithmException, SQLException {
        EditText _haslo=findViewById(R.id.opcje_biezacehaslo);
        EditText _haslo_powtorzenie=findViewById(R.id.opcje_nowehaslo);
        EditText _nowehaslo=findViewById(R.id.opcje_nowehaslopowtorz);
        TextView blad=findViewById(R.id.blad3);

        String biezacehaslo=_haslo.getText().toString();
        String nowehaslo=_haslo_powtorzenie.getText().toString();
        String nowehaslopowtorz=_nowehaslo.getText().toString();

        if(biezacehaslo.length()>3 && nowehaslo.length()>3 && nowehaslopowtorz.length()>3) {
            if(nowehaslo.equals(nowehaslopowtorz)) {
                MessageDigest digest = MessageDigest.getInstance("SHA-256");
                byte[] hash = digest.digest(biezacehaslo.getBytes(StandardCharsets.UTF_8));
                StringBuffer hexString = new StringBuffer();

                for (int i = 0; i < hash.length; i++) {
                    String hex = Integer.toHexString(0xff & hash[i]);
                    if(hex.length() == 1) hexString.append('0');
                    hexString.append(hex);
                }

                MessageDigest digest2 = MessageDigest.getInstance("SHA-256");
                byte[] hash2 = digest2.digest(nowehaslo.getBytes(StandardCharsets.UTF_8));
                StringBuffer hexString2 = new StringBuffer();

                for (int i = 0; i < hash2.length; i++) {
                    String hex2 = Integer.toHexString(0xff & hash2[i]);
                    if(hex2.length() == 1) hexString2.append('0');
                    hexString2.append(hex2);
                }

                dbConnect conn=new dbConnect();
                if(conn.getPasswordAndChange(hexString.toString(),hexString2.toString())==1){
                    new CountDownTimer(5000, 1000) {
                        public void onTick(long millisUntilFinished) {
                            blad.setText("Hasło zostało zmienione!");
                            _haslo.setText("");
                            _haslo_powtorzenie.setText("");
                            _nowehaslo.setText("");
                        }
                        public void onFinish() { blad.setText(""); }
                    }.start();
                }
                else{
                    new CountDownTimer(5000, 1000) {
                        public void onTick(long millisUntilFinished) { blad.setText("Podano nieprawidłowe hasło bieżące!"); }
                        public void onFinish() { blad.setText(""); }
                    }.start();
                }

            }
            else
            {
                new CountDownTimer(5000, 1000) {
                    public void onTick(long millisUntilFinished) { blad.setText("Nowe hasła nie zgadzają się ze sobą!"); }
                    public void onFinish() { blad.setText(""); }
                }.start();
            }
        }
        else
        {
            new CountDownTimer(5000, 1000) {
                public void onTick(long millisUntilFinished) { blad.setText("Hasło nie posiada co najmniej trzech znaków!"); }
                public void onFinish() { blad.setText(""); }
            }.start();
        }

    }

    public void changepersonaldata(View w) {
        dbConnect conn=new dbConnect();

        EditText imie=findViewById(R.id.opcje_imie);
        EditText nazwisko=findViewById(R.id.opcje_nazwisko);
        EditText adres=findViewById(R.id.opcje_adres);
        TextView blad=findViewById(R.id.blad3);

        if(imie.getText().length()>=3 && nazwisko.getText().length()>=2 && adres.getText().length()>6)
        {
            try{
                conn.updatePersonalData(imie.getText().toString(),nazwisko.getText().toString(),adres.getText().toString());
            }
            catch (Exception e){
                e.printStackTrace();
            }

            Intent intent = new Intent(this, settingspage.class);
            startActivity(intent);
            blad.setText("Dane uaktualnione!");
        }
        else
        {
            new CountDownTimer(5000, 1000) {
                public void onTick(long millisUntilFinished) { blad.setText("Wymogi dotyczące długości imienia lub nazwiska lub adresu nie zostały spełnione!"); }
                public void onFinish() { blad.setText(""); }
            }.start();
        }
    }

    public void back(View w) {
        Intent intent = new Intent(this, menu.class);
        startActivity(intent);
    }
}