package com.PUMzaliczenie.bankowosc;

public class session_data {
    private static boolean _logged=false;
    private static int _id_account=0;
    private static int _rola_id=0;
    private static String _identitiy="0";
    private static String _defaultbill="0";
    private static int _limitprzelewu=0;
    private static float _saldo=0;

    public static void sesja(boolean zalogowany,int id,int rola_id) {
        _logged=zalogowany;
        _id_account=id;
        _rola_id=rola_id; // przechowywanie roli - czy to rodzic, czy to dziecko?
    }

    public static void set_identitiy(String identity){
        _identitiy=identity;
    }
    public static String get_identitiy(){return _identitiy;}

    public static void set_roleID(int roleonapp){
        _rola_id=roleonapp;
    }
    public static int getID() { return _id_account; }
    public static int getRoleID() { return _rola_id; }


    public static int get_limitprzelewu(){return _limitprzelewu;}
    public static void set_limitprzelewu(int limitprzelewu){
        _limitprzelewu=limitprzelewu;
    }

    public static void set_defaultbill(String defaultbill){
        _defaultbill=defaultbill;
    }
    public static String get_defaultbill(){return _defaultbill;}

    public static void set_saldo(float saldo){ _saldo=saldo; }
    public static float get_saldo(){return _saldo;}

    public static void logoutAccount() {
        _logged=false;
        _id_account=0;
        _rola_id=0;
        _identitiy="0";
        _limitprzelewu=0;
        _saldo=0;
        System.out.println("wylogowano - dane przywrócone do domyślnych {logged: "+_logged+", id_account: "+_id_account+", role_id: "+_rola_id+", identity: "+_identitiy+"}");
    }
}
