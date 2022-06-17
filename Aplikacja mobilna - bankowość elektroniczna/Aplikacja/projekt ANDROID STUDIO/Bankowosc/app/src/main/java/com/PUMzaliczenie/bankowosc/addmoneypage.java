package com.PUMzaliczenie.bankowosc;

import androidx.appcompat.app.AppCompatActivity;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class addmoneypage extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.addmoneypage);
    }

    @SuppressLint("SetTextI18n")
    public void pobierzsrodki(View w) throws SQLException {
        TextView blad=findViewById(R.id.blad5);

        Date nowDate = new Date();

        @SuppressLint("SimpleDateFormat")
        SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
        System.out.println("Data w formacie [yyyy-MM-dd]: " + sdf1.format(nowDate));

        dbConnect conn=new dbConnect();
        int wynik=conn.getMoney(java.sql.Date.valueOf(sdf1.format(nowDate)));
        if(wynik==1){
            blad.setText("Przykro mi! Dziś wykorzystałeś już swój pakiet bonusu 1000.00PLN!\nSpróbuj ponownie jutro.");
        }
        else if(wynik==2){
            blad.setText("Do Twojego salda został dodany 1000.00 PLN. Możesz je rozgospodarować naprzykład przyznając kieszonkowe dzieciom.");
        }
    }

    public void back(View w) {
        Intent intent = new Intent(this, menu.class);
        startActivity(intent);
    }
}