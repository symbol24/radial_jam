extends Node


# Scene Manager
signal LoadScene(id:StringName, loading_screen:bool)
signal SceneLoaded(id:StringName)

# UI
signal ToggleLoadingScreen(toggle:bool)
signal ToggleUi(ui_id:StringName, display:bool)
signal NotEnoughMaterial()

# Radial Menu
signal ToggleRadialMenu(radial_menu:StringName, display:bool, pos:Vector2)
signal ItemSelected(radial_menu:StringName, item_selected:StringName)

# Star Material
signal StarMaterialCollected(star_material:StarMaterial)

# Game
signal LevelUpgraded(level:int)
signal Unlocked(id:int)

# Ship
signal TotalMaterialUpdated(value:int)
signal CurrentMaterialUpdated(value:int)
signal DebugAddMaterial(value:int)
signal UpgradeAdded(id:StringName, new_total:int)
signal UpgradeCost(cost:int)

# Black Hole
signal BlackHoleSwallowedMaterial(value:int)
