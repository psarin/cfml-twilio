component {

	import orrms.server.api.twilio.actions.*;

	public function init(){
		this.conversationsUrl = arguments.conversationsUrl?:"https://conversations.twilio.com/v1/Conversations";

		variables.accountSid = arguments.accountSid;
		variables.authToken = arguments.authToken;

		variables.conversations = new conversations(factory = this);
		variables.participants = new participants(factory = this);
		variables.messages = new messages(factory = this);

		return this;
	}

	public function conversations(){
		return variables.conversations.init(argumentCollection = arguments);
	}
	public function participants(){
		return variables.participants.init(argumentCollection = arguments);
	}
	public function messages(){
		return variables.messages.init(argumentCollection = arguments);
	}

	public function http(method, urlToUse, params){

		var httpService = new http(method = "#arguments.method#", url = "#arguments.urlToUse#");
		httpService.addParam(name = "Authorization", type = "header", value = "Basic #ToBase64("#accountSid#:#authToken#")#");
		httpService.addParam(name = "Content-Type", type = "header", value = "application/x-www-form-urlencoded;charset=UTF-8");

		if (!isNull(params)){
			var keys = structKeyArray(params)
			for (var a=1; a lte arrayLen(keys); a++){
				var key = keys[a];
				httpService.addParam(name = "#key#", type = "form", value = "#arguments.params[key]#");
			}
		}

		return httpService.send().getPrefix();

	}

}