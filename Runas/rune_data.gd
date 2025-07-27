class_name RuneData
extends WeaponAttachment

enum Raresa {Common, Uncommon, Rare}
enum Type {Stat, Cards}
@export var RuneType: Type = Type.Stat
@export var raresa: Raresa = Raresa.Common
@export_multiline var description: String
@export var texture: Texture2D
