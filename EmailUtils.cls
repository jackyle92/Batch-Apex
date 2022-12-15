global without sharing class EmailUtils {
  public EmailUtils() {
  }

  global static void sendMessage(AsyncApexJob job, Integer recordsProcessed) {
    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
    message.toaddresses = new List<String>{
      'jacky.lee@crosscloudpartners.com'
    };
    message.setSubject('Update Contact Address ' + job.Status);
    message.setPlainTextBody('records processed ' + recordsProcessed);
    Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ message });
  }
}
