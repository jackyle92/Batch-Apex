@isTest
private with sharing class UpdateContactAddressesTest {
  public UpdateContactAddressesTest() {
  }
  @TestSetup
  static void setup() {
    List<Account> accounts = new List<Account>();
    List<Contact> contacts = new List<Contact>();

    // insert 10 accounts
    for (Integer i = 0; i < 10; i++) {
      accounts.add(
        new Account(
          name = 'Account ' + i,
          billingcity = 'New York',
          billingcountry = 'USA'
        )
      );
    }
    insert accounts;

    // find the account just inserted. add contact for each
    for (Account account : [SELECT id FROM account]) {
      contacts.add(
        new Contact(
          firstname = 'first',
          lastname = 'last',
          accountId = account.id
        )
      );
    }
    insert contacts;
  }

  @isTest
  static void test() {
    Test.startTest();
    UpdateContactAddresses uca = new UpdateContactAddresses();
    Id batchId = Database.executeBatch(uca);
    Test.stopTest();
    System.assertEquals(
      10,
      [SELECT COUNT() FROM contact WHERE MailingCity = 'New York']
    );
  }
}
