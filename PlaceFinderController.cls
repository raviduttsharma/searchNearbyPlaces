/** Define class as without sharing as the page will be hosted on a Force.com site and guest users will access it **/
public without sharing class PlaceFinderController {
    
 /** latitude and longitude of current location of user separated by comma **/
    public String latLng {get;set;}
    
 /** url of google nearby places api **/ 
    public String endpoint {get;set;}
    
 /** key to access google api, you need to register using your gmail account **/
    public String key {get;set;}
    
 /** option selected from picklist **/
    public String selectedOption {get;set;}
    
 /** Object in which the deserialized response of google api is stored **/
    public JSON2Apex obj {get;set;}
    
 /** holds results which needs to be displayed in pageblock table on vf page **/
    public List<TableData> tableDataList {get;set;}
    
 /** this will hold the tableDataList in json format and will be used to plot markers on google map **/
    public String tableDataListJSONFormatted {get;set;}
    
 /** decides whether to display results page block section or not **/
    public boolean showResults{get;set;}
    
 /** decides whether to display no-results page block section or not **/
    public boolean showMessage{get;set;}
    
 /** Constructor **/
    public PlaceFinderController(){
        showResults = false;
        showMessage = false;
  /** Register for a google api key and insert the key here **/
        key = 'placeYourKeyHere';
        tableDataList = new List<TableData>();
    }
    
 /** Inner class to hold the data that needs to be displayed in page block table **/
    public class TableData {
        
  /** name of the place **/
        public String name{get;set;}
  /** address of the place **/
        public String vicinity{get;set;}
  /** latitude of the place **/
        public Double latitude{get;set;}
  /** longitude of the place **/
        public Double longitude{get;set;}
  /** generic icon of the place provided by google api**/
        public String icon{get;set;}
        
  /** Constructor **/
        public TableData(String name,String vicinity,Double latitude, Double longitude){
            this.name = name;
            this.vicinity = vicinity;
            this.latitude = latitude;
            this.longitude = longitude;
        }
        
    }
    
 /** Populates the option list present on vf page **/
    public List<SelectOption> getOptions(){
        List<SelectOption> optionList = new List<SelectOption>();
        optionList.add(new SelectOption('atm','ATM'));
        optionList.add(new SelectOption('bank','Bank'));
        optionList.add(new SelectOption('bar','Bar'));
        optionList.add(new SelectOption('bus_station','Bus Station'));
        optionList.add(new SelectOption('cafe','Cafe'));
        optionList.add(new SelectOption('dentist','Dentist'));
        optionList.add(new SelectOption('department_store','Departmental Store'));
        optionList.add(new SelectOption('doctor','Doctor'));
        optionList.add(new SelectOption('hospital','Hospital'));
        optionList.add(new SelectOption('liquor_store','Liquor Store'));
        optionList.add(new SelectOption('mosque','Mosque'));
        optionList.add(new SelectOption('restaurant','Restaurant'));
        optionList.add(new SelectOption('shopping_mall','Shopping Mall'));
        optionList.add(new SelectOption('hindu_temple','Temple'));
        return optionList;
    }
    
 /** called from search button present on vf page **/
    public void search(){
        endpoint='';
        showResults = false;
        showMessage = false;
        obj = null;
        tableDataListJSONFormatted = '';
        tableDataList.clear();
        endpoint='https://maps.googleapis.com/maps/api/place/nearbysearch/json?';
        endpoint = endpoint + 'location=' + latLng + '&types=' + selectedOption + '&key=' + key + '&radius=3000';
        callGooglePlacesAPI();
    }
    
 /** used to make rest call to google's places api **/
    public void callGooglePlacesAPI(){
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setTimeout(60000);
        try{
                /** callout **/
                HttpResponse res = h.send(req);
                /** parse coordinates from response **/
                obj = JSON2Apex.parse(res.getBody());
                obj.html_attributions=new List<String>();
                for(Integer i=0;i<obj.results.size();i++){
                    showResults = true;
     /** Replace all special characters as JSON parsing may fail due to special characters **/
                    tableDataList.add(new TableData(obj.results[i].name.replaceAll('[^a-z^A-z^0-9^\\s]', ''),obj.results[i].vicinity.replaceAll('[^a-z^A-z^0-9^\\s]', ''),obj.results[i].geometry.location.lat,obj.results[i].geometry.location.lng));
                }
                if(!showResults){
                    showMessage = true;
                }
                tableDataListJSONFormatted = JSON.serialize(tableDataList);
            } catch (Exception e) {
                System.debug('Error getMessage: '+e.getMessage());
        } 
    }
}