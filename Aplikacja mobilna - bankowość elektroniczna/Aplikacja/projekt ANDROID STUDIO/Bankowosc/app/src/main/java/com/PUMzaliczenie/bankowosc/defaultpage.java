package com.PUMzaliczenie.bankowosc;

import androidx.appcompat.app.AppCompatActivity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;


public class defaultpage extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.defaultpage);
    }

    public void login_page(View v){
        Intent intent = new Intent(this, loginpage.class);
        startActivity(intent);
    }

    public void register_page(View v){
        Intent intent = new Intent(this, registerpage.class);
        startActivity(intent);
    }
}


/**
 TextView text=(TextView)findViewById(R.id.textView9);

 dbConnect conn=new dbConnect();
 try {
 ResultSet rs = conn.getUserByPesel();
 while (rs.next()) {
 text.setText("mordo jest git");
 }
 }
 catch(SQLException error)
 {
 error.printStackTrace();
 }
 **/