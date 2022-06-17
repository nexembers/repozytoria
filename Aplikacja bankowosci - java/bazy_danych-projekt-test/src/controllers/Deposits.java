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
import storage_data.Deposit;
import storage_data.session_data;

import java.io.IOException;
import java.net.URL;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.ResourceBundle;

public class Deposits implements Initializable {
    @FXML private TableView<Deposit> deposits;
    @FXML private TableColumn<Deposit, String> nazwa_deposits;
    @FXML private TableColumn<Deposit, Float> oprocentowanie_deposits;
    @FXML private TableColumn<Deposit, String> data_utworzenia_deposits;
    @FXML private TableColumn<Deposit, String> data_zakonczenia_deposits;
    @FXML private TableColumn<Deposit, Integer> saldo_deposits;
    ObservableList<Deposit> DepositsList= FXCollections.observableArrayList();

    public void initialize(URL url, ResourceBundle resourceBundle) {
        dbConnect conn=new dbConnect();
        DepositsList.clear();
        nazwa_deposits.setCellValueFactory(new PropertyValueFactory<>("nazwa"));
        oprocentowanie_deposits.setCellValueFactory(new PropertyValueFactory<>("oprocentowanie"));
        data_utworzenia_deposits.setCellValueFactory(new PropertyValueFactory<>("data_utworzenia"));
        data_zakonczenia_deposits.setCellValueFactory(new PropertyValueFactory<>("data_zakonczenia"));
        saldo_deposits.setCellValueFactory(new PropertyValueFactory<>("saldo"));
        try {
            ResultSet rs = conn.getDeposits(session_data.getID());
            while (rs.next()) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                DepositsList.add(new Deposit(rs.getString("nazwa"),rs.getFloat("oprocentowanie"),sdf.format(rs.getTimestamp("data_otwarcia")),sdf.format(rs.getTimestamp("data_zakonczenia")),rs.getInt("saldo"),rs.getInt("id"),rs.getInt("czas_trwania")));
            }
            deposits.setItems(DepositsList);
        }
        catch(SQLException error)
        {
            System.out.println(error);
        }
    }

    public void delete_deposit(ActionEvent event) throws IOException, ParseException, SQLException {
        Deposit clicked = deposits.getSelectionModel().getSelectedItem();
        if (clicked != null) {
            if (clicked.getDbid()>0) {
                Date date1=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss").parse(clicked.getData_zakonczenia());
                Date date2=new Date(); // aktualna data

                if(date2.compareTo(date1)>0) error.createDialog("Wystąpił bląd!","Wygląda na to, że lokata została już zakończona.\nNaciśnij więc przycisk odpowiedzialny za jej zakończenie.",18,"center",500,100);
                else {
                    int deposit_id=clicked.getDbid();
                    int deposit_balance=clicked.getSaldo();
                    dbConnect conn=new dbConnect();
                    conn.depositDelete(deposit_id,deposit_balance,session_data.getID());
                    moveClass.move(event,"deposits.fxml");
                    info.createDialog("INFORMACJA","Pozytywnie zlikwidowano lokatę id "+deposit_id+"\nDo Twojego głównego rachunku dodano kwotę "+deposit_balance+" PLN",18,"center",520,80);
                }
            }
        }
    }

    public void get_deposit(ActionEvent event) throws IOException, ParseException, SQLException {
        Deposit clicked = deposits.getSelectionModel().getSelectedItem();
        if (clicked != null) {
            if (clicked.getDbid()>0) {
                Date date1=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss").parse(clicked.getData_zakonczenia());
                Date date2=new Date(); // aktualna data

                if(date2.compareTo(date1)>0) {
                    int deposit_id=clicked.getDbid();
                    double deposit_balance=clicked.getSaldo();
                    double zysk=deposit_balance * 0.01*clicked.getOprocentowanie() / 365 * clicked.getCzas_trwania() * 0.81;
                    // saldo * 0.01 * oprocentowanie (0.01*x = tj. [nominalne oprocentowanie]) / 365 (czas trwania średnio roku) * czas_trwania (lokaty w dniachd) * 0.81 (podatek belki 19%)

                    DecimalFormat decimalFormat = new DecimalFormat("#0.##");
                    String format = decimalFormat.format(zysk); // podanie zysku jako liczba 2 miejsca po przecinku

                    dbConnect conn=new dbConnect();
                    conn.updateDepositEndTime(deposit_id,deposit_balance+zysk,session_data.getID());
                    moveClass.move(event,"deposits.fxml");
                    info.createDialog("INFORMACJA","Pozytywnie zakończono lokatę id "+deposit_id+"\nDo Twojego głównego rachunku dodano kwotę "+deposit_balance+" PLN\nZysk z lokaty: "+format+" PLN",18,"center",520,125);
                }
                else error.createDialog("Wystąpił bląd!","Ta lokata nie jest jeszcze zakończona!\nMożesz ją zakończyć przed czasem, ale nie otrzymasz odsetek!",18,"center",525,80);
            }
        }
    }

    public void create_deposit(ActionEvent event) throws IOException, SQLException {
        dbConnect conn=new dbConnect();
        if (conn.getMainBill(session_data.getID())==1) {
            moveClass.move(event,"createDeposit.fxml");
        }
        else error.createDialog("Wystąpił bład!","Nie posiadasz rachunku głównego w naszym banku!\nSkontaktuj się z pracownikiem banku celem założenia rachunku głównego!",18,"center",625,90);
    }

    public void back(ActionEvent event) throws IOException{
        moveClass.move(event,"main.fxml");
    }
}