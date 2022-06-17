package com.PUMzaliczenie.bankowosc;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;

public class history extends AppCompatActivity {

    private ListView noteListView;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.history);
        initWidgets();
        setNoteAdapter();
        setOnClickListener();
    }

    private void initWidgets() {
        noteListView=findViewById(R.id.noteListView);
    }

    private void setNoteAdapter() {
        NoteAdapter noteAdapter=new NoteAdapter(getApplicationContext(),Note.noteArrayList);
        noteListView.setAdapter(noteAdapter);
    }

    public void back(View v){
        Intent intent = new Intent(this, menu.class);
        startActivity(intent);
    }

    private void setOnClickListener(){
        noteListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int position, long l) {
                Note selectedNote=(Note) noteListView.getItemAtPosition(position);
                Intent intent = new Intent(view.getContext(), transferinformation.class);
                intent.putExtra("id", selectedNote.getId());
                intent.putExtra("type", selectedNote.getTyp());
                intent.putExtra("from", selectedNote.getTitle());
                startActivity(intent);
            }
        });
    }
}