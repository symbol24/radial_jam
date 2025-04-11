extends Node


# Scene Manager
signal LoadScene(id:StringName, loading_screen:bool)
signal SceneLoaded(id:StringName)


# UI
signal ToggleLoadingScreen(toggle:bool)
