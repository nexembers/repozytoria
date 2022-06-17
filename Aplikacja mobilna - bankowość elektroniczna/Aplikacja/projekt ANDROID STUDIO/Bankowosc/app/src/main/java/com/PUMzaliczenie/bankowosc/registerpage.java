package com.PUMzaliczenie.bankowosc;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;

public class registerpage extends AppCompatActivity {
    public static final String EXTRA_MESSAGE = "com.PUMzaliczenie.bankowosc.MESSAGE";
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.registerpage);
    }

    public void registerAccount(View w) throws SQLException, NoSuchAlgorithmException {
        EditText login=findViewById(R.id.rejestracja_identyfikator);
        EditText password=findViewById(R.id.rejestracja_haslo);
        EditText passwordreply=findViewById(R.id.rejestracja_haslo_powtorz);
        TextView blad=findViewById(R.id.blad2);

        int id=0;
        if(login.length()==11 && password.length()>3 && passwordreply.length()>3) {
            dbConnect conn = new dbConnect();

            String pass1=password.getText().toString();
            String pass2=passwordreply.getText().toString();
            if(pass1.equals(pass2)) {

                MessageDigest digest = MessageDigest.getInstance("SHA-256");
                byte[] hash = digest.digest(pass1.getBytes(StandardCharsets.UTF_8));
                StringBuffer hexString = new StringBuffer();

                for (int i = 0; i < hash.length; i++) {
                    String hex = Integer.toHexString(0xff & hash[i]);
                    if(hex.length() == 1) hexString.append('0');
                    hexString.append(hex);
                }

                id = conn.createUser(login.getText().toString(),hexString.toString(),2);
                if(id>0){
                    blad.setText("Udało Ci się utworzyć konto rodzica! Twój identyfikator to "+id+" (numer pesel).\nZaloguj się do konta.");
                }
                else {
                    new CountDownTimer(5000, 1000) {
                        public void onTick(long millisUntilFinished) { blad.setText("Użytkownik o tym numerze PESEL już istnieje!"); }
                        public void onFinish() { blad.setText(""); }
                    }.start();
                }
            }
            else {
                new CountDownTimer(5000, 1000) {
                    public void onTick(long millisUntilFinished) { blad.setText("Podane hasła różnią się od siebie!"); }
                    public void onFinish() { blad.setText(""); }
                }.start();
            }
        }
        else {
            new CountDownTimer(5000, 1000) {
                public void onTick(long millisUntilFinished) { blad.setText("Nie podano identyfikatora lub hasła!"); }
                public void onFinish() { blad.setText(""); }
            }.start();
        }

        if(id>=1){
            Intent intent = new Intent(this, loginpage.class);
            String message = "Gratulacje, udało Cię się założyć konto rodzica!\nZaloguj się numerem PESEL podanym podczas rejestracji.";
            intent.putExtra(EXTRA_MESSAGE, message);
            startActivity(intent);
        }
    }

    public void back(View w) {
        Intent intent = new Intent(this, defaultpage.class);
        startActivity(intent);
    }

}