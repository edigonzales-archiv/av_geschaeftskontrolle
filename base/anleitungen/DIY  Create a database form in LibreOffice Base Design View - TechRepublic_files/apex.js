var AWS_COMMON=function(){var user,aStart,serv="apex",domain="techrepublic.com",port="",params="",doCallback=true,maxTime=750,callTime=0,callStatus=1;var cbsiAdLocal={};var dvarsReturned="";var options={};if(typeof String.prototype.trim!=="function"){String.prototype.trim=function(){return this.replace(/^\s+|\s+$/g,"")}}var AudEng={};AudEng.Apex={utils:{extend:function(target,source){target=target||{};source=source||{};for(var property in source){if(source.hasOwnProperty(property)){target[property]=source[property]}}return target},isEmpty:function(object){return(object===null||object===undefined||(typeof(object)==="string"&&object.trim()==="")||(object.hasOwnProperty("length")&&object.length===0))},startsWith:function(checkString,prefix){return(checkString.match("^"+prefix)==prefix)},contains:function(checkString,substring){var pattern=new RegExp(substring);return !AudEng.Apex.utils.isEmpty(checkString.match(pattern))},appendLegacyParams:function(pageParams,callback){var validParams={refUrl:true,sId:true,ptId:true,onId:true,asId:true,cId:true,pId:true,nCat:true,edId:true,regSys:true,regId:true,lgnSts:true,t:true,offerId:true,anonId:true,tsId:true};AudEng.Apex.utils.appendParameters(pageParams,validParams,callback)},appendDwPageParams:function(pageParams,callback){var validParams={siteid:true,rsid:true,assetguid:true,assettitle:true,assettype:true,authorid:true,author:true,topicguid:true,topic:true,topicbrcrm:true,pagetype:true,sitetype:true,pubdate:true,devicetype:true,tag:true,ttag:true,viewguid:true,pguid:true,xfef:true,xrq:true,srcurl:true,title:true,clgf:true,globid:true,ts:true,brflv:true,brscrsz:true,brwinsz:true,brlang:true,section:true,edition:true};AudEng.Apex.utils.appendParameters(pageParams,validParams,callback)},appendParameters:function(requestParameters,validParams,callback){var nameValuePairs=[];var parameterString;for(var parameter in requestParameters){if(requestParameters.hasOwnProperty(parameter)){var isValidProperty=validParams[parameter]||AudEng.Apex.utils.startsWith(parameter,"purs_");if(isValidProperty){nameValuePairs.push(parameter+"="+encodeURIComponent(requestParameters[parameter])||"")}}}if(!AudEng.Apex.utils.isEmpty(callback)&&!AudEng.Apex.utils.contains(params,callback)){nameValuePairs.push("callback="+encodeURIComponent(callback))}parameterString=nameValuePairs.join("&");if(!AudEng.Apex.utils.isEmpty(parameterString)){if(!AudEng.Apex.utils.isEmpty(params)){params=params+"&"+parameterString}else{params=parameterString}}},filterBucketIds:function(bucketIds,filters){var filteredIds=[];if(!AudEng.Apex.utils.isEmpty(bucketIds)){var maxBuckets=Math.min(bucketIds.length,options.maxOfferings);var i=0;while(filteredIds.length<maxBuckets&&i<bucketIds.length){var tempBucketId=bucketIds[i];for(var j=0;j<filters.length;++j){var filter=filters[j];if(AudEng.Apex.utils.startsWith(tempBucketId,filter)){tempBucketId=tempBucketId.replace(new RegExp(filter),"");filteredIds.push(tempBucketId);break}}++i}}return filteredIds},appendBucketIds:function(bucketIds,delimiter,targetProperty){bucketIds.push(cbsiAdLocal[targetProperty]);cbsiAdLocal[targetProperty]=bucketIds.join(delimiter).replace(new RegExp(delimiter+"$"),"")}}};var setStartCall=function(){aStart=(new Date()).getTime()};var setStatus=function(){if(callStatus===1){doCallback=false;callStatus=-1}};var jsAppend=function(scriptSrc){var insertionPoint=document.getElementsByTagName("body")[0],js=document.createElement("script");if(!insertionPoint){insertionPoint=document.getElementsByTagName("head")[0]}js.setAttribute("type","text/javascript");js.setAttribute("async","true");js.setAttribute("src",scriptSrc);insertionPoint.appendChild(js)};var setParams=function(cbsiGlobal,callback){var referrer=document.referrer;cbsiGlobal.REGSYS=(cbsiGlobal.REGSYS)?cbsiGlobal.REGSYS:cbsiGlobal.regSys;cbsiGlobal.REGID=(cbsiGlobal.REGID)?cbsiGlobal.REGID:cbsiGlobal.regId;cbsiGlobal.LGNSTS=(cbsiGlobal.LGNSTS)?cbsiGlobal.LGNSTS:cbsiGlobal.lgnSts;var requestParameters=AudEng.Apex.utils.extend({},cbsiGlobal);requestParameters.refUrl=encodeURIComponent(referrer);requestParameters.sId=cbsiGlobal.SITE||"";requestParameters.ptId=cbsiGlobal.PTYPE||"0";requestParameters.onId=cbsiGlobal.NODE||"0";requestParameters.asId=cbsiGlobal.ASID||cbsiGlobal.PID||"0";requestParameters.cId=cbsiGlobal.CID||"0";requestParameters.pId=cbsiGlobal.PID||"0";requestParameters.nCat=cbsiGlobal.NCAT||"";requestParameters.edId=cbsiGlobal.EDITION_ID||"";requestParameters.regSys=cbsiGlobal.REGSYS||"0";requestParameters.regId=cbsiGlobal.REGID||"0";requestParameters.lgnSts=cbsiGlobal.LGNSTS||"0";requestParameters.t=(new Date()).getTime();AudEng.Apex.utils.appendLegacyParams(requestParameters,callback);AudEng.Apex.utils.appendDwPageParams(cbsiGlobal,callback)};var setOptions=function(tempOptions){options.maxOfferings=tempOptions.maxOfferings||10;options.prefixes=tempOptions.prefixes||["dblclk-"]};var getData=function(timeout,serverPath){setStartCall();maxTime=((timeout)?timeout:maxTime);callTime=maxTime;jsAppend("http://"+serv+"."+domain+port+serverPath+params);params="";setTimeout(function(){setStatus()},maxTime)};this.loadArrowData=function(cbsiGlobal,timeout){setParams(cbsiGlobal,"parseArrowResponse");getData(timeout,"/aws/rest/v1.0/arrowUser?")};this.getUser=function(){return user};this.getCallTime=function(){return callTime};this.parseArrowResponse=function(arrowResponse){if(doCallback){callTime=((new Date()).getTime()-aStart);user=eval(arrowResponse);if(user&&!user.Error){var madIds=AudEng.Apex.utils.filterBucketIds(user.userBuckets,["mad-"]);AudEng.Apex.utils.appendBucketIds(madIds,";","DVAR_USER_GROUP");var usergroupIds=AudEng.Apex.utils.filterBucketIds(user.userBuckets,options.prefixes);AudEng.Apex.utils.appendBucketIds(usergroupIds,",","usergroup");dvarsReturned=cbsiAdLocal.DVAR_USER_GROUP}callStatus=0}};this.getDVARsReturned=function(){return dvarsReturned};this.loadOfferData=function(cbsiGlobal,timeout){cbsiAdLocal=cbsiGlobal;setParams(cbsiGlobal,null);getData(timeout,"/aws/rest/v1.0/offerScript?");callTime=((new Date()).getTime()-aStart)};this.showOfferData=function(cbsiGlobal,offerIds,clgfId,regId,timeout){var trackingData=AudEng.Apex.utils.extend({},cbsiGlobal);trackingData.offerId=offerIds;trackingData.anonId=encodeURIComponent(clgfId)||"";trackingData.regId=regId||"";if(user&&!user.Error){trackingData.tsId=encodeURIComponent(user.tempSessionId)||""}setParams(trackingData,null);getData(timeout,"/aws/offer/offerScript?");callTime=((new Date()).getTime()-aStart)};this.runApexTargets=function(cbsiGlobal,timeout,options){var tempOptions=options||{};setOptions(tempOptions);cbsiAdLocal=cbsiGlobal;setParams(cbsiGlobal,"parseArrowResponse");getData(timeout,"/aws/rest/v2.0/apexTarget?");callTime=((new Date()).getTime()-aStart)}};if(!window.cbsiApex){var cbsiApex=new AWS_COMMON();var parseArrowResponse=cbsiApex.parseArrowResponse;var cbsiGetApexUser=cbsiApex.getUser;var cbsiLoadApexData=cbsiApex.loadArrowData;var cbsiLoadOffer=cbsiApex.loadOfferData;var cbsiShowOffer=cbsiApex.showOfferData;var cbsiRunApexTargets=cbsiApex.runApexTargets;var cbsiApexCallTime=cbsiApex.getCallTime;var cbsiGetApexDVARs=cbsiApex.getDVARsReturned};