package database;

import dialogboxes.error;
import dialogboxes.info;
import storage_data.session_data;

import java.sql.*;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Random;

public class dbConnect {
    private Connection connection = null;

    public dbConnect() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection("jdbc:mysql://54.38.131.251:3306/db_71051?noAccessToProcedureBodies=true", "db_71051",                                                                                                                                "1afibWetpAYm");
            if (connection == null) System.out.println("Connection: not");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int loginToAccount(String login,String password,int rola_id) throws SQLException {
        CallableStatement result;
        result = connection.prepareCall("{CALL logIn(?,?,?)}");
        result.setString(1, login);
        result.setString(2, password);
        result.setInt(3, rola_id);
        result.execute();
        ResultSet result2 = result.getResultSet();

        if (result2.next()) {
            session_data.set_identitiy(result2.getInt(2));
            session_data.set_roleID(rola_id);
            return result2.getInt(1);
        }
        else error.createDialog("Wystąpił błąd!","Podano nieprawidłowe dane logowania!\nSprawdź typ logowania do konta!",18,"center",350,100);
        return 0;
    }

    public ResultSet getClientDate(int identify) throws SQLException
    {
        CallableStatement result;
        result = connection.prepareCall("{CALL getPersonalData(?)}");
        result.setInt(1, identify);
        result.execute();

        return result.getResultSet();
    }

    public boolean isAlreadyRegisterUser(String pesel) throws SQLException {
        CallableStatement result;
        result = connection.prepareCall("{CALL getUser_Registration(?)}");
        result.setString(1, pesel);
        ResultSet rs=result.executeQuery();

        if (rs.next())
            return true;
        else
            return false;
    }
    public int createUser(String imie,String nazwisko,String pesel,String password) throws SQLException {
        if (isAlreadyRegisterUser(pesel)) { return 0; }
        else {
            try {
                Random rand = new Random();
                String identyfikator=String.valueOf(Math.abs(rand.nextLong())).substring(0,9);
                CallableStatement result;
                result = connection.prepareCall("{CALL insertNewAccount(?,?,?,?,?,?,?,?,?,?,?)}");
                result.setString(1,identyfikator);
                result.setString(2,password);
                result.setString(3,pesel);
                result.setString(4,imie);
                result.setString(5,nazwisko);
                result.setInt(6,1);
                result.setString(7,"");
                result.setString(8,"");
                result.setString(9,"");
                result.setString(10,"");
                result.setString(11,"");
                result.executeQuery();
                System.out.println("Twój identyfikator: "+identyfikator);
                return Integer.parseInt(identyfikator);
            } catch(SQLException error) {
                System.out.println(error);
            }
            return 1;
        }
    }

    public void updatePersonalData(String ulica,String nr_domu,String kod_pocztowy,String miejscowosc,String email,int nr_telefonu) throws SQLException {
        CallableStatement result;
        result = connection.prepareCall("{CALL updatePersonalData(?,?,?,?,?,?,?)}");
        result.setString(1, ulica);
        result.setString(2, nr_domu);
        result.setString(3, kod_pocztowy);
        result.setString(4, miejscowosc);
        result.setString(5, email);
        result.setInt(6, nr_telefonu);
        result.setInt(7, session_data.getID());
        result.executeQuery();

        info.createDialog("INFORMACJA","Pomyślnie zmodyfikowano dane personalne.",18,"center",400,100);
    }

    public ResultSet getExchangerates() throws SQLException{
        Statement st = connection.createStatement();
        ResultSet rs=st.executeQuery("{CALL getExchangeRates()}");
        return rs;
    }

    public ResultSet getHelp() throws SQLException{
        CallableStatement result;
        result = connection.prepareCall("{CALL getHelp(?)}");
        result.setString(1, String.valueOf(session_data.getID()));
        ResultSet rs=result.executeQuery();
        return rs;
    }

    public ResultSet getHelp_Employee() throws SQLException{
        CallableStatement result;
        result = connection.prepareCall("{CALL getHelp_Employee()}");
        ResultSet rs=result.executeQuery();
        return rs;
    }

    public ResultSet getMessageHelp(int id) throws SQLException{
        CallableStatement result;
        result = connection.prepareCall("{CALL getMessageHelp(?)}");
        result.setInt(1,id);
        ResultSet rs=result.executeQuery();
        return rs;
    }

    public ResultSet getPaysIn(int user_id) throws SQLException{
        CallableStatement result;
        result = connection.prepareCall("{CALL getPaysIn(?)}");
        result.setInt(1,user_id);
        ResultSet rs=result.executeQuery();
        return rs;
    }

    public ResultSet getPaysOut(int user_id) throws SQLException{
        CallableStatement result;
        result = connection.prepareCall("{CALL getPaysOut(?)}");
        result.setInt(1,user_id);
        ResultSet rs=result.executeQuery();
        return rs;
    }

    public void lockQuestion(int question_id,int user_id) throws SQLException {
        PreparedStatement query = connection.prepareStatement("{CALL updateLockQuestion(?,?)}");
        query.setInt(1,question_id);
        query.setInt(2,user_id);
        query.execute();
    }

    public void insertNewMessageToQuestion(String text, int user_id, int question_id) throws SQLException {
        CallableStatement result;
        result = connection.prepareCall("{CALL insertNewMessageToQuestion(?,?,?)}");
        result.setString(1,text);
        result.setInt(2,question_id);
        result.setInt(3,user_id);
        result.executeQuery();
    }

    public void insertQuestion(int user_id, String title, String question) throws SQLException {
        CallableStatement result;
        result = connection.prepareCall("{CALL insertQuestion(?,?,?)}");
        result.setInt(1,user_id);
        result.setString(2,title);
        result.setString(3,question);
        result.executeQuery();
    }

    public ResultSet getBills(int user_id) throws SQLException{
        CallableStatement result;
        result = connection.prepareCall("{CALL getBills(?)}");
        result.setInt(1,user_id);
        ResultSet rs=result.executeQuery();
        return rs;
    }

    public void lockBill(int bill_id, int user_id) throws SQLException {
        PreparedStatement query = connection.prepareStatement("{CALL updateLockBill(?,?)}");
        query.setInt(1,bill_id);
        query.setInt(2,user_id);
        query.execute();
    }

    public ResultSet getDeposits(int user_id) throws SQLException{
        CallableStatement result;
        result = connection.prepareCall("{CALL getDeposits(?)}");
        result.setInt(1,user_id);
        ResultSet rs=result.executeQuery();
        return rs;
    }

    public void depositDelete(int deposit_id,int deposit_balance,int user_id) throws SQLException {
        PreparedStatement query = connection.prepareStatement("{CALL dropDeposit(?,?,?)}");
        query.setInt(1,deposit_id);
        query.setInt(2,deposit_balance);
        query.setInt(3,user_id);
        query.execute();
    }

    public void updateDepositEndTime(int deposit_id, double deposit_addBalance, int user_id) throws SQLException {
        PreparedStatement query = connection.prepareStatement("{CALL updateDepositEndTime(?,?,?)}");
        query.setInt(1,deposit_id);
        query.setDouble(2,deposit_addBalance);
        query.setInt(3,user_id);
        query.execute();
    }

    public int getMainBill(int user_id) throws SQLException{
        CallableStatement result;
        result = connection.prepareCall("{CALL getMainBill(?)}");
        result.setInt(1,user_id);
        ResultSet rs=result.executeQuery();
        if(rs.next()) return 1;
        else return 0;
    }

    public ResultSet getInfoAboutDeposits(int user_id) throws SQLException{
        CallableStatement result;
        result = connection.prepareCall("{CALL getInfoAboutDeposits(?)}");
        result.setInt(1,user_id);
        ResultSet rs=result.executeQuery();
        return rs;
    }

    public void insertDeposit(int deposit_id, int deposit_balance, int deposit_time, int user_id) throws SQLException {
        PreparedStatement query = connection.prepareStatement("{CALL insertDeposit(?,?,?,?)}");
        query.setInt(1,deposit_id);
        query.setInt(2,deposit_balance);
        query.setInt(3,deposit_time);
        query.setInt(4,user_id);
        query.execute();
    }

    public ResultSet getContacts(int user_id) throws SQLException{
        CallableStatement result;
        result = connection.prepareCall("{CALL getContacts(?)}");
        result.setInt(1,user_id);
        ResultSet rs=result.executeQuery();
        return rs;
    }

    public void dropContact(int contact_id,int user_id) throws SQLException {
        PreparedStatement query = connection.prepareStatement("{CALL dropContact(?,?)}");
        query.setInt(1,contact_id);
        query.setInt(2,user_id);
        query.execute();
    }


    public void updateContactName(int contact_id,String contact_desc,int user_id) throws SQLException {
        PreparedStatement query = connection.prepareStatement("{CALL updateContactName(?,?,?)}");
        query.setInt(1,contact_id);
        query.setString(2,contact_desc);
        query.setInt(3,user_id);
        query.execute();
    }

    public void updateDeposits_Transfer(int user_id,String account_number,Float amount,String sender_account_number) throws SQLException {
        PreparedStatement query = connection.prepareStatement("{CALL updateDepositsUser_Transfer(?,?,?,?)}");
        query.setInt(1,user_id);
        query.setString(2,account_number);
        query.setFloat(3,amount);
        query.setString(4,sender_account_number);
        query.execute();
    }

    public void insertOutTransfer(String bill_receiver,String data_receiver,Float amount,String desc,Float balance_user_after,int user_bill_id,int user_id) throws SQLException {
        PreparedStatement query = connection.prepareStatement("{CALL insertOutTransfer(?,?,?,?,?,?,?)}");
        query.setString(1,bill_receiver);
        query.setString(2,data_receiver);
        query.setFloat(3,amount);
        query.setString(4,desc);
        query.setFloat(5,balance_user_after);
        query.setInt(6,user_bill_id);
        query.setInt(7,user_id);
        query.execute();
    }

    public void insertInTransfer(String bill_sender,Float amount,String desc,int user_id,String receiver_bill_number) throws SQLException {
        PreparedStatement query = connection.prepareStatement("{CALL insertInTransfer(?,?,?,?,?)}");
        query.setString(1,bill_sender);
        query.setFloat(2,amount);
        query.setString(3,desc);
        query.setInt(4,user_id);
        query.setString(5,receiver_bill_number);
        query.execute();
    }

    public ResultSet getMainInfo(int user_id) throws SQLException {
        PreparedStatement query = connection.prepareStatement("SELECT getMainInfo(?)");
        query.setInt(1,user_id);
        ResultSet result= query.executeQuery();
        return result;
    }

    public ResultSet getMainInfo_Employee(int user_id) throws SQLException {
        PreparedStatement query = connection.prepareStatement("SELECT getMainInfo_Employee(?)");
        query.setInt(1,user_id);
        ResultSet result= query.executeQuery();
        return result;
    }

    public void updateExchange(String nazwa,String symbol,int user_id,Float kurs_kupna,Float kurs_sprzedazy) throws SQLException {
        PreparedStatement query = connection.prepareStatement("{CALL updateExchange(?,?,?,?,?)}");
        query.setString(1,nazwa);
        query.setString(2,symbol);
        query.setInt(3,user_id);;
        query.setFloat(4,kurs_kupna);;
        query.setFloat(5,kurs_sprzedazy);;
        query.execute();
    }

    public void updateDeposit_unActive(int dbid,int user_id) throws SQLException {
        PreparedStatement query = connection.prepareStatement("{CALL updateDeposit_unActive(?,?)}");
        query.setInt(1,dbid);
        query.setInt(2,user_id);
        query.execute();
    }

    public ResultSet getOnlyDeposits() throws SQLException {
        PreparedStatement query = connection.prepareStatement("{CALL getOnlyDeposits()}");
        ResultSet result= query.executeQuery();
        return result;
    }

    public void insertNewDeposit(String deposit_name,Float deposit_procent,int deposit_time,int deposit_limit,int user_id) throws SQLException {
        PreparedStatement query = connection.prepareStatement("{CALL insertNewDeposit(?,?,?,?,?)}");
        query.setString(1,deposit_name);
        query.setFloat(2,deposit_procent);
        query.setInt(3,deposit_time);
        query.setInt(4,deposit_limit);
        query.setInt(5,user_id);
        query.execute();
    }

    public ResultSet getUserByIdentyfikator(String identyfikator) throws SQLException {
        PreparedStatement query = connection.prepareStatement("{CALL getUserByIdentyfikator(?)}");
        query.setString(1,identyfikator);
        ResultSet result= query.executeQuery();
        return result;
    }

    public ResultSet getUserByPesel(String pesel) throws SQLException {
        PreparedStatement query = connection.prepareStatement("{CALL getUserByPesel(?)}");
        query.setString(1,pesel);
        ResultSet result= query.executeQuery();
        return result;
    }

    public void updatelockAccountByEmployee(int user_id,int employee_id) throws SQLException {
        PreparedStatement query = connection.prepareStatement("{CALL updatelockAccountByEmployee(?,?)}");
        query.setInt(1,user_id);
        query.setInt(2,employee_id);
        query.execute();
    }

    public ResultSet getTypeBills() throws SQLException {
        PreparedStatement query = connection.prepareStatement("{CALL getTypeBills()}");
        ResultSet result= query.executeQuery();
        return result;
    }

    public void insertNewBill(int user_id, int employee_id,int type_bill) throws SQLException {
        Random rand = new Random();
        PreparedStatement query = connection.prepareStatement("{CALL insertNewBill(?,?,?,?)}");
        query.setInt(1,user_id);
        query.setInt(2,employee_id);
        query.setInt(3,type_bill);
        query.setString(4,String.valueOf(Math.abs(rand.nextLong())).substring(0,16));
        query.execute();
    }

    public int insertNewContact(String bill_number,String contact_desc,int user_id) throws SQLException {
        CallableStatement result;
        result = connection.prepareCall("{CALL getBillByBillNumber(?)}"); // czy istnieje dany kontakt w kontakty
        result.setString(1,bill_number);
        ResultSet rs=result.executeQuery();
        if(rs.next()) {
            CallableStatement result2;
            result2 = connection.prepareCall("{CALL getContactByID(?,?)}"); // czy istnieje dany kontakt w kontakty
            result2.setString(1,bill_number);
            result2.setInt(2,user_id);
            ResultSet rs2=result2.executeQuery();
            if(rs2.next()) return 0;
            else
            {
                PreparedStatement query = connection.prepareStatement("{CALL insertNewContact(?,?,?)}");
                query.setString(1,bill_number);
                query.setString(2,contact_desc);
                query.setInt(3,user_id);
                query.execute();
                return 2;
            }
        }
        else return 1;

    }


    public static void main(String [] args) {
    }
}
