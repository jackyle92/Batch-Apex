# Batch-Apex
BatchApex Code and Note

## Syntax:
- class must implement the Database.Batchable interface
    - start(): Used to collect the records or objects to be passed to the interface method execute for processing.
        - Returns either a Database.QueryLocator or an Iterable
        - With the QueryLocator object, the governor limit for the total number of records retrieved by SOQL queries is bypassed and you can query up to 50 million records. 
        - However, with an Iterable, the governor limit for the total number of records retrieved by SOQL queries is still enforced. 
    - execute(): 
        This method takes the following:
        - A reference to the Database.BatchableContext object.
        - A list of sObjects, such as List<sObject>, or a list of parameterized types. If you are using a Database.QueryLocator, use the returned list.
    - finish()
