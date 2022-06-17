package controllers;

import database.dbConnect;
import dialogboxes.error;
import dialogboxes.info;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.ChoiceBox;
import project.moveClass;
import storage_data.session_data;

import java.io.IOException;
import java.net.URL;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ResourceBundle;

public class createBill_employee implements Initializable {

    @FXML private ChoiceBox type_bill;

    int[][] date=new int[999][1];

    public void create_bill(ActionEvent event) throws IOException, SQLException {
        int selectedIndex = type_bill.getSelectionModel().getSelectedIndex();
        if(selectedIndex!=-1) {
            dbConnect conn=new dbConnect();
            if(date[selectedIndex][0]==1) {
                int result=conn.getMainBill(session_data.getAcocountCheck_data());
                if(result==1){
                    error.createDialog("Wystąpił błąd!","Użytkownik posiada już zalożone konto główne!",18,"center",450,50);
                    return;
                }
            }
            conn.insertNewBill(session_data.getAcocountCheck_data(),session_data.getID(),date[selectedIndex][0]);
            moveClass.move(event,"info_account_employee.fxml");
            info.createDialog("Informacja","Udało się utworzyć nowy rachunek bankowy!",18,"center",500,50);
        }
    }

    public void back(ActionEvent event) throws IOException {
        moveClass.move(event,"info_account_employee.fxml");
    }

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        dbConnect conn=new dbConnect();
        int i=0;
        try {
            ResultSet rs=conn.getTypeBills();
            while(rs.next()) {
                type_bill.getItems().add(rs.getInt("id")+") "+rs.getString("nazwa"));

                date[i][0]=rs.getInt("id");
                i++;
            }
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }
}
