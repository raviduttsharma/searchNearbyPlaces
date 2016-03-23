/** 
 This class is used to hold the deserialized response of google api 
 You can generate this class from heroku app available at https://json2apex.herokuapp.com/ 
 Provide your json response to this app and it will generate the class for you, simply amazing..!!
**/
public class JSON2Apex {

    public class Photos {
        public Integer height;
        public List<String> html_attributions;
        public String photo_reference;
        public Integer width;
    }

    public class Opening_hours {
        public Boolean open_now;
        public List<Html_attributions> weekday_text;
    }

    public List<String> html_attributions;
    public List<Results> results;
    public String status;

    public class Location {
        public Double lat;
        public Double lng;
    }

    public class Geometry {
        public Location location;
    }

    public class Results {
        public Geometry geometry;
        public String icon;
        public String id;
        public String name;
        public Opening_hours opening_hours;
        public String place_id;
        public String reference;
        public String scope;
        public List<String> types;
        public String vicinity;
        public List<Photos> photos;
    }

    public class Html_attributions {
    
    }

    public static JSON2Apex parse(String json) {
        return (JSON2Apex) System.JSON.deserialize(json, JSON2Apex.class);
    }
    
}