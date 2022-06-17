package project;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;

public class Main extends Application {

    @Override
    public void start(Stage primaryStage) throws Exception{
        Parent root = FXMLLoader.load(getClass().getResource("../fxmls/loginpanel_client.fxml"));
        primaryStage.setTitle("BANKOWOŚĆ");
        primaryStage.setScene(new Scene(root, 640, 480));
        primaryStage.show();
    }

    public static void main(String[] args) {
        System.out.println("Rozpoczęto wyświetlanie projektu.");
        launch(args);
        System.out.println("Zakończono wyświetlanie projektu.");
    }
}