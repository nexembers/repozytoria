package controllers;

import database.dbConnect;
import dialogboxes.error;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.TextField;
import project.moveClass;
import storage_data.session_data;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;

public class user_info {

    @FXML private TextField info_user;

    public void check_info(ActionEvent event) throws IOException, SQLException {
        if(info_user.getText().length()>0 && Long.parseLong(info_user.getText())>0) {
            dbConnect conn=new dbConnect();
            ResultSet rs=null;
            if(info_user.getText().length()==9) rs=conn.getUserByIdentyfikator(info_user.getText());
            else if(info_user.getText().length()==11) rs=conn.getUserByPesel(info_user.getText());
            else { error.createDialog("Wystąpił błąd!","Wprowadzony ciąg znaków jest nieprawidłowy!",18,"center",450,50); return; }

            if(rs!=null) {
                while(rs.next()) {
                    session_data.setAccountCheck_data(rs.getInt("id"));
                    moveClass.move(event,"info_account_employee.fxml");
                }
            } else error.createDialog("Wystąpił błąd!","Nie odnaleziono użytkownika po wprowadzeniu\npowyższych danych!",18,"center",400,75);
        } else error.createDialog("Wystąpił błąd!","Wprowadzono niepoprawny format danych wejściowych!",18,"center",450,50);
    }

    public void back(ActionEvent event) throws IOException {
        moveClass.move(event,"Employee_main.fxml");
        session_data.setAccountCheck_data(0);
    }
}