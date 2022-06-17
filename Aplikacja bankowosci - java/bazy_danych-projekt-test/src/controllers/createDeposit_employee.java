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

public class createDeposit_employee {

    @FXML private TextField deposit_name;
    @FXML private TextField deposit_procent;
    @FXML private TextField deposit_time;
    @FXML private TextField deposit_limit;

    public void back(ActionEvent event) throws IOException {
        moveClass.move(event,"EditDeposits.fxml");
    }

    public void create_deposit(ActionEvent event) throws IOException, SQLException {
        // todo
        if(deposit_name.getText().length()>=4 && deposit_name.getText().length()<=128) {
            if(deposit_procent.getText().length()>=1 && deposit_procent.getText().length()<=4 && Float.parseFloat(deposit_procent.getText())>0 && Float.parseFloat(deposit_procent.getText())<5) {
                if(deposit_time.getText().length()>=2 && deposit_time.getText().length()<=5 && Integer.parseInt(deposit_time.getText())>0) {
                    if(deposit_limit.getText().length()>=4 && Integer.parseInt(deposit_limit.getText())>0) {
                        dbConnect conn=new dbConnect();
                        conn.insertNewDeposit(deposit_name.getText(),Float.parseFloat(deposit_procent.getText()),Integer.parseInt(deposit_time.getText()),Integer.parseInt(deposit_limit.getText()), session_data.getID());
                        moveClass.move(event,"editDeposits.fxml");
                        info.createDialog("Informacja","Pozytywnie utworzono nową lokatę dla użytkowników!",18,"center",500,50);
                    } else error.createDialog("Wystąpił błąd!","Limit kwoty lokaty nie może być mniejszy niż 1000zł!",18,"center",500,75);
                } else error.createDialog("Wystąpił błąd!","Czas trwania lokaty nie może być krótszy niż 10 dni!",18,"center",500,75);
            } else error.createDialog("Wystąpił błąd!","Oprocentowanie musi być większe od 0%,\nale nie może być wyższe niż 5%!",18,"center",450,75);
        } else error.createDialog("Wystąpił błąd!","Nazwa lokaty musi posiadać co najmniej 4 znaki,\nale nie może być dłuższa niż 128 znaków!",18,"center",450,75);
    }
}
