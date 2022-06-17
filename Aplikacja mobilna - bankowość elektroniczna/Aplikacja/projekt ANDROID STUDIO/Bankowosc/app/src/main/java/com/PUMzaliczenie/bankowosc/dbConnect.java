package com.PUMzaliczenie.bankowosc;

import android.os.StrictMode;
import android.text.Editable;

import com.mysql.jdbc.log.NullLogger;

import java.sql.*;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.Random;

import javax.xml.transform.Result;

public class dbConnect {
    private Connection connection;

    public dbConnect() {

        StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
        StrictMode.setThreadPolicy(policy);
        try {
            Class.forName("com.mysql.jdbc.Driver");
            connection = DriverManager.getConnection("jdbc:mysql://193.70.94.34:3306/db_79803?noAccessToProcedureBodies=true","db_79803",                                                                                                                   "qLeID1wnqowd");
            if (connection == null) System.out.println("Connection: not");
            System.out.println("okej!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public ResultSet getUserByPesel(String identyfikator) throws SQLException{
        PreparedStatement query = connection.prepareStatement("SELECT * FROM uzytkownicy WHERE identyfikator=?");
        query.setString(1, identyfikator);
        query.execute();
        ResultSet rs = query.getResultSet();
        return rs;
    }

    public int loginToAccount(String login, String password) throws SQLException {

        PreparedStatement query = connection.prepareStatement("SELECT * FROM uzytkownicy WHERE identyfikator=? AND haslo=? LIMIT 1");
        query.setString(1, login);
        query.setString(2, password);
        query.execute();
        ResultSet rs = query.getResultSet();

        if (rs.next()) {

            session_data.set_identitiy(rs.getString("identyfikator"));
            session_data.set_roleID(rs.getInt("role_id"));
            return rs.getInt("dbid");
        }

        return 0;
    }

    public boolean isAlreadyRegisterUser(String identyfikator) throws SQLException {
        PreparedStatement query = connection.prepareStatement("SELECT dbid FROM uzytkownicy WHERE identyfikator=? LIMIT 1");
        query.setString(1, identyfikator);
        ResultSet rs=query.executeQuery();

        if (rs.next())
            return true;
        else
            return false;
    }
    public int createUser(String identyfikator,String haslo,int rola) throws SQLException {
        if (isAlreadyRegisterUser(identyfikator)) { return 0; }
        else {
            try {
                PreparedStatement rs = connection.prepareStatement("INSERT INTO uzytkownicy VALUES (DEFAULT,?,NOW(),?,?,?,?,?,?,?)");
                rs.setString(1,identyfikator);
                rs.setString(2,haslo);
                rs.setString(3,null);
                rs.setString(4,null);
                rs.setString(5,null);
                rs.setString(6,null);
                rs.setString(7,null);
                rs.setInt(8,rola);
                rs.execute();

                if(rola==1){
                    ResultSet rs2=getUserByPesel(identyfikator);
                    if(rs2.next()) {
                        PreparedStatement rs3 = connection.prepareStatement("INSERT INTO dzieci VALUES (DEFAULT,NOW(),?,?)");
                        rs3.setInt(1,session_data.getID());
                        rs3.setInt(2,rs2.getInt("dbid"));
                        rs3.execute();

                        Random rand = new Random();
                        String nr_rachunku=String.valueOf(Math.abs(rand.nextLong())).substring(0,8);

                        PreparedStatement rs4 = connection.prepareStatement("INSERT INTO uzytkownicy_rachunki VALUES (DEFAULT,?,NOW(),DEFAULT,?,DEFAULT,DEFAULT)");
                        rs4.setString(1,nr_rachunku);
                        rs4.setInt(2,rs2.getInt("dbid"));
                        rs4.execute();
                    }
                }
                return 1;
            } catch(SQLException error) {
                System.out.println(error);
            }
            return 1;
        }
    }


    public int getDefaultBill() throws SQLException{
        try {
            PreparedStatement query = connection.prepareCall("SELECT * FROM uzytkownicy_rachunki WHERE uzytkownicy_id=? AND rachunki_id=1");
            query.setInt(1,session_data.getID());
            ResultSet rs=query.executeQuery();
            if(rs.next()){
                session_data.set_defaultbill(rs.getString("nr_rachunku"));
                return 1;
            }

            // jeśli nie ma, zakładamy od razu.

            Random rand = new Random();
            String nr_rachunku=String.valueOf(Math.abs(rand.nextLong())).substring(0,8);
            session_data.set_defaultbill(nr_rachunku);
            PreparedStatement rs2 = connection.prepareStatement("INSERT INTO uzytkownicy_rachunki VALUES (DEFAULT,?,NOW(),DEFAULT,?,DEFAULT,DEFAULT)");
            rs2.setString(1,nr_rachunku);
            rs2.setInt(2,session_data.getID());
            rs2.executeUpdate();

        } catch(SQLException error) {
            System.out.println(error);
        }
        return 0;
    }

    public ResultSet getClientDate() throws SQLException
    {
        PreparedStatement rs = connection.prepareCall("SELECT a.dbid,a.identyfikator,a.imie,a.nazwisko,a.adres,b.nr_rachunku,b.saldo,b.limit_przelewu FROM uzytkownicy a JOIN uzytkownicy_rachunki b ON a.dbid=b.uzytkownicy_id WHERE a.dbid=?");
        rs.setInt(1, session_data.getID());
        rs.execute();

        return rs.getResultSet();
    }

    public ResultSet getChildrens() throws SQLException
    {
        PreparedStatement rs = connection.prepareCall("SELECT a.uzytkownicy_dziecko_id,b.identyfikator,b.imie,b.nazwisko,c.saldo,c.nr_rachunku FROM dzieci a JOIN uzytkownicy b ON b.dbid=a.uzytkownicy_dziecko_id JOIN uzytkownicy_rachunki c ON a.uzytkownicy_dziecko_id=c.uzytkownicy_id WHERE a.uzytkownicy_rodzic_id=?");

        rs.setInt(1, session_data.getID());
        rs.execute();

        return rs.getResultSet();
    }

    public int getPasswordAndChange(String password,String newpassword) throws SQLException
    {
        PreparedStatement query = connection.prepareCall("SELECT haslo FROM uzytkownicy WHERE dbid=? AND haslo=? LIMIT 1");
        query.setInt(1, session_data.getID());
        query.setString(2, password);
        ResultSet rs=query.executeQuery();
        if(rs.next()) {
            PreparedStatement rs2 = connection.prepareStatement("UPDATE uzytkownicy SET haslo=? WHERE dbid=?");
            rs2.setString(1, newpassword);
            rs2.setInt(2, session_data.getID());
            rs2.executeUpdate();
            return 1; // zmieniono hasło
        }
        return 0; // nie zmieniono hasła - błędne hasło bieżące.
    }

    public void updatePersonalData(String imie,String nazwisko,String adres) throws SQLException {
        PreparedStatement rs = connection.prepareStatement("UPDATE uzytkownicy SET imie=?,nazwisko=?,adres=? WHERE dbid=?");
        rs.setString(1, imie);
        rs.setString(2, nazwisko);
        rs.setString(3, adres);
        rs.setInt(4, session_data.getID());
        rs.executeUpdate();
    }

    public void updateLimit(int kwota) throws SQLException {
        PreparedStatement rs = connection.prepareStatement("UPDATE uzytkownicy_rachunki SET limit_przelewu=? WHERE uzytkownicy_id=? AND rachunki_id=1 LIMIT 1");
        rs.setInt(1, kwota);
        rs.setInt(2, session_data.getID());
        rs.executeUpdate();
    }


    public int getMoney(Date data) throws SQLException{
        try {
            PreparedStatement query = connection.prepareCall("SELECT * FROM uzytkownicy_srodki WHERE uzytkownicy_id=? AND data=?");
            query.setInt(1,session_data.getID());
            query.setDate(2,data);
            ResultSet rs=query.executeQuery();
            if(rs.next()){
                return 1;
            }

            PreparedStatement rs2 = connection.prepareStatement("INSERT INTO uzytkownicy_srodki VALUES (DEFAULT,?,?)");
            rs2.setDate(1,data);
            rs2.setInt(2,session_data.getID());
            rs2.executeUpdate();



            PreparedStatement rs3 = connection.prepareStatement("UPDATE uzytkownicy_rachunki SET saldo=saldo+? WHERE uzytkownicy_id=? AND rachunki_id=1 LIMIT 1");
            rs3.setInt(1, 1000);
            rs3.setInt(2, session_data.getID());
            rs3.executeUpdate();
            return 2;

        } catch(SQLException error) {
            System.out.println(error);
        }
        return 0;
    }

    public int getAccountNumber(String account_number,String account_description) throws SQLException
    {
        PreparedStatement query = connection.prepareCall("SELECT * FROM uzytkownicy_rachunki WHERE nr_rachunku=? LIMIT 1");
        query.setString(1, account_number);
        ResultSet rs=query.executeQuery();
        if(rs.next()) {

            PreparedStatement rs2 = connection.prepareStatement("INSERT INTO kontakty VALUES (DEFAULT,?,?,?)");
            rs2.setString(1,account_description);
            rs2.setString(2,account_number);
            rs2.setInt(3,session_data.getID());
            rs2.executeUpdate();

            return 1;
        }
        return 0;
    }

    public ResultSet getContacts() throws SQLException{
        CallableStatement result;
        result = connection.prepareCall("SELECT * FROM kontakty WHERE uzytkownicy_id=?");
        result.setInt(1,session_data.getID());
        ResultSet rs=result.executeQuery();
        return rs;
    }

    public ResultSet getInfoAboutContact(String account_number) throws SQLException{
        CallableStatement result;
        result = connection.prepareCall("SELECT * FROM kontakty WHERE uzytkownicy_rachunki_odbiorca=? AND uzytkownicy_id=?");
        result.setString(1,account_number);
        result.setInt(2,session_data.getID());
        ResultSet rs=result.executeQuery();
        return rs;
    }



    public int deteleContact(String account_number) throws SQLException{
        PreparedStatement result = connection.prepareStatement("DELETE FROM kontakty WHERE uzytkownicy_rachunki_odbiorca=? AND uzytkownicy_id=?");
        result.setString(1,account_number);
        result.setInt(2,session_data.getID());
        result.execute();
        return 1;
    }

    public ResultSet getAccount_is(String account_number) throws SQLException{
        PreparedStatement query = connection.prepareCall("SELECT * FROM uzytkownicy_rachunki WHERE nr_rachunku=? LIMIT 1");
        query.setString(1, account_number);
        ResultSet rs=query.executeQuery();
        return rs;
    }

    public int makeTransfer(Float kwota,String rachunek_nadawcy,String rachunek_odbiorcy,String adresat,String tytul,int rachunek_id) throws SQLException {
        // dla wykonywującego przelew
        PreparedStatement rs = connection.prepareStatement("UPDATE uzytkownicy_rachunki SET saldo=saldo-? WHERE nr_rachunku=?");
        rs.setFloat(1, kwota);
        rs.setString(2, rachunek_nadawcy);
        rs.executeUpdate();

        PreparedStatement rs2 = connection.prepareStatement("UPDATE uzytkownicy_rachunki SET saldo=saldo+? WHERE nr_rachunku=?");
        rs2.setFloat(1, kwota);
        rs2.setString(2, rachunek_odbiorcy);
        rs2.executeUpdate();

        insert_przelewWychodzacy(kwota,rachunek_odbiorcy,adresat,tytul,rachunek_id);
        insert_przelewPrzychodzacy(kwota,rachunek_nadawcy,rachunek_odbiorcy,adresat,tytul,rachunek_id);

        // dla otrzymującego przelew.
        return 1;
    }

    public void insert_przelewWychodzacy(Float kwota,String rachunek_odbiorcy,String adresat,String tytul,int rachunek_id) throws SQLException {
        PreparedStatement rs2 = connection.prepareStatement("INSERT INTO przelewy_wychodzace VALUES (DEFAULT,?,?,?,?,NOW(),?,?)");
        rs2.setString(1,rachunek_odbiorcy);
        rs2.setString(2,adresat);
        rs2.setFloat(3,kwota);
        rs2.setString(4,tytul);
        rs2.setInt(5,rachunek_id);
        rs2.setInt(6,session_data.getID());
        rs2.executeUpdate();

        System.out.println("dodano do przelewow wychodzacych!");
    }

    public void insert_przelewPrzychodzacy(Float kwota,String rachunek_nadawcy,String rachunek_odbiorcy,String adresat,String tytul,int rachunek_id) throws SQLException {
        PreparedStatement query = connection.prepareCall("SELECT * FROM uzytkownicy_rachunki WHERE nr_rachunku=? LIMIT 1");
        query.setString(1, rachunek_odbiorcy);
        ResultSet rs=query.executeQuery();
        if(rs.next()){
            PreparedStatement rs2 = connection.prepareStatement("INSERT INTO przelewy_przychodzace VALUES (DEFAULT,?,?,?,?,NOW(),?,?)");
            rs2.setString(1,rachunek_nadawcy);
            rs2.setString(2,adresat);
            rs2.setFloat(3,kwota);
            rs2.setString(4,tytul);
            rs2.setInt(5,rs.getInt("id"));
            rs2.setInt(6,rs.getInt("uzytkownicy_id"));
            rs2.executeUpdate();
            // id uzytkownika ktory dostaje przelew - wyszukac po nr. rachunku odbiorcy?
        }
        System.out.println("dodano do przelewow przychodzacych!");
    }

    public ResultSet getHistoryInTransfer() throws SQLException{
        CallableStatement result;
        result = connection.prepareCall("SELECT a.id,a.kwota,a.tytul,a.data,b.nr_rachunku,b.uzytkownicy_id,c.imie,c.nazwisko FROM przelewy_przychodzace a JOIN uzytkownicy_rachunki b ON b.nr_rachunku=a.rachunek_nadawcy JOIN uzytkownicy c ON c.dbid=b.uzytkownicy_id WHERE a.uzytkownicy_id=? ORDER BY a.data DESC");
        result.setInt(1,session_data.getID());
        ResultSet rs=result.executeQuery();
        return rs;
    }

    public ResultSet getHistoryOutTransfer() throws SQLException{
        CallableStatement result;
        result = connection.prepareCall("SELECT id,rachunek_odbiorcy,dane_adresata,kwota,tytul,data FROM przelewy_wychodzace WHERE uzytkownicy_id=? ORDER BY data DESC");
        result.setInt(1,session_data.getID());
        ResultSet rs=result.executeQuery();
        return rs;
    }

    public ResultSet getHistory_one_In(int dbid) throws SQLException{
        CallableStatement result;
        result = connection.prepareCall("SELECT * FROM przelewy_przychodzace WHERE id=? LIMIT 1");
        result.setInt(1,dbid);
        ResultSet rs=result.executeQuery();
        return rs;
    }

    public ResultSet getHistory_one_Out(int dbid) throws SQLException{
        CallableStatement result;
        result = connection.prepareCall("SELECT * FROM przelewy_wychodzace WHERE id=? LIMIT 1");
        result.setInt(1,dbid);
        ResultSet rs=result.executeQuery();
        return rs;
    }

    public ResultSet getSumOfToday_In() throws SQLException{
        CallableStatement result;
        result = connection.prepareCall("SELECT IFNULL(SUM(kwota), 0) as val FROM przelewy_przychodzace WHERE uzytkownicy_id=? AND data>=?");
        result.setInt(1,session_data.getID());
        result.setDate(2, Date.valueOf(new java.text.SimpleDateFormat("yyyy-MM-dd").format(Calendar.getInstance().getTime())));
        ResultSet rs=result.executeQuery();
        return rs;
    }

    public ResultSet getSumOfToday_Out() throws SQLException{
        CallableStatement result;
        result = connection.prepareCall("SELECT IFNULL(SUM(kwota), 0) as val FROM przelewy_wychodzace WHERE uzytkownicy_id=? AND data>=?");
        result.setInt(1,session_data.getID());
        result.setDate(2, Date.valueOf(new java.text.SimpleDateFormat("yyyy-MM-dd").format(Calendar.getInstance().getTime())));
        ResultSet rs=result.executeQuery();
        return rs;
    }




    public static void main(String [] args) {
    }
}
