package controllers;

import database.dbConnect;
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

public class EditDeposits implements Initializable {

    @FXML private ChoiceBox deposits;

    String [][] data=new String[999][3];

    public void createDeposit(ActionEvent event) throws IOException {
        moveClass.move(event,"createDeposit_employee.fxml");
    }

    public void delete_deposit(ActionEvent event) throws IOException, SQLException {
        int selectedIndex = deposits.getSelectionModel().getSelectedIndex();
        if(selectedIndex!=-1) {
            dbConnect conn=new dbConnect();
            conn.updateDeposit_unActive(Integer.parseInt(data[selectedIndex][0]), session_data.getID());
            moveClass.move(event,"Employee_main.fxml");
            info.createDialog("Informacja","Pozytywnie deaktywowano lokatę id "+data[selectedIndex][0]+".",18,"center",450,50);
        }
    }

    public void back(ActionEvent event) throws IOException {
        moveClass.move(event,"Employee_main.fxml");
    }

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        dbConnect conn=new dbConnect();
        try {
            ResultSet rs=conn.getOnlyDeposits();
            int i=0;
            while(rs.next()) {
                deposits.getItems().add(rs.getString("nazwa")+", oprocentowanie: "+rs.getFloat("oprocentowanie")+"%, czas trwania: "+rs.getInt("czas_trwania")+" dni, limit kwoty: "+rs.getInt("limit_kwoty")+" PLN");
                data[i][0]=String.valueOf(rs.getInt("id"));
                i++;
            }
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }
}
