package controllers;

import database.dbConnect;
import dialogboxes.error;
import dialogboxes.info;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.TextField;
import project.moveClass;
import storage_data.session_data;

import java.io.IOException;
import java.sql.SQLException;

public class createContact {

    @FXML private TextField bill_numer;
    @FXML private TextField contact_desc;

    public void back(ActionEvent event) throws IOException {
        moveClass.move(event,"contacts.fxml");
    }

    public long getInt() throws NumberFormatException {
        try {
            long number=Long.parseLong(bill_numer.getText());
            return number;
        }
        catch (NumberFormatException e) {
            return -1;
        }
    }

    public void create_contact(ActionEvent event) throws IOException, SQLException {
        if(bill_numer.getText().length()==16 && getInt()>0) {
            if(contact_desc.getText().length()>=4 && contact_desc.getText().length()<=64) {
                dbConnect conn=new dbConnect();
                int numb=conn.insertNewContact(bill_numer.getText(),contact_desc.getText(), session_data.getID());
                if(numb==2) {
                    moveClass.move(event,"contacts.fxml");
                    info.createDialog("INFORMACJA","Pozytywnie dodano nowy kontakt do listy kontaktów.",18,"center",450,50);
                }
                else if(numb==0) error.createDialog("Wystąpił błąd!","Kontakt o podanym numerze rachunku już istnieje!",18,"center",450,50);
                else error.createDialog("Wystąpił błąd!","Podany numer rachunku nie istnieje!",18,"center",400,50);
            } else error.createDialog("Wystąpił błąd!","Opis nie może być krótszy niż 4 znaki\noraz dłuższy niż 64 znaki!",18,"center",500,75);
        } else error.createDialog("Wystąpił błąd!","Numer rachunku bankowego musi zawierać dokładnie 16 cyfr!",18,"center",550,50);
    }
}
