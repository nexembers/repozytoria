package controllers;

import database.dbConnect;
import dialogboxes.error;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import project.moveClass;
import storage_data.session_data;
import java.io.IOException;
import java.net.URL;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ResourceBundle;
import javafx.fxml.Initializable;

public class Main implements Initializable {

    @FXML private Label message;
    @FXML private Label il_rachunkow;
    @FXML private Label il_lokat;
    @FXML private Label il_spraw;
    @FXML private Label il_aktywnosci;

    @FXML private Button editpersonaldata;
    @FXML private Button kursy_walut;
    @FXML private Button pomoc;
    @FXML private Button rachunki;
    @FXML private Button deposits;
    @FXML private Button contacts;
    @FXML private Button make_transfer;

    public void logout(ActionEvent event) throws IOException {
        session_data.logoutAccount();
        moveClass.move(event,"loginpanel_client.fxml");
    }

    public void editpersonaldata(ActionEvent event) throws IOException{ moveClass.move(event,"editpersonaldata.fxml"); }
    public void kursy_walut(ActionEvent event) throws IOException { moveClass.move(event,"Exchangerates.fxml"); }
    public void pomoc(ActionEvent event) throws IOException { moveClass.move(event,"help.fxml"); }
    public void rachunki(ActionEvent event) throws IOException { moveClass.move(event,"bills.fxml"); }
    public void deposits(ActionEvent event) throws IOException{ moveClass.move(event,"deposits.fxml"); }
    public void contacts(ActionEvent event) throws IOException{ moveClass.move(event,"contacts.fxml"); }
    public void make_transfer(ActionEvent event) throws IOException { moveClass.move(event,"transfer.fxml"); }
    public void lastPays(ActionEvent event) throws IOException { moveClass.move(event,"lastPay.fxml"); }



    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        if(session_data.getRoleID()==3) {
            error.createDialog("Wystąpił błąd!","Twoje konto jest zablokowane!\nMożesz jedynie się wylogować!",18,"center",400,50);
            editpersonaldata.setVisible(false);
            kursy_walut.setVisible(false);
            pomoc.setVisible(false);
            rachunki.setVisible(false);
            deposits.setVisible(false);
            contacts.setVisible(false);
            make_transfer.setVisible(false);
            return;
        }

        dbConnect conn=new dbConnect();
        try {
            ResultSet rs=conn.getMainInfo(session_data.getID());
            if(rs.next()) {
                String wynik=rs.getString(1);
                wynik = wynik.replace("[", "");
                wynik = wynik.replace("]", "");
                wynik = wynik.replace(" ", "");
                String[] result = wynik.split(",");

                if(result.length>0) {
                    message.setText("Twój unikalny identyfikator konta to "+session_data.get_identitiy()+".");
                    il_rachunkow.setText("Posiadasz "+Integer.parseInt(result[0])+" kont bankowych w naszym banku.");
                    il_lokat.setText("Posiadasz "+Integer.parseInt(result[1])+" lokat w naszym banku.");
                    il_spraw.setText("Posiadasz "+Integer.parseInt(result[2])+" zadanych pytań do Pracowników banku.");
                    il_aktywnosci.setText("Od założenia konta, wygenerowano łącznie "+Integer.parseInt(result[3])+" aktywności na Twoim koncie.");
                }
            }
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }
}
