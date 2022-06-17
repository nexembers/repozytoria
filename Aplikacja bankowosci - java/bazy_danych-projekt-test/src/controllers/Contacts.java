package controllers;

import database.dbConnect;
import dialogboxes.error;
import dialogboxes.info;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.TextField;
import project.moveClass;
import storage_data.Transfer_temporaryData;
import storage_data.session_data;

import java.io.IOException;
import java.net.URL;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ResourceBundle;

public class Contacts implements Initializable {

    @FXML private ChoiceBox contacts;
    @FXML private TextField edit_name;

    public String[][] data=new String[999][3];

    public void back(ActionEvent event) throws IOException {
        moveClass.move(event,"main.fxml");
    }

    public void delete_contact(ActionEvent event) throws IOException, SQLException {
        int selectedIndex = contacts.getSelectionModel().getSelectedIndex();
        if(selectedIndex!=-1) {
            dbConnect conn=new dbConnect();
            conn.dropContact(Integer.parseInt(data[selectedIndex][0]),session_data.getID());
            moveClass.move(event,"contacts.fxml");
            info.createDialog("INFORMACJA", "Kontakt zostal pomyslnie usuniety.", 18, "center", 300, 50);

        } else error.createDialog("Wystąpił błąd!","Nie zaznaczono kontaktu!",18,"center",300,50);
    }

    public void edit_contact(ActionEvent event) throws IOException, SQLException {
        int selectedIndex = contacts.getSelectionModel().getSelectedIndex();
        if(selectedIndex!=-1) {
            if(edit_name.getText().length()>=4 && edit_name.getText().length()<=64) {
                dbConnect conn=new dbConnect();
                conn.updateContactName(Integer.parseInt(data[selectedIndex][0]),edit_name.getText(),session_data.getID());
                moveClass.move(event,"contacts.fxml");
                info.createDialog("INFORMACJA","Pozytywnie zmieniono opis kontaktu.",18,"center",330,50);
            }
        } else error.createDialog("Wystąpił błąd!","Nie zaznaczono kontaktu!",18,"center",300,50);

    }

    public void create_contact(ActionEvent event) throws IOException {
        moveClass.move(event,"createContact.fxml");
    }

    public void send_contact(ActionEvent event) throws IOException {
        int selectedIndex = contacts.getSelectionModel().getSelectedIndex();
        if(selectedIndex!=-1) {
            new Transfer_temporaryData(data[selectedIndex][1],data[selectedIndex][2]);
            moveClass.move(event,"transfer.fxml");
        }
    }

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        dbConnect conn=new dbConnect();
        int i=0;
        try {
            ResultSet rs = conn.getContacts(session_data.getID());
            while (rs.next()) {
                contacts.getItems().add(rs.getString("nazwa")+"   |   rachunek nr: "+rs.getString("uzytkownicy_rachunki_odbiorca"));
                data[i][0]= String.valueOf(rs.getInt("id"));
                data[i][1]= String.valueOf(rs.getString("nazwa"));
                data[i][2]= String.valueOf(rs.getString("uzytkownicy_rachunki_odbiorca"));
                i=i+1;
            }
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }
}
