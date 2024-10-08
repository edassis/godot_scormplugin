@tool
extends Node
signal setScormValue(atribute,value)
signal getScormValue(atribute,value)
@export var emmit_return_on_set:bool
var attributes:Dictionary

func _ready():
	setScormValue.connect(_setScormValue)

func _setScormValue(attribute,value):
	JavaScriptBridge.eval("ScormProcessSetValue('"+attribute+"', '"+str(value)+"')");
	var return_val = str(JavaScriptBridge.eval("ScormProcessGetValue('"+attribute+"');"))
	if(emmit_return_on_set):
		getScormValue.emit(attribute,return_val)
	attributes[attribute] = return_val
	return return_val
	
func _getScormValue(attribute):
	var return_val = null
	if(attributes.has(attribute)):
		return_val = attributes[attribute]
	else:
		return_val = str(JavaScriptBridge.eval("ScormProcessGetValue('"+attribute+"');"))
		attributes[attribute] = return_val
	if(!return_val):
		return_val = "null"
	getScormValue.emit(attribute,return_val)
	return return_val
