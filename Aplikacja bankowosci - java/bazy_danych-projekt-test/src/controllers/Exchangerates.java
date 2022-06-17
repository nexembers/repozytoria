package controllers;

import database.dbConnect;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import project.moveClass;


import java.io.IOException;
import java.net.URL;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ResourceBundle;


import javafx.fxml.Initializable;
import storage_data.Exchanges;

public class Exchangerates implements Initializable {

    @FXML private TableView<Exchanges> kursy_walut_tabela;
    @FXML private TableColumn<Exchanges, String> nazwa_waluty;
    @FXML private TableColumn<Exchanges, String> skrot_waluty;
    @FXML private TableColumn<Exchanges, String> symbol_waluty;
    @FXML private TableColumn<Exchanges, Float> kurskupna_waluty;
    @FXML private TableColumn<Exchanges, Float> kurssprzedazy_waluty;

    ObservableList<Exchanges> ExchangesList= FXCollections.observableArrayList();

    public void back(ActionEvent event) throws IOException{
        moveClass.move(event,"main.fxml");
    }

    public void initialize(URL url, ResourceBundle resourceBundle) {
        dbConnect conn = new dbConnect();
        ExchangesList.clear();
        nazwa_waluty.setCellValueFactory(new PropertyValueFactory<>("nazwa"));
        skrot_waluty.setCellValueFactory(new PropertyValueFactory<>("skrot"));
        symbol_waluty.setCellValueFactory(new PropertyValueFactory<>("symbol"));
        kurskupna_waluty.setCellValueFactory(new PropertyValueFactory<>("kupno"));
        kurssprzedazy_waluty.setCellValueFactory(new PropertyValueFactory<>("sprzedaz"));
        try {
            ResultSet rs = conn.getExchangerates();
            while (rs.next()) {
                ExchangesList.add(new Exchanges(rs.getString("nazwa"),rs.getString("nazwa_skrot"),rs.getString("symbol"),rs.getFloat("kurs_kupna"),rs.getFloat("kurs_sprzedazy")));
            }
            kursy_walut_tabela.setItems(ExchangesList);
        }
        catch(SQLException error)
        {
            System.out.println(error);
        }
    }
}