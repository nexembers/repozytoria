package controllers;

import javafx.event.ActionEvent;
import project.moveClass;
import storage_data.session_data;

import java.io.IOException;

public class EmployeeMain {

    public void check_user(ActionEvent event) throws IOException {
        moveClass.move(event,"user_info.fxml");
    }

    public void questions(ActionEvent event) throws IOException {
        moveClass.move(event,"help.fxml");
    }

    public void editDeposits(ActionEvent event) throws IOException {
        moveClass.move(event,"editDeposits.fxml");
    }

    public void editExchangeRates(ActionEvent event) throws IOException {
        moveClass.move(event,"editExchangeRates_Employee.fxml");
    }

    public void edit_data_employee(ActionEvent event) throws IOException {
        moveClass.move(event,"editpersonaldata.fxml");
    }

    public void logout(ActionEvent event) throws IOException {
        session_data.logoutAccount();
        moveClass.move(event,"loginpanel_client.fxml");
    }
}
