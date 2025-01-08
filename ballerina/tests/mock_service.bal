
// import ballerina/http;
// import ballerina/log;

// listener http:Listener httpListener = new(9091);

// http:Service mockService = service object{
//     resource function get marketing/v3/marketing/[string mockId]() returns CollectionResponsePublicCampaignAssetForwardPaging{
//         return {
//             results: {
//                  "id": mockId,
//     "properties": {},
//     "createdAt": "2025-01-07T04:45:53.011Z",
//     "updatedAt": "2025-01-08T09:52:24.054Z",
//     "assets": {
//         "FORM": {
//             "results": [
//                 {
//                     "id": "88047023-7777-40a1-b74b-4b1139e8d45b",
//                     "name": "New form (January 3, 2025 4:37:41 AM EST)"
//                 }
//             ]
//         }
//     }
//             }
   
// }
//     }
// }

// function init() returns error?{
//     log:printInfo("Initializing mock service");
//     check httpListener.attach(mockService, "/");
//     check httpListener.'start();
// }