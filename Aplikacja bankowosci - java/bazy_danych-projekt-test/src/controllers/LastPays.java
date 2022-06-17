package controllers;

import database.dbConnect;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import project.moveClass;
import storage_data.Deposit;
import storage_data.LastPay;
import storage_data.session_data;

import java.io.IOException;
import java.net.URL;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.ResourceBundle;

public class LastPays implements Initializable {
    @FXML
    private TableView<LastPay> lastPays;
    @FXML private TableColumn<LastPay, String> rodzaj;
    @FXML private TableColumn<LastPay, Date> data;
    @FXML private TableColumn<LastPay, String> rachunek;
    @FXML private TableColumn<LastPay, String> tytul;
    @FXML private TableColumn<LastPay, Float> kwota;
    ObservableList<LastPay> LastPaysList= FXCollections.observableArrayList();

    public void initialize(URL url, ResourceBundle resourceBundle) {
        dbConnect conn=new dbConnect();
        LastPaysList.clear();
        rodzaj.setCellValueFactory(new PropertyValueFactory<>("rodzaj"));
        data.setCellValueFactory(new PropertyValueFactory<>("data"));
        rachunek.setCellValueFactory(new PropertyValueFactory<>("rachunek"));
        tytul.setCellValueFactory(new PropertyValueFactory<>("tytul"));
        kwota.setCellValueFactory(new PropertyValueFactory<>("kwota"));
        try {
            ResultSet rs = conn.getPaysIn(session_data.getID());
            while (rs.next()) {
                System.out.println("mam kurwa wynik");
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                LastPaysList.add(new LastPay("Przychodzący",sdf.format(rs.getTimestamp("data")),rs.getString("rachunek_nadawcy"),rs.getString("tytul"),rs.getFloat("kwota")));
            }
            ResultSet rs2 = conn.getPaysOut(session_data.getID());
            while (rs2.next()) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                LastPaysList.add(new LastPay("Wychodzący",sdf.format(rs2.getTimestamp("data")),rs2.getString("rachunek_odbiorcy"),rs2.getString("tytul"),rs2.getFloat("kwota")));
            }
            lastPays.setItems(LastPaysList);
        }
        catch(SQLException error)
        {
            System.out.println(error);
        }
    }

    public void back(ActionEvent event) throws IOException {
        moveClass.move(event,"main.fxml");
    }
}
