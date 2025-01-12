extends CanvasGroup

@export var shader: Shader

func _ready() -> void:
    material = ShaderMaterial.new()
    material.shader = shader

func _input(event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        material.set("shader_parameter/mouse_position", event.position / get_viewport_rect().size)
