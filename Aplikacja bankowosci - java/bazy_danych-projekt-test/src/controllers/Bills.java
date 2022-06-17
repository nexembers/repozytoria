package controllers;

import database.dbConnect;
import dialogboxes.error;
import dialogboxes.info;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import project.moveClass;
import storage_data.Bill;
import storage_data.Transfer_temporaryData;
import storage_data.session_data;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URL;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.ResourceBundle;

public class Bills implements Initializable {
    @FXML private TableView<Bill> Billstable;
    @FXML private TableColumn<Bill, String> nazwa_bills;
    @FXML private TableColumn<Bill, String> numer_bills;
    @FXML private TableColumn<Bill, Date> data_bills;
    @FXML private TableColumn<Bill, BigDecimal> saldo_bills;
    @FXML private TableColumn<Bill, String> waluta_bills;
    ObservableList<Bill> BillsList= FXCollections.observableArrayList();

    public void initialize(URL url, ResourceBundle resourceBundle) {
        dbConnect conn=new dbConnect();
        BillsList.clear();
        nazwa_bills.setCellValueFactory(new PropertyValueFactory<>("nazwa"));
        numer_bills.setCellValueFactory(new PropertyValueFactory<>("numer"));
        data_bills.setCellValueFactory(new PropertyValueFactory<>("data"));
        saldo_bills.setCellValueFactory(new PropertyValueFactory<>("saldo"));
        waluta_bills.setCellValueFactory(new PropertyValueFactory<>("waluta"));
        try {
            ResultSet rs = conn.getBills(session_data.getID());
            while (rs.next()) {
                BillsList.add(new Bill(rs.getString("nazwa"),rs.getString("nr_rachunku"),rs.getDate("data_zalozenia"),rs.getBigDecimal("saldo"),rs.getString("nazwa_skrot"),rs.getInt("id"),rs.getInt("uzytkownicy_rachunki.id")));
            }
            Billstable.setItems(BillsList);
        }
        catch(SQLException error)
        {
            System.out.println(error);
        }
    }

    public void delete_bill(ActionEvent event) throws IOException,SQLException {
        Bill clicked = Billstable.getSelectionModel().getSelectedItem();
        if (clicked != null) {
            if (clicked.getSaldo().floatValue()==0) {
                if (clicked.getIDBill()!=1) // rachunek główny!
                {
                    dbConnect conn=new dbConnect();
                    conn.lockBill(clicked.getIDBill(),session_data.getID());
                    moveClass.move(event,"Bills.fxml");
                    info.createDialog("INFORMACJA","Pomyslnie zlikwidowano rachunek bankowy\no id "+clicked.getIDBill()+".",18,"center",400,100);
                }
                else error.createDialog("Wystąpił błąd!","Nie mozesz usunac tego rachunku bankowego,\ngdyz jest to Twój główny rachunek!",18,"center",420,100);
            }
            else error.createDialog("Wystąpił błąd!","Nie mozesz usunac tego rachunku bankowego,\ngdyz posiadasz na nim dodatni stan konta!",18,"center",420,100);
        }
        else error.createDialog("Wystąpił błąd!","Nie zaznaczono zadnego rachunku bankowego!",18,"center",420,50);
    }

    public void createBill(ActionEvent event) throws IOException{
        moveClass.move(event,"help.fxml");
    }

    public void make_transfer(ActionEvent event) throws IOException{
        Bill clicked = Billstable.getSelectionModel().getSelectedItem();
        if (clicked != null) {
            new Transfer_temporaryData("","",clicked.getDbid());
            moveClass.move(event,"transfer.fxml");
        }
    }

    public void back(ActionEvent event) throws IOException {
        moveClass.move(event,"main.fxml");
    }
}
