component{

	import orrms.server.api.twilio.models.*;

    public function init(){
		if (isNull(variables.factory)){
			variables.factory = arguments.factory?:new orrms.server.api.twilio.factory(arguments)
		}
		variables.conversationsUrl = arguments.conversationUrl?:variables.factory.conversationsUrl;

		return this;
	}

	conversation public function create(
		string friendly_name,
		string messaging_service_sid,
		struct attributes,
		date date_created,
		date date_updated
	){

		var instance = new conversation();
		var result = factory.http('POST', variables.conversationsUrl, {'FriendlyName': arguments.friendly_name, 'MessagingServiceSid': arguments.messaging_service_sid});

		if (!isNull(result) && result['status_code'] eq 201){
			result =  deserializeJson(result.fileContent);
			instance = instance.init(argumentCollection=result)
		}

		return instance;
	}

	conversation public function fetch (
		string Sid
	) {

		var instance = new conversation();
		if (!isNull(arguments.sid)){
			var result = factory.http('GET', variables.conversationsUrl & "/" & arguments.sid);

			if (!isNull(result) && result['status_code'] eq 200){
				result =  deserializeJson(result.fileContent);
				instance = instance.init(argumentCollection=result)
			}
		}

		return instance;
	}


	array public function list(
	){

		var result = factory.http('GET', variables.conversationsUrl);
		if (!isNull(result) && result['status_code'] eq 200){
			result =  deserializeJson(result.fileContent).conversations;
		}

		return result;
	}


	any public function remove (string sid) {

		if (!isNull(arguments.sid)){

			var result = factory.http('DELETE', variables.conversationsUrl & "/" & arguments.sid);
			if (!isNull(result) && result['status_code'] eq 204){
				result =  deserializeJson(result.fileContent);
			}else if (!isNull(result) && result['status_code'] eq 404){
				result =  deserializeJson(result.fileContent);
			}
		}

		return result
	}

}