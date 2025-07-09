class_name RuneData
extends Resource

enum Raresa {Common, Uncommon, Rare}

@export var raresa: Raresa
@export var name: String
@export_multiline var description: String
@export var texture: Texture2D
