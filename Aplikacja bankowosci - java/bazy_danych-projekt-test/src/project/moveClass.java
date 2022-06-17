package project;

import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;
import java.io.IOException;

public class moveClass {


    public static void move(javafx.event.ActionEvent event, String path) throws IOException {
        Node node=(Node) event.getSource();
        Stage thisStage=(Stage) node.getScene().getWindow();
        Parent root= FXMLLoader.load(moveClass.class.getResource("../fxmls/"+path));
        thisStage.setScene(new Scene(root));
        thisStage.show();
    }
}
