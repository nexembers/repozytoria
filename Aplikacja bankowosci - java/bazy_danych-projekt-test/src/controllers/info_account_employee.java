package controllers;

import database.dbConnect;
import dialogboxes.info;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import project.moveClass;
import storage_data.session_data;
import java.io.IOException;
import java.net.URL;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ResourceBundle;

public class info_account_employee implements Initializable {

    @FXML private Label label1;
    @FXML private Label label2;
    @FXML private Label label3;
    @FXML private Label label4;
    @FXML private Label label5; // dane personalne!
    @FXML private Button lock_account;
    @FXML private Button create_bill;



    public void back(ActionEvent event) throws IOException {
        moveClass.move(event,"user_info.fxml");
    }

    public void create_bill(ActionEvent event) throws IOException {
        moveClass.move(event,"createBill_employee.fxml");
    }

    public void lock_account(ActionEvent event) throws IOException, SQLException {
        // todo!
        dbConnect conn=new dbConnect();
        conn.updatelockAccountByEmployee(session_data.getAcocountCheck_data(),session_data.getID());
        moveClass.move(event,"user_info.fxml");
        info.createDialog("Informacja","Zablokowano konto użytkownika id "+session_data.getAcocountCheck_data()+"!",18,"center",500,50);
    }


    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {
        dbConnect conn=new dbConnect();
        ResultSet rs= null;
        try {
            rs = conn.getMainInfo_Employee(session_data.getAcocountCheck_data());
            if(rs.next()) {
                String wynik=rs.getString(1);
                wynik = wynik.replace("[", "");
                wynik = wynik.replace("]", "");
                wynik = wynik.replace(" ", "");
                String[] result = wynik.split(",");

                if(result.length>0) {
                    label1.setText("Użytkownik posiada "+Integer.parseInt(result[0])+" kont bankowych w naszym banku.");
                    label2.setText("Użytkownik posiada "+Integer.parseInt(result[1])+" lokat w naszym banku.");
                    label3.setText("Użytkownik posiada "+Integer.parseInt(result[2])+" zadanych pytań do Pracowników banku.");
                    label4.setText("Od założenia konta, wygenerowano łącznie "+Integer.parseInt(result[3])+" aktywności na koncie użytkownika.");
                    if(Integer.valueOf(result[9])==3) {
                        label5.setText(result[4]+" "+result[5]+", pesel: "+result[6]+"\nTo konto jest zablokowane!");
                        create_bill.setVisible(false);
                        lock_account.setVisible(false);
                    }
                    else label5.setText(result[4]+" "+result[5]+", pesel: "+result[6]+"\nnr tel. "+result[7]+", email: "+result[8]);
                }
            }
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }

    }
}
