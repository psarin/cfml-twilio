component{

	import orrms.server.api.twilio.models.*;


    public function init(){
		if (isNull(variables.factory)){
			variables.factory = arguments.factory?:new orrms.server.api.twilio.factory(arguments)
		}
		variables.conversationsUrl = arguments.conversationUrl?:factory.conversationsUrl;
		variables.conversation_sid = arguments.conversation_sid?:null;

		return this;
	}

	private function participantsUrl() {
		return variables.conversationsUrl & "/" & variables.conversation_sid & "/Participants";
	}

	participant public function create(
		struct messaging_binding = {address: null, proxy_address:null},
		string identity hint='<Chat User Identity>',
		struct attributes,
		date date_created,
		date date_updated
	){

		var instance = new participant();
		var result = factory.http('POST', participantsUrl(), {'MessagingBinding.Address': arguments.messaging_binding.address, 'MessagingBinding.ProxyAddress': arguments.messaging_binding.proxy_address});

		if (!isNull(result) && result['status_code'] eq 201){
			result =  deserializeJson(result.fileContent);
		} else if (!isNull(result) && result['status_code'] eq 409){
			// Get list of participants , find participant and return info on them
			var participantList = list();
			var matchingParticipant = null;
			for (var a=1; a lte arrayLen(participantList); a++){
				var participant = participantList[a];
				if (!isNull(participant.messaging_binding)){
					if (participant.messaging_binding.proxy_address eq arguments.messaging_binding.proxy_address and participant.messaging_binding.address eq arguments.messaging_binding.address){
						result = participant;
						continue;
					}
				}
			}
		}

		if (!isNull(result)){
			instance = instance.init(argumentCollection=result)
		}
		return instance;
	}

	participant public function fetch (
		string Sid
	) {

		var instance = new participant();
		if (!isNull(arguments.sid)){

			var result = factory.http('GET', participantsUrl() & "/" & arguments.sid);

			if (!isNull(result) && result['status_code'] eq 200){
				result =  deserializeJson(result.fileContent);
				instance = instance.init(argumentCollection=result)
			}
		}
		return instance;


	}


	array public function list(){

		var result = factory.http('GET', participantsUrl());
		if (!isNull(result) && result['status_code'] eq 200){
			result =  deserializeJson(result.fileContent).participants;
		}

		return result;

	}


	any public function remove (string sid) {

		if (!isNull(arguments.sid)){
			var result = factory.http('DELETE', participantsUrl() & "/" & arguments.sid);
			if (!isNull(result) && result['status_code'] eq 204){
				result =  deserializeJson(result.fileContent);
			}else if (!isNull(result) && result['status_code'] eq 404){
				result =  deserializeJson(result.fileContent);
			}
		}

		return result
	}

}