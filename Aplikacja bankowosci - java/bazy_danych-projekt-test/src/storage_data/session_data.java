package storage_data;

public class session_data {
    private static boolean _logged=false;
    private static int _id_account=0;
    private static int _rola_id=0;
    private static int _identitiy=0;
    private static int _check_account=0;

    public static void sesja(boolean zalogowany,int id,int rola_id) {
        _logged=zalogowany;
        _id_account=id;
        _rola_id=rola_id; // przechowywanie roli - czy to pracownik, czy to klient?
    }

    public static void set_identitiy(int identity){
        _identitiy=identity;
    }
    public static void set_roleID(int roleonapp){
        _rola_id=roleonapp;
    }
    public static void setAccountCheck_data(int account_check){
        _check_account=account_check;
    }
    public static int getAcocountCheck_data() { return _check_account; }
    public static int getID() { return _id_account; }
    public static int getRoleID() { return _rola_id; }
    public static int get_identitiy(){return _identitiy;}

    public static void logoutAccount() {
        _logged=false;
        _id_account=0;
        _rola_id=0;
        _identitiy=0;
        _check_account=0;
        System.out.println("wylogowano - dane przywrócone do domyślnych {logged: "+_logged+", id_account: "+_id_account+", role_id: "+_rola_id+", identity: "+_identitiy+"}");
    }
}
