// Copyright 2006-2013 ClickTale Ltd., US Patent Pending
// Generated on: 12/2/2013 10:48:16 AM (UTC 12/2/2013 4:48:16 PM)

if (typeof(ct_dispatcher) == 'undefined')
{
	ct_dispatcher = {
		configName : null,
		cookieName : "ct_configName",
		getParameterByName : function (name)
		{
			 name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
			 var regexS = "[\\?&]" + name + "=([^&#]*)";
			 var regex = new RegExp(regexS);
			 var results = regex.exec(window.location.search);
			 if(results == null)
			   return "";
			 else
			   return decodeURIComponent(results[1].replace(/\+/g, " "));
		},
		createCookie: function (name,value,days) 
		{
			if (days) 
			{
				var date = new Date();
				date.setTime(date.getTime( )+( days*24*60*60*1000));
				var expires = "; expires="+date.toGMTString( );
			}
			else var expires = "";
			document.cookie = name+"="+value+expires+"; path=/";
		},
		readCookie : function (name) 
		{
			var nameEQ = name + "=";
			var ca = document.cookie.split( ';');
			for( var i=0;i < ca.length;i++) 
			{
				var c = ca[i];
				while ( c.charAt( 0)==' ') c = c.substring( 1,c.length);
				if ( c.indexOf( nameEQ) == 0) return c.substring( nameEQ.length,c.length);
			}
			return null;
		}
	};
		
	// Read from querystring
	var ct_pdc_qs_val = ct_dispatcher.getParameterByName(ct_dispatcher.cookieName);
	if (ct_pdc_qs_val)
	{
		// Override/create cookie
		ct_dispatcher.createCookie(ct_dispatcher.cookieName, ct_pdc_qs_val, 14);
		ct_dispatcher.configName = ct_pdc_qs_val;
	}
	else
	{
		// Read from cookie
		ct_dispatcher.configName = ct_dispatcher.readCookie(ct_dispatcher.cookieName);
	}

	
}

	if (typeof (ClickTaleCreateDOMElement) != "function")
{
	ClickTaleCreateDOMElement = function(tagName)
	{
		if (document.createElementNS)
		{
			return document.createElementNS('http://www.w3.org/1999/xhtml', tagName);
		}
		return document.createElement(tagName);
	}
}

if (typeof (ClickTaleAppendInHead) != "function")
{
	ClickTaleAppendInHead = function(element)
	{
		var parent = document.getElementsByTagName('head').item(0) || document.documentElement;
		parent.appendChild(element);
	}
}

if (typeof (ClickTaleXHTMLCompliantScriptTagCreate) != "function")
{
	ClickTaleXHTMLCompliantScriptTagCreate = function(code)
	{
		var script = ClickTaleCreateDOMElement('script');
		script.setAttribute("type", "text/javascript");
		script.text = code;
		return script;
	}
}	
		var configFoundPTC = false;
	
if (ct_dispatcher.configName == 'dev')
{
	configFoundPTC = true;
			(function(){
	var script = ClickTaleXHTMLCompliantScriptTagCreate("\/\/ Copyright 2006-2013 ClickTale Ltd., US Patent Pending\r\n\/\/ PID: 8614\r\n\/\/ WR destination: www09\r\n\/\/ WR version: 14.7\r\n\/\/ Recording ratio: 1.252847E-12\r\n\/\/ Generated on: 12\/2\/2013 10:48:16 AM (UTC 12\/2\/2013 4:48:16 PM)\r\n\r\nvar ClickTaleIsXHTMLCompliant = true;\r\nif (typeof (ClickTaleCreateDOMElement) != \"function\")\r\n{\r\n\tClickTaleCreateDOMElement = function(tagName)\r\n\t{\r\n\t\tif (document.createElementNS)\r\n\t\t{\r\n\t\t\treturn document.createElementNS(\u0027http:\/\/www.w3.org\/1999\/xhtml\u0027, tagName);\r\n\t\t}\r\n\t\treturn document.createElement(tagName);\r\n\t}\r\n}\r\n\r\nif (typeof (ClickTaleAppendInHead) != \"function\")\r\n{\r\n\tClickTaleAppendInHead = function(element)\r\n\t{\r\n\t\tvar parent = document.getElementsByTagName(\u0027head\u0027).item(0) || document.documentElement;\r\n\t\tparent.appendChild(element);\r\n\t}\r\n}\r\n\r\nif (typeof (ClickTaleXHTMLCompliantScriptTagCreate) != \"function\")\r\n{\r\n\tClickTaleXHTMLCompliantScriptTagCreate = function(code)\r\n\t{\r\n\t\tvar script = ClickTaleCreateDOMElement(\u0027script\u0027);\r\n\t\tscript.setAttribute(\"type\", \"text\/javascript\");\r\n\t\tscript.text = code;\r\n\t\treturn script;\r\n\t}\r\n}\t\r\nvar pccScriptElement = ClickTaleCreateDOMElement(\u0027script\u0027);\r\npccScriptElement.type = \"text\/javascript\";\r\npccScriptElement.src = (document.location.protocol==\u0027https:\u0027?\r\n\u0027https:\/\/clicktalecdn.sslcs.cdngc.net\/www09\/pcc\/f4bac7c1-80d7-4c4a-99b2-7636f1b6fcb5.js?DeploymentConfigName=dev&Version=57\u0027:\r\n\u0027http:\/\/cdn.clicktale.net\/www09\/pcc\/f4bac7c1-80d7-4c4a-99b2-7636f1b6fcb5.js?DeploymentConfigName=dev&Version=57\u0027);\r\ndocument.body.appendChild(pccScriptElement);\r\n\t\r\nvar ClickTalePrevOnReady;\r\nif(typeof ClickTaleOnReady == \u0027function\u0027)\r\n{\r\n\tClickTalePrevOnReady=ClickTaleOnReady;\r\n\tClickTaleOnReady=undefined;\r\n}\r\n\r\nif (typeof window.ClickTaleScriptSource == \u0027undefined\u0027)\r\n{\r\n\twindow.ClickTaleScriptSource=(document.location.protocol==\u0027https:\u0027\r\n\t\t?\u0027https:\/\/clicktalecdn.sslcs.cdngc.net\/www\/\u0027\r\n\t\t:\u0027http:\/\/cdn.clicktale.net\/www\/\u0027);\r\n}\r\n\r\n\r\n\/\/ Start of user-defined pre WR code (PreLoad)\r\nwindow.ClickTaleSettings = window.ClickTaleSettings || {};\r\nwindow.ClickTaleSettings.XHRWrapper = {\r\n    Enable: true,\r\n    MaxResponseSize: 1000000,\r\n    RequestFilter: function (method, url) {\r\n        if (url.search(\/component\\\/load-more\\\/xhr\/gi) != -1) {\r\n            return true;\r\n        }\r\n        return false;\r\n    }\r\n}\r\n\r\n\r\nwindow.ClickTaleSettings.CheckAgentSupport = function (defaultHandler, agent) {\r\n    if (agent.t == agent.IE) {\r\n        \/\/ don\u0027t use XDR but allow ajax\r\n        agent.XDR = false;\r\n        window.ClickTaleSettings.ctBoolAgentXDR = true;\r\n        window.ClickTaleSettings.XHRWrapper.AllowWithGet = true; \/\/ allow over get\r\n    }\r\n    return defaultHandler(agent);\r\n}\r\n\/\/ End of user-defined pre WR code\r\n\r\n\r\nvar ClickTaleOnReady = function()\r\n{\r\n\tvar PID=8614, \r\n\t\tRatio=1.252847E-12, \r\n\t\tPartitionPrefix=\"www09\";\r\n\t\t\r\n\t\r\n\t\/\/ Start of user-defined header code (PreInitialize)\r\n\tif (window.WRc) {\r\n    window.WRc();\r\n}\r\n\r\nwindow.ClickTaleCookieDomain = \u0027techrepublic.com\u0027;\n\nClickTaleFetchFromWithCookies.setFromCookie(\/^purs_.*\/);\nClickTaleFetchFromWithCookies.setFromCookie(\/^surs_.*\/);\n\nClickTaleFetchFrom = ClickTaleFetchFromWithCookies.constructFetchFromUrl();\r\n\t\/\/ End of user-defined header code (PreInitialize)\r\n    \r\n\t\r\n\twindow.ClickTaleIncludedOnDOMReady=true;\r\n\twindow.ClickTaleSSL=1;\r\n\t\r\n\tClickTale(PID, Ratio, PartitionPrefix);\r\n\t\r\n\tif((typeof ClickTalePrevOnReady == \u0027function\u0027) && (ClickTaleOnReady.toString() != ClickTalePrevOnReady.toString()))\r\n\t{\r\n    \tClickTalePrevOnReady();\r\n\t}\r\n\t\r\n\t\r\n\t\/\/ Start of user-defined footer code\r\n\t\/\/set custom id to modal iframes\r\nif (typeof ClickTaleSetCustomElementID === \u0027function\u0027 && top != self) {\r\n    jQuery(\u0027.modal-iframe\u0027).map(function (ind, el) {\r\n        var id = \u0027modal-iframe\u0027 + ind;\r\n        ClickTaleSetCustomElementID(el, id);\r\n    });\r\n}\r\n\t\/\/ End of user-defined footer code\r\n\t\r\n};\r\n(function() {\r\n\tvar div = ClickTaleCreateDOMElement(\"div\");\r\n\tdiv.id = \"ClickTaleDiv\";\r\n\tdiv.style.display = \"none\";\r\n\tdocument.body.appendChild(div);\r\n\r\n\tvar externalScript = ClickTaleCreateDOMElement(\"script\");\r\n\texternalScript.src = document.location.protocol==\u0027https:\u0027?\r\n\t  \u0027https:\/\/clicktalecdn.sslcs.cdngc.net\/www\/tc\/WRe7.js\u0027:\r\n\t  \u0027http:\/\/cdn.clicktale.net\/www\/tc\/WRe7.js\u0027;\r\n\texternalScript.type = \u0027text\/javascript\u0027;\r\n\tdocument.body.appendChild(externalScript);\r\n})();\r\n\r\n\r\n\r\n");
	document.body.appendChild(script);	})();
	}
			
	

	// Default configuration
if (!configFoundPTC)
{
			(function(){
	var script = ClickTaleXHTMLCompliantScriptTagCreate("\/\/ Copyright 2006-2013 ClickTale Ltd., US Patent Pending\r\n\/\/ PID: 8614\r\n\/\/ WR destination: www09\r\n\/\/ WR version: 14.2\r\n\/\/ Recording ratio: 1.252847E-12\r\n\/\/ Generated on: 12\/2\/2013 10:48:16 AM (UTC 12\/2\/2013 4:48:16 PM)\r\n\r\nif(!Array.prototype.indexOf) { Array.prototype.indexOf = function(e) { for(var i = 0; i \u003c this.length; i++) { if(this[i] === e) { return i; } } return -1; }; }\r\nif (typeof(ClickTaleHooks) == \u0027undefined\u0027) {\r\n    ClickTaleHooks = {\r\n        Hooks : [\u0027PreLoad\u0027, \u0027AfterPreLoad\u0027, \u0027PreRecording\u0027, \u0027AfterPreRecording\u0027, \u0027AdditionalCustomCode\u0027, \u0027AfterAdditionalCustomCode\u0027],\r\n        RunHook : function (hookName) {\r\n\t\t\tif (typeof window[\"ClickTale\" + hookName + \"Hook\"] === \"function\") window[\"ClickTale\" + hookName + \"Hook\"]();\r\n            var s = \u0027ClickTaleSettings\u0027; if ((ClickTaleHooks.Hooks.indexOf(hookName) \u003c 0) || !(s in window) || !(\u0027PDCHooks\u0027 in window[s]) || !(hookName in window[s].PDCHooks)) return;\r\n            var c = window[s].PDCHooks[hookName]; if (c instanceof Array) for (var i=0;i\u003cc.length;i++) if (typeof(c[i]) == \"function\") c[i](); \r\n            if (typeof(c) == \"function\") c();\r\n        }\r\n    }\r\n}    \r\n\t\r\nvar ClickTaleIsXHTMLCompliant = true;\r\nif (typeof (ClickTaleCreateDOMElement) != \"function\")\r\n{\r\n\tClickTaleCreateDOMElement = function(tagName)\r\n\t{\r\n\t\tif (document.createElementNS)\r\n\t\t{\r\n\t\t\treturn document.createElementNS(\u0027http:\/\/www.w3.org\/1999\/xhtml\u0027, tagName);\r\n\t\t}\r\n\t\treturn document.createElement(tagName);\r\n\t}\r\n}\r\n\r\nif (typeof (ClickTaleAppendInHead) != \"function\")\r\n{\r\n\tClickTaleAppendInHead = function(element)\r\n\t{\r\n\t\tvar parent = document.getElementsByTagName(\u0027head\u0027).item(0) || document.documentElement;\r\n\t\tparent.appendChild(element);\r\n\t}\r\n}\r\n\r\nif (typeof (ClickTaleXHTMLCompliantScriptTagCreate) != \"function\")\r\n{\r\n\tClickTaleXHTMLCompliantScriptTagCreate = function(code)\r\n\t{\r\n\t\tvar script = ClickTaleCreateDOMElement(\u0027script\u0027);\r\n\t\tscript.setAttribute(\"type\", \"text\/javascript\");\r\n\t\tscript.text = code;\r\n\t\treturn script;\r\n\t}\r\n}\t\r\n\r\nvar ClickTalePrevOnReady;\r\nif(typeof ClickTaleOnReady == \u0027function\u0027)\r\n{\r\n\tClickTalePrevOnReady=ClickTaleOnReady;\r\n\tClickTaleOnReady=undefined;\r\n}\r\n\r\nif (typeof window.ClickTaleScriptSource == \u0027undefined\u0027)\r\n{\r\n\twindow.ClickTaleScriptSource=(document.location.protocol==\u0027https:\u0027\r\n\t\t?\u0027https:\/\/clicktalecdn.sslcs.cdngc.net\/www\/\u0027\r\n\t\t:\u0027http:\/\/cdn.clicktale.net\/www\/\u0027);\r\n}\r\n\r\nClickTaleHooks.RunHook(\u0027PreLoad\u0027);\r\n\/\/ Start of user-defined pre WR code (PreLoad)\r\n\r\n\/\/ End of user-defined pre WR code\r\nClickTaleHooks.RunHook(\u0027AfterPreLoad\u0027);\r\n\r\nvar ClickTaleOnReady = function()\r\n{\r\n\tvar PID=8614, \r\n\t\tRatio=1.252847E-12, \r\n\t\tPartitionPrefix=\"www09\";\r\n\t\t\r\n\tClickTaleHooks.RunHook(\u0027PreRecording\u0027);\r\n\t\/\/ Start of user-defined header code (PreInitialize)\r\n\tClickTaleFetchFromWithCookies.setFromCookie(\/^purs_.*\/);\nClickTaleFetchFromWithCookies.setFromCookie(\/^surs_.*\/);\n\nClickTaleFetchFrom = ClickTaleFetchFromWithCookies.constructFetchFromUrl();\r\n\t\/\/ End of user-defined header code (PreInitialize)\r\n    ClickTaleHooks.RunHook(\u0027AfterPreRecording\u0027);\r\n\t\r\n\twindow.ClickTaleIncludedOnDOMReady=true;\r\n\twindow.ClickTaleSSL=1;\r\n\t\r\n\tClickTale(PID, Ratio, PartitionPrefix);\r\n\t\r\n\tif((typeof ClickTalePrevOnReady == \u0027function\u0027) && (ClickTaleOnReady.toString() != ClickTalePrevOnReady.toString()))\r\n\t{\r\n    \tClickTalePrevOnReady();\r\n\t}\r\n\t\r\n\tClickTaleHooks.RunHook(\u0027AdditionalCustomCode\u0027);\r\n\t\/\/ Start of user-defined footer code\r\n\t\r\n\t\/\/ End of user-defined footer code\r\n\tClickTaleHooks.RunHook(\u0027AfterAdditionalCustomCode\u0027);\r\n};\r\n(function() {\r\n\tvar div = ClickTaleCreateDOMElement(\"div\");\r\n\tdiv.id = \"ClickTaleDiv\";\r\n\tdiv.style.display = \"none\";\r\n\tdocument.body.appendChild(div);\r\n\r\n\tvar externalScript = ClickTaleCreateDOMElement(\"script\");\r\n\texternalScript.src = document.location.protocol==\u0027https:\u0027?\r\n\t  \u0027https:\/\/clicktalecdn.sslcs.cdngc.net\/www\/tc\/WRe2.js\u0027:\r\n\t  \u0027http:\/\/cdn.clicktale.net\/www\/tc\/WRe2.js\u0027;\r\n\texternalScript.type = \u0027text\/javascript\u0027;\r\n\tdocument.body.appendChild(externalScript);\r\n})();\r\n\r\n\r\n\r\n");
	document.body.appendChild(script);	})();
	}

