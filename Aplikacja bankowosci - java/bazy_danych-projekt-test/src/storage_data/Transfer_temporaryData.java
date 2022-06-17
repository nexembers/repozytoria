package storage_data;

public class Transfer_temporaryData {
    private static String name_contact;
    private static String contact_bill;
    private static int sender_bill=0;


    public Transfer_temporaryData(String name_contact_path, String contact_bill_path) {
        name_contact=name_contact_path;
        contact_bill=contact_bill_path;
    }

    public Transfer_temporaryData(String k, String j, int sender_bill_path) {
        sender_bill=sender_bill_path;
    }


    public static String getName_contact() { return name_contact; }
    public static String getContact_bill() { return contact_bill; }
    public static int getBill_sender() { return sender_bill; }

    public static void setNull() {
        name_contact=null;
        contact_bill=null;
        sender_bill=0;
    }
}
