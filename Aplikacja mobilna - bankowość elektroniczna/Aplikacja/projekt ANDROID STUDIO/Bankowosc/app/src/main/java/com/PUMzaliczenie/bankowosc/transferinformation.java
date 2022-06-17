package com.PUMzaliczenie.bankowosc;

import androidx.appcompat.app.AppCompatActivity;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

import java.sql.ResultSet;
import java.sql.SQLException;

public class transferinformation extends AppCompatActivity {

    TextView tekst;

    String nazwa_odbiorcy,nr_rachunku,tytul;
    Float kwota;

    @SuppressLint("SetTextI18n")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.transferinformation);

        tekst=findViewById(R.id.info);
        tekst.setText("");

        Intent intent = getIntent();
        Bundle bundle = intent.getExtras();

        if(bundle != null){
            int id = bundle.getInt("id");
            String typ = bundle.getString("type");
            String from = bundle.getString("from");

            dbConnect conn=new dbConnect();
            if(typ.equals("przychodzacy")) {
                try {
                    ResultSet rs=conn.getHistory_one_In(id);
                    if(rs.next()){
                        tekst.setText("SZCZEGÓŁY PRZELEWU\n\n\nID przelewu: "+rs.getInt("id")+"\nRachunek nadawcy: "+rs.getString("rachunek_nadawcy")+"\n"+from+"\nKwota przelewu: "+rs.getString("kwota")+" PLN\nTytuł przelewu: "+rs.getString("tytul")+"\nData przelewu: "+rs.getString("data"));
                        nazwa_odbiorcy=from;
                        nr_rachunku=rs.getString("rachunek_nadawcy");
                    }
                } catch (SQLException throwables) {
                    throwables.printStackTrace();
                }
            }
            else if(typ.equals("wychodzacy")) {
                try {
                    ResultSet rs=conn.getHistory_one_Out(id);
                    if(rs.next()){
                        tekst.setText("SZCZEGÓŁY PRZELEWU\n\n\nID przelewu: "+rs.getInt("id")+"\nRachunek odbiorcy: "+rs.getString("rachunek_odbiorcy")+"\nKwota przelewu: "+rs.getString("kwota")+" PLN\nTytuł przelewu: "+rs.getString("tytul")+"\nData przelewu: "+rs.getString("data"));
                        nazwa_odbiorcy=from;
                        nr_rachunku=rs.getString("rachunek_odbiorcy");
                    }
                } catch (SQLException throwables) {
                    throwables.printStackTrace();
                }
            }
        }
    }

    public void resend_transfer(View w){
        Intent intent = new Intent(this, transferspage.class);
        intent.putExtra("nazwa_odbiorcy", nazwa_odbiorcy);
        intent.putExtra("rachunek_odbiorcy", nr_rachunku);
        startActivity(intent);
    }

    public void back(View w) {
        Intent intent = new Intent(this, history.class);
        startActivity(intent);
    }
}