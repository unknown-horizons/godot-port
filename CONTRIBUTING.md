# Contributing guidelines

- [Project goals](#project-goals)
- [How to contribute](#how-to-contribute)
- [Requirements to contribute](#requirements-to-contribute)
- [Setting up the development environment](#setting-up-the-development-environment)
- [Coding guidelines](#coding-guidelines)

## Project goals

- Right now the main objective is to port over the [original project](https://github.com/unknown-horizons/unknown-horizons)'s existing feature set and assets and make a playable version out of it.

- The secondary goal will be to expand it to completion and add features entirely missing in the original, like military and the higher town tiers.

- The third stage involves reevaluating the existing content for potential asset rework, upscaled graphics, rebalancing etc.

*However, contributors are not obligated to strictly follow this order; it's first of all a lineup to point out the priorities from high to low. You're free to contribute anything valuable to the project and depending on its complexity and current relevance it will be merged now or at a later stage of the game.*

## How to contribute

To contribute to the project, get started by checking the [current issues](https://github.com/unknown-horizons/godot-port/issues) or [add a new one](https://github.com/unknown-horizons/godot-port/issues/new/choose) for bug reports and suggestions. Also, as this is a complete rewrite, it is basically possible to apply improvements on certain aspects of the game from the start on whenever it makes sense. That said, if you know and love the original title and are well familiar with its in and outs, we'd appreciate your opinion on the current gameplay mechanics and economic balances. To discuss more directly with other contributors, visit our [Discord server](https://discord.gg/VX6m2ZX).

At the point of this writing, the Godot port is in an early experimental state with no playable content and therefore no release date set in stone.

For that reason, please check out the [original project](https://github.com/unknown-horizons/unknown-horizons) which bears a decade long active development history with tons of implemented features and will provide you a better insight on the desired look and feel than any textual explanation could do (even more so if being unfamiliar with RTS games). Besides you should be able to grab existing logic and convert it appropriately for the Godot/GDScript style.

## Requirements to contribute

This project is based on the [Godot Engine](https://godotengine.org/) using a [Python-like scripting language](https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/gdscript_basics.html). To learn more about it, get started at [the official docs](https://docs.godotengine.org/en/stable/).

For further learning resources made by individual creators, you can find a rich overview of qualitative material enlisted [here](https://docs.godotengine.org/en/stable/community/tutorials.html).

A valuable source of information specifically for this project would be RTS-specific Godot material.

## Setting up the development environment

1. Fork <https://github.com/unknown-horizons/godot-port>.
1. Clone the fork locally.
1. Download [Godot 4.x.x](https://godotengine.org/download/), at least the standard version required.
1. Launch the Godot executable.
1. Import project, search the Unknown Horizons directory, select `project.godot`.
1. Open the project from the project manager overview.

## Coding guidelines

For the most part, the code style follows the [official GDScript style guide](https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/gdscript_styleguide.html).

Rules different from the official style and additional remarks:

- `class_name` (if present) succeeds the `extends` line. Think of it like "include the base class, and now add the following additional logic under the name of `class_name`":

```gdscript
extends Node
class_name InheritedNode
```

- [Static typing](https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/static_typing.html). Everytime, everywhere. Use [explicit types](https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/gdscript_styleguide.html#declared-types) or [infer the type](https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/gdscript_styleguide.html#inferred-types). In most cases, inferring with `:=` should be fine unless the exact type is indeterminable at compile-time. Make [type casts](https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/static_typing.html#variable-casting) whenever useful. This will make the code overall [less prone to errors](https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/static_typing.html#safe-lines). Custom signals (as of now) are dynamically typed only, so at least we will make it "static" to the developer by the following convention:

```gdscript
signal notification(message_type, message_text) # int, String
```

- Some methods return values that may be irrelevant depending on your use case, like `SceneTree.change_scene_to()` or `Object.connect()`. To suppress the warning dispatched by those, hit the `[Ignore]` button next to the warning message in Godot's warnings overview. This generates a specific line to explicitly acknowledge this circumstance. Indent it above the involved method call. That should look like this:

```gdscript
#warning-ignore:return_value_discarded
get_tree().change_scene_to(_scenes[scene])
```

- For warnings about unused method parameters however, prepend the parameter(s) in question with an underscore like this:

```gdscript
func _process(_delta: float) -> void:
    pass
```

- Generally, **one** line break is to be placed where it says **two** in the official guide.

As always, there may be an exception from the rule, but those should be kept to a minimum and be reasonable.
