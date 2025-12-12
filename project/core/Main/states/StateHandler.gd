class_name StateHandler;
extends Resource;

# run after the previous state's `unload`
func load():
    pass ;

# tries running every processing frame when the state us active
@warning_ignore("unused_parameter")
func run(main) -> void:
    pass ;

# run before next state's `load`
func unload():
    pass ;

# run after the next state's `load` (useful for things like loading screens that should only be removed after the next scene is fully loaded)
func handoff():
    pass ;