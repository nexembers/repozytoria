package com.PUMzaliczenie.bankowosc;

import androidx.appcompat.app.AppCompatActivity;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import org.w3c.dom.Text;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;

import javax.xml.transform.Result;

public class menu extends AppCompatActivity {

    @SuppressLint("SetTextI18n")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.menu);

        Intent intent = getIntent();
        String message = intent.getStringExtra(loginpage.EXTRA_MESSAGE);


        dbConnect conn = new dbConnect();

        String zero="0";

        if(session_data.get_defaultbill().equals(zero)){
            try {
                if(conn.getDefaultBill()==1) System.out.println("Ma rachunek główny.");
                else System.out.println("Nie miał rachunku głównego, ale został założony.");

            } catch (SQLException throwables) {
                throwables.printStackTrace();
            }
        }

        TextView maininfo=findViewById(R.id.menu_maininfo);
        TextView srodki=findViewById(R.id.menu_srodki);
        TextView wplywy=findViewById(R.id.menu_wplywy);
        TextView wydatki=findViewById(R.id.menu_wydatki);

        Button przelew=findViewById(R.id.menu_przelew);
        Button kontakty=findViewById(R.id.menu_kontakty);
        Button historia_przelewow=findViewById(R.id.menu_historia);
        Button historia_przelewow2=findViewById(R.id.menu_historia2);
        Button limity=findViewById(R.id.menu_limity);
        Button gotowka=findViewById(R.id.menu_gotowka);
        Button dzieci=findViewById(R.id.menu_dzieci);

        TextView blad=findViewById(R.id.menu_blad3);
        blad.setText("");
        try {
            ResultSet rs=conn.getClientDate();
            while (rs.next()) {
                maininfo.setText("Witaj ponownie!\nTwój numer rachunku: "+rs.getString("nr_rachunku")+".");
                srodki.setText(rs.getString("saldo")+" PLN");

                session_data.set_limitprzelewu(rs.getInt("limit_przelewu"));
                session_data.set_saldo(rs.getFloat("saldo"));

                if(session_data.getRoleID()==1){
                    gotowka.setVisibility(View.INVISIBLE);
                    dzieci.setVisibility(View.INVISIBLE);
                }
                else if(session_data.getRoleID()==2)
                {
                    gotowka.setVisibility(View.VISIBLE);
                    dzieci.setVisibility(View.VISIBLE);
                }


                if(rs.getString("imie")==null || rs.getString("nazwisko")==null || rs.getString("adres")==null){
                    przelew.setVisibility(View.INVISIBLE);
                    kontakty.setVisibility(View.INVISIBLE);
                    historia_przelewow.setVisibility(View.INVISIBLE);
                    historia_przelewow2.setVisibility(View.INVISIBLE);
                    limity.setVisibility(View.INVISIBLE);
                    gotowka.setVisibility(View.INVISIBLE);
                    dzieci.setVisibility(View.INVISIBLE);
                    blad.setText("Uzupełnij swoje dane personalne w zakładce ustawień!");
                }
                else
                {
                    try {
                        ResultSet rs1=conn.getSumOfToday_In();
                        if(rs1.next() && rs1.getRow()>0){
                            wplywy.setText(rs1.getString("val") + " PLN");
                        }

                        ResultSet rs2=conn.getSumOfToday_Out();
                        if(rs2.next() && rs2.getRow()>0){
                            wydatki.setText(rs2.getString("val")+" PLN");
                        }
                    } catch (SQLException throwables) {
                        throwables.printStackTrace();
                    }
                }

            }

        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }




    }

    public void limits(View w) {
        Intent intent = new Intent(this, limitspage.class);
        startActivity(intent);
    }

    public void settings(View w) {
        Intent intent = new Intent(this, settingspage.class);
        startActivity(intent);
    }

    public void addmoney(View w) {
        Intent intent = new Intent(this, addmoneypage.class);
        startActivity(intent);
    }

    public void contacts(View w) {
        Intent intent = new Intent(this, contactspage.class);
        startActivity(intent);
    }

    public void transfer(View w) {
        Intent intent = new Intent(this, transferspage.class);
        startActivity(intent);
    }

    public void childrens(View w) {
        Intent intent = new Intent(this, childrenspage.class);
        startActivity(intent);
    }
    public void history_przychodzace(View w) throws SQLException {

        dbConnect conn=new dbConnect();

        ResultSet rs=conn.getHistoryInTransfer();
        Note.noteArrayList.clear();
        while(rs.next()){


            int id=rs.getInt("id");
            String title="Od: "+rs.getString("imie")+" "+rs.getString("nazwisko");
            String desc="Przelew przychodzący: "+rs.getString("kwota")+" PLN";
            String data=rs.getString("data");

            Note newNote=new Note(id,title,desc,data,"przychodzacy");
            Note.noteArrayList.add(newNote);
            finish();
        }


        Intent intent = new Intent(this, history.class);
        startActivity(intent);
    }

    public void history_wychodzace(View w) throws SQLException {

        dbConnect conn=new dbConnect();

        ResultSet rs=conn.getHistoryOutTransfer();
        Note.noteArrayList.clear();
        while(rs.next()){


            int id=rs.getInt("id");
            String title="Do: "+rs.getString("dane_adresata");
            String desc="Przelew wychodzący: "+rs.getString("kwota")+" PLN";
            String data=rs.getString("data");

            Note newNote=new Note(id,title,desc,data,"wychodzacy");
            Note.noteArrayList.add(newNote);
            finish();
        }


        Intent intent = new Intent(this, history.class);
        startActivity(intent);
    }

}