package controllers;

import database.dbConnect;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.TextField;
import dialogboxes.error;
import project.moveClass;
import storage_data.session_data;

import java.io.IOException;
import java.net.URL;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.NumberFormat;
import java.text.ParsePosition;
import java.util.ResourceBundle;

public class Editpersonaldata implements Initializable {

    @FXML private TextField ulica;
    @FXML private TextField nr_domu;
    @FXML private TextField kod_poczt;
    @FXML private TextField miejscowosc;
    @FXML private TextField email;
    @FXML private TextField tel;

    public void back(ActionEvent event) throws IOException{
        if(session_data.getRoleID()==1) {
            moveClass.move(event,"Main.fxml");
        }
        else if(session_data.getRoleID()==2) {
            moveClass.move(event,"Employee_main.fxml");
        }
    }

    public static boolean isNumeric(String str) {
        ParsePosition pos = new ParsePosition(0);
        NumberFormat.getInstance().parse(str, pos);
        return str.length() == pos.getIndex();
    }

    public void zapisz_dane(ActionEvent event) throws SQLException {
        if (ulica.getText().length()>=3) {
            if (nr_domu.getText().length()>=1) {
                if (kod_poczt.getText().length()==6 && kod_poczt.getText().contains("-")) {
                    if (miejscowosc.getText().length()>=2) {
                        if (email.getText().length()>=5 && email.getText().contains("@")) {
                            if (tel.getText().length()==9 && isNumeric(tel.getText())) {
                                System.out.println("ok");
                                dbConnect conn=new dbConnect();
                                conn.updatePersonalData(ulica.getText(),nr_domu.getText(),kod_poczt.getText(),miejscowosc.getText(),email.getText(),Integer.valueOf(tel.getText()));
                            }
                            else error.createDialog("Wyst??pi?? b????d!","Podany numer telefonu jest za kr??tki\nlub podano niepoprawny format nr. tel!!",18,"center",450,150);
                        }
                        else error.createDialog("Wyst??pi?? b????d!","Podany adres email jest za kr??tki\nlub nie posiada koniecznych znak??w!",18,"center",450,150);
                    }
                    else error.createDialog("Wyst??pi?? b????d!","Podana miejscowo???? jest za kr??tka!",18,"center",325,100);
                }
                else error.createDialog("Wyst??pi?? b????d!","Podany kod pocztowy jest za kr??tki\nlub zosta?? wprowadzony niepoprawnie!",18,"center",400,100);
            }
            else error.createDialog("Wyst??pi?? b????d!","Podany numer domu jest za kr??tki!",18,"center",325,50);
        }
        else error.createDialog("Wyst??pi?? b????d!","Podana ulica jest za kr??tka!",18,"center",275,50);
    }

    public void initialize(URL url, ResourceBundle resourceBundle) {
        dbConnect conn=new dbConnect();
        try {
            ResultSet rs=conn.getClientDate(session_data.get_identitiy());
            if(rs.next()){
                ulica.setText((rs.getString(1)));
                nr_domu.setText((rs.getString(2)));
                kod_poczt.setText((rs.getString(3)));
                miejscowosc.setText((rs.getString(4)));
                email.setText((rs.getString(5)));
                tel.setText((rs.getString(6)));
            }
            else System.out.println("nie ma wyniku");
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }
}
