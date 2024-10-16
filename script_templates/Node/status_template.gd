# meta-name: Status
# meta-description: Create a status which can be applied to a target.
class_name MyAwesomeStatus
extends Status

var member_var := 0

func initialize_status(target: Node) -> void:
	print("initialize my status for target %s" % target)
	

func apply_status(target: Node) -> void:
	print("my status target %s" % target)
	print("it does %s something" % member_var)
	
	status_applied.emit(self)
