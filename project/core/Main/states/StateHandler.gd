class_name StateHandler;
extends Resource;

# All states must implement this
@warning_ignore("unused_parameter")
func run(main) -> void:
    push_warning("State missing run() implementation");