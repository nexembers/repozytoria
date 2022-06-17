package controllers;

import database.dbConnect;
import dialogboxes.error;
import dialogboxes.info;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import project.moveClass;
import storage_data.session_data;

import java.io.IOException;
import java.net.URL;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ResourceBundle;

public class CreateDeposit implements Initializable {

    @FXML private ChoiceBox selects;
    @FXML private Label balance_mainBill;
    @FXML private TextField balance_deposit;

    public int[][] data=new int[999][5];

    public void back(ActionEvent event) throws IOException {
        moveClass.move(event,"deposits.fxml");
    }

    public int getInt() throws NumberFormatException {
        try {
            return Integer.parseInt(balance_deposit.getText());
        }
        catch (NumberFormatException e) {
            return 0;
        }
    }

    public int getValue() {
        if(balance_deposit.getText().length()>0) {
            if(getInt()>0) {
                return getInt();
            }
            else error.createDialog("Wystąpił błąd!","Wprowadzono niedopuszczalna wartosc!",18,"center",400,50);

        }
        else error.createDialog("Wystąpił błąd!","Nie wprowadzono kwoty!",18,"center",400,50);
        return -1;
    }

    public void create_deposit(ActionEvent event) throws IOException, SQLException {
        int selectedIndex = selects.getSelectionModel().getSelectedIndex();
        if(selectedIndex!=-1) {
           if(getValue()>0) {
               if (getValue() > data[selectedIndex][2]) {
                   error.createDialog("Wystąpił błąd!", "Przekroczono dopuszczalny limit na zalozenie\nlokaty! Limit to " + data[selectedIndex][2] + " PLN!", 18, "center", 450, 100);
                   return;
               }
               if (getValue() > data[1][3]) {
                   error.createDialog("Wystąpił błąd!", "Nie masz wystarczajacej ilosci gotowki\nna swoim rachunku bankowym!", 18, "center", 450, 100);
                   return;
               }
               dbConnect conn = new dbConnect();
               conn.insertDeposit(data[selectedIndex][1], getValue(), data[selectedIndex][4], session_data.getID());
               moveClass.move(event, "deposits.fxml");
               info.createDialog("INFORMACJA", "Lokata zostala pomyslnie utworzona.", 18, "center", 450, 50);
           } else System.out.println("blad: "+Integer.parseInt(balance_deposit.getText()));
        } else error.createDialog("Wystąpił błąd!","Nie zaznaczono rodzaju lokaty!",18,"center",300,55);
    }


    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        dbConnect conn=new dbConnect();
        int i=0;

        try {
            ResultSet rs=conn.getInfoAboutDeposits(session_data.getID());
            while(rs.next()) {
                // dalszy kod.
                balance_mainBill.setText("Stan konta rachunku głównego: "+rs.getInt("saldo"));
                selects.getItems().add(rs.getString("nazwa")+" na okres "+rs.getInt("czas_trwania")+" dni, oprocentowanie "+rs.getFloat("oprocentowanie")+"%, limit kwoty: "+rs.getInt("limit_kwoty")+" PLN");
                data[i][1]=rs.getInt("id");
                data[i][2]=rs.getInt("limit_kwoty");
                data[i][3]=rs.getInt("saldo");
                data[i][4]=rs.getInt("czas_trwania");
                i=i+1;
            }


        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }
}
