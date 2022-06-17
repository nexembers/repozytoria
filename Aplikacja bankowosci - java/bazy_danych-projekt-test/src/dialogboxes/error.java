package dialogboxes;


import javafx.scene.Scene;
import javafx.scene.control.Label;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;

public class error {


    public static void createDialog(String title, String text, int fontsize, String alignment, int width, int height) {
        final Stage dialog=new Stage();
        Stage primaryStage=null;
        VBox dialogVBox=new VBox(20);
        Label label=new Label(text);
        label.setStyle("-fx-font-size: "+fontsize+"; -fx-text-alignment: "+alignment);
        dialogVBox.getChildren().add(label);
        Scene dialogScene=new Scene(dialogVBox,width,height);
        dialogVBox.setStyle("-fx-alignment: center; -fx-background-color: #FFFFFF");
        dialog.setTitle(title);
        dialog.setScene(dialogScene);
        dialog.show();
    }
}
