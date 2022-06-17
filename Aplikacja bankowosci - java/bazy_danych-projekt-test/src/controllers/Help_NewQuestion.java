package controllers;

import database.dbConnect;
import dialogboxes.error;
import dialogboxes.info;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.TextArea;
import project.moveClass;
import storage_data.session_data;

import java.io.IOException;
import java.sql.SQLException;

public class Help_NewQuestion {

    @FXML private TextArea title_question;
    @FXML private TextArea text_question;

    public void create_question(ActionEvent event) throws IOException,SQLException {
        String title=title_question.getText();
        String question=text_question.getText();

        if(title.length()>=4) {
            if(question.length()>=16) {
                dbConnect conn=new dbConnect();
                conn.insertQuestion(session_data.getID(),title,question);
                moveClass.move(event,"help.fxml");
                info.createDialog("INFORMACJA","Twoje pytanie zostało utworzone!\nPoczekaj na odpowiedź Pracownika banku.",18,"center",400,100);
            }
            else error.createDialog("Wystąpił bład!","W treści pytania musisz umieścić\nco najmniej 16 znaków!",18,"center",325,100);
        } else error.createDialog("Wystąpił bład!","W tytule musisz umieścić\nco najmniej 4 znaki!",18,"center",325,100);
    }

    public void back(ActionEvent event) throws IOException{
        moveClass.move(event,"help.fxml");
    }
}
