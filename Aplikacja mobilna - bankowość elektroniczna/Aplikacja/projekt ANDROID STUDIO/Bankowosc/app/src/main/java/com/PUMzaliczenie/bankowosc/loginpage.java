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
import java.util.Timer;
import java.util.TimerTask;


public class loginpage extends AppCompatActivity {
    public static final String EXTRA_MESSAGE = "com.PUMzaliczenie.bankowosc.MESSAGE";
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.loginpage);

        Intent intent = getIntent();
        String message = intent.getStringExtra(loginpage.EXTRA_MESSAGE);
            new CountDownTimer(6000, 1000) {
                TextView blad=findViewById(R.id.blad);
                public void onTick(long millisUntilFinished) { blad.setText(message); }
                public void onFinish() { blad.setText(""); }
            }.start();

    }


    public void logIn(View view) throws SQLException, NoSuchAlgorithmException {
        EditText login=findViewById(R.id.login_identyfikator);
        EditText password=findViewById(R.id.password_identyfikator);
        TextView blad=findViewById(R.id.blad);

        if(login.length()==11 && password.length()>3) {
            dbConnect conn = new dbConnect();

            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getText().toString().getBytes(StandardCharsets.UTF_8));
            StringBuffer hexString = new StringBuffer();

            for (int i = 0; i < hash.length; i++) {
                String hex = Integer.toHexString(0xff & hash[i]);
                if(hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            
            int id = conn.loginToAccount(login.getText().toString(),hexString.toString());
            if(id>0){
                session_data.sesja(true,id,session_data.getRoleID());
                Intent intent = new Intent(this, menu.class);
                startActivity(intent);
            }
            else {
                new CountDownTimer(5000, 1000) {
                    public void onTick(long millisUntilFinished) { blad.setText("Podano nieprawidłowe dane logowania do konta! Zweryfikuj je i spróbuj ponownie!"); }
                    public void onFinish() { blad.setText(""); }
                }.start();
            }
        }
        else {
            new CountDownTimer(5000, 1000) {
                public void onTick(long millisUntilFinished) { blad.setText("Nie podano identyfikatora lub hasła do konta!"); }
                public void onFinish() { blad.setText(""); }
            }.start();
        }

    }

    public void back(View w) {
        Intent intent = new Intent(this, defaultpage.class);
        startActivity(intent);
    }

}