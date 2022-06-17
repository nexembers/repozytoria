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
import javafx.scene.control.TextField;
import javafx.scene.control.cell.PropertyValueFactory;
import project.moveClass;
import storage_data.Deposit;
import storage_data.Exchanges;
import storage_data.session_data;

import java.io.IOException;
import java.net.URL;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ResourceBundle;

public class EditExchangeRatesEmployee implements Initializable {

    @FXML private TableView<Exchanges> kursy_walut_tabela;
    @FXML private TableColumn<Exchanges, String> nazwa_waluty;
    @FXML private TableColumn<Exchanges, String> skrot_waluty;
    @FXML private TableColumn<Exchanges, String> symbol_waluty;
    @FXML private TableColumn<Exchanges, Float> kurskupna_waluty;
    @FXML private TableColumn<Exchanges, Float> kurssprzedazy_waluty;
    @FXML private TextField kurs_kupna;
    @FXML private TextField kurs_sprzedazy;


    ObservableList<Exchanges> ExchangesList= FXCollections.observableArrayList();

    public void back(ActionEvent event) throws IOException {
        moveClass.move(event,"Employee_main.fxml");
    }

    public void edit_course(ActionEvent event) throws IOException, SQLException {
        Exchanges clicked = kursy_walut_tabela.getSelectionModel().getSelectedItem();
        if (clicked != null) {
            if(kurs_kupna.getText().length()>0 && kurs_sprzedazy.getText().length()>0) {
                if(Float.parseFloat(kurs_kupna.getText())>0 && Float.parseFloat(kurs_sprzedazy.getText())>0) {
                    String getNazwa=clicked.getNazwa();
                    String getSymbol=clicked.getSymbol();
                    dbConnect conn=new dbConnect();
                    conn.updateExchange(getNazwa,getSymbol, session_data.getID(),Float.parseFloat(kurs_kupna.getText()),Float.parseFloat(kurs_sprzedazy.getText()));
                    moveClass.move(event,"editExchangeRates_Employee.fxml");
                    info.createDialog("Informacja","Pozytywnie wprowadzono zmiany dla waluty\no nazwie "+getNazwa+".",18,"center",450,75);
                }
            }
        }   else error.createDialog("Wystąpił bład!","Nie zaznaczono żadnej waluty!",18,"center",400,50);
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
