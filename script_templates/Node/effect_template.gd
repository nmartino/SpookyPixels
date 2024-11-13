# meta-name: Effect
# meta-description: Create an effect which can be applied to a target
class_name MyAwesomeEffect

extends  Effect

var member_var :=0

func execute(targets: Array[Node], effect: Effect.Type) -> void:
	print("my effect targets them: %s"% targets)
	print("it does %s something" % member_var)
