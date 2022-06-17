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

public class Transfer implements Initializable {

    @FXML private ChoiceBox sender_bills;
    @FXML private TextField receiver_data;
    @FXML private TextField receiver_billNumber;
    @FXML private TextField receiver_desc;
    @FXML private TextField receiver_value;

    String[][] data=new String[999][3];


    public void back(ActionEvent event) throws IOException {
        moveClass.move(event,"main.fxml");
    }

    public long getLong(TextField Field) throws NumberFormatException {
        try {
            return Long.parseLong(Field.getText());
        }
        catch (NumberFormatException e) {
            return 0;
        }
    }
    public float getFloat(TextField Field) throws NumberFormatException {
        try {
            return Float.parseFloat(Field.getText());
        }
        catch (NumberFormatException e) {
            return 0;
        }
    }

    public void make_a_transfer(ActionEvent event) throws IOException, SQLException {
        int selectedIndex=sender_bills.getSelectionModel().getSelectedIndex();
        if(selectedIndex!=-1) {
            if(receiver_data.getText().length()>=4 && receiver_data.getText().length()<=64) {
                if(receiver_billNumber.getText().length()==16 && getLong(receiver_billNumber)>0) {
                    if(receiver_desc.getText().length()>=8 && receiver_desc.getText().length()<=128) {
                        if(receiver_value.getText().length()>=1 && getFloat(receiver_value)>=0.01 && receiver_value.getText().length()<=9) {
                            if(Long.parseLong(receiver_billNumber.getText())!=Long.parseLong(data[selectedIndex][0])) {
                                if(Float.parseFloat(data[selectedIndex][2])>=getFloat(receiver_value)) {


                                    dbConnect conn=new dbConnect();
                                    conn.updateDeposits_Transfer(session_data.getID(),receiver_billNumber.getText(),getFloat(receiver_value),data[selectedIndex][0]); // update gotówki nadawcy, odbiorcy
                                    moveClass.move(event,"transfer.fxml");
                                    info.createDialog("Informacja","Pozytywnie zlecono przelew na kwotę "+getFloat(receiver_value)+" PLN.",18,"center",500,50);

                                    conn.insertOutTransfer(receiver_billNumber.getText(),receiver_data.getText(),Float.parseFloat(receiver_value.getText()),receiver_desc.getText(), Float.parseFloat(data[selectedIndex][2])-Float.parseFloat(receiver_value.getText()), Integer.parseInt(data[selectedIndex][1]),session_data.getID());
                                    conn.insertInTransfer(data[selectedIndex][0],Float.parseFloat(receiver_value.getText()),receiver_desc.getText(),session_data.getID(),receiver_billNumber.getText());

                                } else error.createDialog("Wystąpił błąd!","Nie posiadasz wystarczającej ilości pieniędzy na koncie,\naby móc zlecić docelowy przelew!",18,"center",450,75);
                            } else error.createDialog("Wystąpił błąd!","Nie możesz przelać pieniędzy na ten sam rachunek,\nz którego chcesz wykonać przelew!",18,"center",450,75);
                        } else error.createDialog("Wystąpił błąd!","Kwota transakcji musi być większa od 0.00 PLN!",18,"center",400,50);
                    } else error.createDialog("Wystąpił błąd!","Opis musi zawierać co najmniej 8 znaków\ni nie może być dłuższy niż 128 znaków!",18,"center",400,75);
                } else error.createDialog("Wystąpił błąd!","Numer rachunku bankowego adresata musi zawierać\nco najmniej 16 cyfr!",18,"center",450,75);
            } else error.createDialog("Wystąpił błąd!","Dane adresata powinny zawierać co najmniej 4 znaki,\nale nie więcej niż 64 znaki.",18,"center",450,75);
        } else error.createDialog("Wystąpił błąd!","Nie wybrano rachunku nadawcy przelewu!",18,"center",375,50);
    }

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) { // auto load data from mysql
        dbConnect conn=new dbConnect();
        try {
            ResultSet rs=conn.getBills(session_data.getID());
            int i=0;
            while(rs.next()) {
                sender_bills.getItems().add(rs.getString("nazwa")+"  |  nr rachunku: "+rs.getString("nr_rachunku")+"  |  saldo: "+rs.getFloat("saldo")+" PLN");
                data[i][0]=rs.getString("nr_rachunku");
                data[i][1]=rs.getString("uzytkownicy_rachunki.id");
                data[i][2]=rs.getString("saldo");
                i++;
            }
            data[998][0]=String.valueOf(i);
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }

        if(Transfer_temporaryData.getContact_bill()!=null) {
            receiver_data.setText(Transfer_temporaryData.getName_contact());
            receiver_billNumber.setText(Transfer_temporaryData.getContact_bill());
        }
        if(Transfer_temporaryData.getBill_sender()!=0) {
            for(int i=0;i<Integer.valueOf(data[998][0]);i++) {
                if(Integer.valueOf(data[i][1])==Transfer_temporaryData.getBill_sender()) {
                    sender_bills.getSelectionModel().select(i);
                    break;
                }
            }
        }
        Transfer_temporaryData.setNull();
    }
}
