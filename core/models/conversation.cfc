component name="conversation" persistent="true" output="false" accessors="true"
{
	/* properties */

	property name="account_sid" type="String" hint="The unique id of the Account responsible for this conversation.";
	property name="chat_service_sid" type="String" ;
	property name="messaging_service_sid" type="String" hint="The unique id of the SMS Service this conversation belongs to." ;
	property name="sid" type="String" hint="A 34 character string that uniquely identifies this resource.";
	property name="friendly_name" type="String" hint="The human-readable name of this conversation, limited to 256 characters. Optional.";

	property name="attributes" type="Struct" hint="An optional string metadata field you can use to store any data you wish. The string value must contain structurally valid JSON if specified. Note that if the attributes are not set '{}' will be returned.";

	property name="date_created" type="Date" ;
	property name="date_updated" type="Date" ;
	property name="url" type="String" hint="An absolute URL for this conversation.";
	property name="links" type="Struct" hint="Absolute URLs to access the Participants of this Conversation." ;


    public function init()
    {
        for (var key in arguments) {
            if (StructKeyExists(arguments, key)) {
                var newVal = arguments[key];
                if (!isStruct(newVal) and (newVal eq "''" or newVal eq '""' or newVal eq "" or IsNull(newVal))) {
                    newVal = null;
				}
				if (isJson(newVal)){
					newVal = deserializeJson(newVal);
				}
                if (!isStruct(newVal) and isDate(newVal)){
                    variables[key] = new orrms.server.utils.moment(newVal).getDateTime();
            	} else {
               	 	variables[key] = newVal;
            	}
        	}
    	}

    	return this;
	}

	public function values(){
		var properties = getMetaData().properties;
		var values = {};
		for (var a=1; a lte arrayLen(properties); a++){
			var prop = properties[a];
			values ['#prop.name#'] = variables[prop.name];
		}
		return values;
	}
}




/*


{
  "account_sid": "ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  "conversation_sid": "CHXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  "sid": "MBXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  "identity": null,
  "attributes": {
    "role": "driver"
  },
  "messaging_binding": {
    "type": "sms",
    "address": "+15558675310",
    "proxy_address": "+15017122661"
  },
  "date_created": "2015-12-16T22:18:37Z",
  "date_updated": "2015-12-16T22:18:38Z",
  "url": "https://conversations.twilio.com/v1/Conversations/CHXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/Participants/MBXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
}
*/