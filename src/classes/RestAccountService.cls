@RestResource(urlMapping='/Account/*')
global with sharing class RestAccountService {

    @HttpGet
    global static Account getAccountById() {
        RestRequest request = RestContext.request;
        String AccountId = request.requestURI.substring(
                request.requestURI.lastIndexOf('/') + 1);
        Account result = [
                SELECT Id, Name
                FROM Account
                WHERE Id = :AccountId
        ];
        return result;
    }
    @HttpPost
    global static ID createAccount(String name) {
        Account thisAccount = new Account(Name = name);
        insert thisAccount;
        return thisAccount.Id;
    }
    @HttpDelete
    global static void deleteAccount() {
        RestRequest request = RestContext.request;
        String AccountId = request.requestURI.substring(
                request.requestURI.lastIndexOf('/') + 1);
        Account thisAccount = [SELECT Id FROM Account WHERE Id = :AccountId];
        delete thisAccount;
    }
    @HttpPut
    global static ID upsertAccount(String id, String name) {
        Account thisAccount = new Account(
                Id = id,
                Name = name);
        // Match Account by Id, if present.
        // Otherwise, create new Account.
        upsert thisAccount;
        // Return the Account ID.
        return thisAccount.Id;
    }
    @HttpPatch
    global static ID updateAccountFields() {
        RestRequest request = RestContext.request;
        String AccountId = request.requestURI.substring(
                request.requestURI.lastIndexOf('/') + 1);
        Account thisAccount = [SELECT Id FROM Account WHERE Id = :AccountId];
        // Deserialize the JSON string into name-value pairs
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(request.requestbody.tostring());
        // Iterate through each parameter field and value
        for (String fieldName : params.keySet()) {
            // Set the field and value on the Account sObject
            thisAccount.put(fieldName, params.get(fieldName));
        }
        update thisAccount;
        return thisAccount.Id;
    }
    
}