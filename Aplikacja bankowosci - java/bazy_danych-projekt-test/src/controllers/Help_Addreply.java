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

public class Help_Addreply {

    @FXML private TextArea text_reply;

    public void add_reply(ActionEvent event) throws IOException,SQLException {
        String text=text_reply.getText();
        if (text.length()>=16) {
            dbConnect conn=new dbConnect();
            conn.insertNewMessageToQuestion(text, session_data.getID(),storage_data.Messages.getSprawa_id());
            moveClass.move(event,"help.fxml");
            info.createDialog("INFORMACJA","Pozytywnie dodano odpowiedź do pytania.",18,"center",400,75);
        }
        else error.createDialog("Wystąpił błąd!","Odpowiedź powinna zawierać co najmniej\n16 znaków!",18,"center",400,100);
    }

    public void back(ActionEvent event) throws IOException{
        moveClass.move(event,"help.fxml");
    }
}
