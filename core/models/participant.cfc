component persistent="true" output="false" accessors="true"
{
	/* properties */

	property name="account_sid" type="String" hint="The unique id of the Account responsible for this participant.";
	property name="conversation_sid" type="String" hint="The unique id of the Conversation for this participant.";
	property name="sid" type="String" hint="A 34 character string that uniquely identifies this resource.";
	property name="identity" type="String" hint="A unique string identifier for the conversation participant as Chat User. This parameter is non-null if (and only if) the participant is using the Programmable Chat SDK to communicate. Limited to 256 characters.";
	property name="attributes" type="Struct" hint="An optional string metadata field you can use to store any data you wish. The string value must contain structurally valid JSON if specified. Note that if the attributes are not set '{}' will be returned.";

	property name="messaging_binding" type="Struct" hint="Information about how this participant exchanges messages with the conversation. A JSON parameter consisting of type and address fields of the participant.";

	property name="date_created" type="Date" ;
	property name="date_updated" type="Date" ;
	property name="url" type="String" hint="An absolute URL for this participant.";


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
			if (!isNull(variables[prop.name])){
				values['#prop.name#'] = variables[prop.name];
			}
		}
		return values;
	}
}