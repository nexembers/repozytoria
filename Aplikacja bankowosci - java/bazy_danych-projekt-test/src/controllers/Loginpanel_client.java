package controllers;

import database.dbConnect;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.RadioButton;
import javafx.scene.control.TextField;
import project.moveClass;
import storage_data.session_data;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;

public class Loginpanel_client {
    @FXML
    private TextField login;
    @FXML
    private TextField password;
    @FXML
    private RadioButton pracownik;

    public void zaloguj(ActionEvent event) throws SQLException, NoSuchAlgorithmException {
        dbConnect conn = new dbConnect();
        int wybor=1;
        if(pracownik.isSelected()) wybor=2;
        try {


            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getText().getBytes(StandardCharsets.UTF_8));
            StringBuffer hexString = new StringBuffer();

            for (int i = 0; i < hash.length; i++) {
                String hex = Integer.toHexString(0xff & hash[i]);
                if(hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }

            String password=hexString.toString();
            int id = conn.loginToAccount(login.getText(),password,wybor);

            if(id!=0) {
                System.out.println("Udało się zalogować na konto o id "+id+".");
                session_data.sesja(true,id,wybor);

                if(session_data.getRoleID()==2) {
                    moveClass.move(event,"Employee_main.fxml");
                    return;
                }
                moveClass.move(event,"main.fxml");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public void zarejestruj(ActionEvent event) throws IOException {
        moveClass.move(event,"registrationpanel.fxml");
    }
}
