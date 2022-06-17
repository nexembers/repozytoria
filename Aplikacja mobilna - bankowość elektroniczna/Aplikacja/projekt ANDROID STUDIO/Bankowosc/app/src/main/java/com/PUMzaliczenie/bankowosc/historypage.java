package com.PUMzaliczenie.bankowosc;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.TextView;

import java.sql.ResultSet;
import java.sql.SQLException;

public class historypage extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.historypage);

        TableLayout historia_przelewow=findViewById(R.id.historia_przelew);
        TableRow tr;
        TextView scr1,scr2,scr3,scr4;

        dbConnect conn=new dbConnect();
        try {
            ResultSet rs=conn.getHistoryInTransfer();
            while(rs.next()){
                //for(int i=0;i<10;i++) {
                    tr = new TableRow(this);

                    scr1 = new TextView(this);
                    scr2 = new TextView(this);
                    scr3 = new TextView(this);
                    scr4 = new TextView(this);
                    //scr1.setText((CharSequence) rs.getDate("data"));
                    //scr2.setText("przychodzący");
                    //scr3.setText(rs.getString("dane_nadawcy"));
                    //scr4.setText((int) rs.getFloat("kwota"));
                scr1.setText("1");
                scr2.setText("1");
                scr3.setText("1");
                scr4.setText("1");

                    tr.addView(scr1);
                    tr.addView(scr2);
                    tr.addView(scr3);
                    tr.addView(scr4);
                    historia_przelewow.addView(tr);
                System.out.println("dodano");

                    // pobieranie danych z dwoch tabel, potwarzajace sie wartosci definiowac jako "AS"
                    // wrezucanie wszystkiego do jednego wyniku na rs, sortowanie przez datę!
                //}
            }


        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }

    public void back(View w) {
        Intent intent = new Intent(this, menu.class);
        startActivity(intent);
    }

    public void getmoreinfo(View w) {
        Intent intent = new Intent(this, transferinformation.class);
        startActivity(intent);
    }
}