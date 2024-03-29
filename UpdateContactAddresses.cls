public with sharing class UpdateContactAddresses implements Database.Batchable<SObject>, Database.Stateful {
  public UpdateContactAddresses() {
  }
  public Integer recordsProcessed = 0;

  public Database.QueryLocator start(Database.BatchableContext bc) {
    return Database.getQueryLocator(
      'SELECT Id, BillingStreet, BillingCity, BillingState, ' +
      'BillingPostalCode, (SELECT Id, MailingStreet,' +
      ' MailingCity, MailingState, MailingPostalCode FROM ' +
      ' Contacts) FROM Account WHERE BillingCountry = \'USA\''
    );
  }

  public void execute(Database.BatchableContext bc, List<Account> scope) {
    // process each batch of records
    List<Contact> contacts = new List<Contact>();
    for (Account account : scope) {
      for (Contact contact : account.contacts) {
        contact.MailingStreet = account.BillingStreet;
        contact.MailingCity = account.BillingCity;
        contact.MailingState = account.BillingState;
        contact.MailingPostalCode = account.BillingPostalCode;
        // add contact to list to be updated
        contacts.add(contact);
        // increment the instance member counter
        recordsProcessed++;
      }
    }
    update contacts;
  }

  public void finish(Database.BatchableContext bc) {
    System.debug(recordsProcessed + 'records processed. Shazam!');
    AsyncApexJob job = [
      SELECT
        Id,
        Status,
        NumberOfErrors,
        JobItemsProcessed,
        TotalJobItems,
        CreatedBy.Email
      FROM AsyncApexJob
      WHERE Id = :bc.getJobId()
    ];
    // call some utility to send email
    EmailUtils.sendMessage(job, recordsProcessed);
  }
}
