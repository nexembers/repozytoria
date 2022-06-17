package controllers;

import com.mysql.cj.protocol.Message;
import database.dbConnect;
import dialogboxes.info;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.*;
import javafx.scene.control.cell.PropertyValueFactory;
import project.moveClass;
import storage_data.Help;
import storage_data.Messages;
import storage_data.session_data;

import java.io.IOException;
import java.net.URL;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ResourceBundle;

public class help implements Initializable {
    @FXML private Button create_question;
    @FXML private Label info1;
    @FXML private Label info2;

    //***************************************

    @FXML private TableView<Help> pomoc;
    @FXML private TableColumn<Help, String> id_pomoc;
    @FXML private TableColumn<Help, String> data_pomoc;
    @FXML private TableColumn<Help, String> temat_pomoc;
    @FXML private TableColumn<Help, String> zakonczono_pomoc;
    @FXML private TableColumn<Help, Float> ilosc_pomoc;

    //***************************************

    @FXML private TableView<Messages> odpowiedzi;
    @FXML private TableColumn<Messages, String> odpowiedz_id;
    @FXML private TableColumn<Messages, String> odpowiedz_data;
    @FXML private TableColumn<Messages, String> odpowiedz_imie;
    @FXML private TableColumn<Messages, String> odpowiedz_nazwisko;
    @FXML private TableColumn<Messages, String> odpowiedz_identyfikator;
    @FXML private TextArea odpowiedz_wiadomosc;
    @FXML private Button odpowiedz;
    @FXML private Button end_question;

    //***************************************

    ObservableList<Help> HelpList= FXCollections.observableArrayList();
    ObservableList<Messages> MessagesList= FXCollections.observableArrayList();

    public void initialize(URL url, ResourceBundle resourceBundle) {
        dbConnect conn = new dbConnect();

        odpowiedzi.setVisible(false);
        odpowiedz_wiadomosc.setVisible(false);
        odpowiedz.setVisible(false);
        end_question.setVisible(false);

        pomoc.setVisible(true);
        info1.setVisible(true);
        info2.setVisible(true);
        create_question.setVisible(true);

        HelpList.clear();
        id_pomoc.setCellValueFactory(new PropertyValueFactory<>("id"));
        data_pomoc.setCellValueFactory(new PropertyValueFactory<>("data"));
        temat_pomoc.setCellValueFactory(new PropertyValueFactory<>("temat"));
        zakonczono_pomoc.setCellValueFactory(new PropertyValueFactory<>("zakonczono"));
        ilosc_pomoc.setCellValueFactory(new PropertyValueFactory<>("ilosc"));
        try {
            ResultSet rs=null;
            if(session_data.getRoleID()==1) {
                rs = conn.getHelp();
            }
            else if(session_data.getRoleID()==2) {
                rs = conn.getHelp_Employee();
                info2.setVisible(false);
                create_question.setVisible(false);
            }

            while (rs.next()) {
                String end="tak";
                if(rs.getDate("data_zakonczenia")==null) end="nie";
                HelpList.add(new Help(rs.getInt("id"),rs.getDate("data_otwarcia"),end,rs.getString("temat"),rs.getInt(5)));
            }
            pomoc.setItems(HelpList);
        }
        catch(SQLException error)
        {
            System.out.println(error);
        }
    }

    public void click() throws SQLException {
        Help zapytanie = pomoc.getSelectionModel().getSelectedItem();
        if (zapytanie != null) {
            int zam=zapytanie.getId();

            dbConnect conn=new dbConnect();
            ResultSet rs=conn.getMessageHelp(zam);

            if (rs!=null) {
                pomoc.setVisible(false);
                info1.setVisible(false);
                info2.setVisible(false);
                create_question.setVisible(false);

                odpowiedzi.setVisible(true);
                odpowiedz_wiadomosc.setVisible(true);


                info1.setVisible(true);
                info1.setText("Odpowiedzi do pytania o id "+zam);

                Messages.setSprawa_id(zam);

                MessagesList.clear();
                odpowiedz_id.setCellValueFactory(new PropertyValueFactory<>("odpowiedz_id"));
                odpowiedz_data.setCellValueFactory(new PropertyValueFactory<>("odpowiedz_data"));
                odpowiedz_imie.setCellValueFactory(new PropertyValueFactory<>("odpowiedz_imie"));
                odpowiedz_nazwisko.setCellValueFactory(new PropertyValueFactory<>("odpowiedz_nazwisko"));
                odpowiedz_identyfikator.setCellValueFactory(new PropertyValueFactory<>("odpowiedz_identyfikator"));
                while(rs.next()){
                    MessagesList.add(new Messages(rs.getInt("id"),rs.getDate("data"),rs.getString("imie"),rs.getString("nazwisko"),rs.getString("identyfikator"),rs.getString("wiadomosc"),rs.getDate("data_zakonczenia")));
                }

                if (Messages.getDataZakonczenia()==null){
                    odpowiedz.setVisible(true);
                    end_question.setVisible(true);
                }
                else
                {
                    odpowiedz.setVisible(false);
                    end_question.setVisible(false);
                }

                odpowiedzi.setItems(MessagesList);
            }

        }
    }

    public void click2() {
        Messages message = odpowiedzi.getSelectionModel().getSelectedItem();
        if (message != null) odpowiedz_wiadomosc.setText(message.getOdpowiedz_wiadomosc());
    }

    public void end_question(ActionEvent event) throws IOException, SQLException {
        dbConnect conn=new dbConnect();
        conn.lockQuestion(Messages.getSprawa_id(),session_data.getID());
        Messages.setDataZakonczenia();
        moveClass.move(event,"help.fxml");
        info.createDialog("Informacja","Pozytywnie zamknięto pytanie id "+Messages.getSprawa_id(),18,"center",400,100);
    }

    public void addreply(ActionEvent event) throws IOException {
        moveClass.move(event,"help_addreply.fxml");
    }

    public void back(ActionEvent event) throws IOException{
        if (odpowiedz_wiadomosc.isVisible()) moveClass.move(event,"help.fxml");
        else {
            if(session_data.getRoleID()==1) {
                moveClass.move(event,"main.fxml");
            }
            else if(session_data.getRoleID()==2) {
                moveClass.move(event,"Employee_main.fxml");
            }
        }
    }

    public void create_question(ActionEvent event) throws IOException{
        moveClass.move(event,"help_newQuestion.fxml");
    }
}