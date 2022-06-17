package com.PUMzaliczenie.bankowosc;

import androidx.appcompat.app.AppCompatActivity;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import org.w3c.dom.Text;

import java.sql.SQLException;

public class limitspage extends AppCompatActivity {

    @SuppressLint("SetTextI18n")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.limitspage);

        TextView limit=findViewById(R.id.limit_tekst);

        limit.setText(session_data.get_limitprzelewu()+".00 PLN");



    }

    public void changelimit(View w) throws SQLException {
        EditText ustawienie_limit=findViewById(R.id.opcja_limit);
        TextView blad=findViewById(R.id.blad4);
        if(ustawienie_limit.getText().length()>0) {
            if(Integer.parseInt(ustawienie_limit.getText().toString())>0 && Integer.parseInt(ustawienie_limit.getText().toString())<25000) {
                dbConnect conn=new dbConnect();
                conn.updateLimit(Integer.parseInt(ustawienie_limit.getText().toString()));
                session_data.set_limitprzelewu(Integer.parseInt(ustawienie_limit.getText().toString()));
                Intent intent = new Intent(this, limitspage.class);
                startActivity(intent);
            }
            else
            {
                new CountDownTimer(5000, 1000) {
                    @SuppressLint("SetTextI18n")
                    public void onTick(long millisUntilFinished) { blad.setText("Limit jednorazowego przelewu powinien zawierać się w zakresie kwot od 0 do 25000 PLN!"); }
                    public void onFinish() { blad.setText(""); }
                }.start();
            }
        }
        else
        {
            new CountDownTimer(5000, 1000) {
                public void onTick(long millisUntilFinished) { blad.setText("Należy podać limit jednorazowego przelewu!"); }
                public void onFinish() { blad.setText(""); }
            }.start();
        }
    }

    public void back(View w) {
        Intent intent = new Intent(this, menu.class);
        startActivity(intent);
    }
}