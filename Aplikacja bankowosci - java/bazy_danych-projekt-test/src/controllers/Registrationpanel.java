package controllers;

import database.dbConnect;
import dialogboxes.error;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.TextField;
import project.moveClass;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;

public class Registrationpanel {
    @FXML private TextField imie_tf;
    @FXML private TextField nazwisko_tf;
    @FXML private TextField pesel_tf;
    @FXML private TextField haslo_tf;

    public void zarejestruj(ActionEvent event) throws IOException,NoSuchAlgorithmException {
        String imie = imie_tf.getText();
        String nazwisko = nazwisko_tf.getText();
        String pesel = pesel_tf.getText();
        String haslo = haslo_tf.getText();

        if(imie.length()>1 && imie.length()<=32) {
            if(nazwisko.length()>1 && nazwisko.length() <=32) {
                if(pesel.length()==11 && Long.parseLong(pesel)>0) {
                    if (haslo.length() >= 4 && haslo.length()<=32) {
                        dbConnect connect=new dbConnect();
                        try {

                            MessageDigest digest = MessageDigest.getInstance("SHA-256");
                            byte[] hash = digest.digest(haslo.getBytes(StandardCharsets.UTF_8));
                            StringBuffer hexString = new StringBuffer();

                            for (int i = 0; i < hash.length; i++) {
                                String hex = Integer.toHexString(0xff & hash[i]);
                                if(hex.length() == 1) hexString.append('0');
                                hexString.append(hex);
                            }

                            int i=connect.createUser(imie,nazwisko,pesel,hexString.toString());
                            if(i>9) {
                                moveClass.move(event,"loginpanel_client.fxml");
                                error.createDialog("Informacja","Gratulujemy!\nUdało się pomyślnie zarejestrować.\nWprowadź teraz ponownie hasło, aby się zalogować.\n\nTwój identyfikator do logowania: "+i,18,"center",500,175);
                            }
                            else if(i==1)  error.createDialog("Wystąpił błąd!","Przykro nam!\nDane zostały wprowadzone nieprawidłowo!",18,"center",530,70);
                            else if(i==0) error.createDialog("Wystąpił błąd!","Przykro nam!\nUżytkownik o podanym numerze PESEL jest już zarejestrowany!",18,"center",530,70);
                        }
                        catch(SQLException | NoSuchAlgorithmException error) { System.out.println(error); }
                    } else error.createDialog("Wystąpił błąd!","Hasło musi być dłuższe niż 3 znaki\noraz krótsze niż 32 znaki!",18,"center",450,75);
                } else error.createDialog("Wystąpił błąd!","Numer PESEL musi zawierać dokładnie 9 cyfr!",18,"center",450,50);
            } else error.createDialog("Wystąpił błąd!","Nazwisko musi być dłuższe niż 1 znak\noraz krótsze niż 32 znaki!",18,"center",450,75);
        } else error.createDialog("Wystąpił błąd!","Imię musi być dłuższe niż 1 znak\noraz krótsze niż 32 znaki!",18,"center",450,75);
    }

    public void back(ActionEvent event) throws IOException {
        moveClass.move(event,"loginpanel_client.fxml");
    }
}
