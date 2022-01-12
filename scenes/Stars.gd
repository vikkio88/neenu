extends MeshInstance


export (NodePath) var TargetPath
onready var TargetNode = get_node(TargetPath)
onready var StartOffset = self.transform.origin - TargetNode.transform.origin

func _process(delta):
	self.transform.origin = TargetNode.transform.origin + StartOffset
