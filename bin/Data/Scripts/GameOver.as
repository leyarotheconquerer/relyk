class GameOver : ScriptObject
{
	String dialog_;
	String style_;

	GameOver()
	{
		dialog_ = "UI/GameOver.xml";
		style_ = "UI/RelykStyle.xml";
	}

	void DelayedStart()
	{
		Node@ modelNode = node.GetChild("Model", true);
		SubscribeToEvent(modelNode, "AnimationTrigger", "HandleDeathAnimationTrigger");
	}

	void Save(Serializer& serializer)
	{
		serializer.WriteString(dialog_);
		serializer.WriteString(style_);
	}

	void Load(Deserializer& deserializer)
	{
		dialog_ = deserializer.ReadString();
		style_ = deserializer.ReadString();
	}

	void HandleDeathAnimationTrigger(StringHash type, VariantMap& data)
	{
		log.Debug("Saw an animation trigger");
		if (data["Data"].GetString() == "Complete")
		{
			UIElement@ element = ui.root.LoadChildXML(
				cache.GetResource("XMLFile", dialog_),
				cache.GetResource("XMLFile", style_)
			);

			Button@ exit = element.GetChild("ExitButton", true);
			// Button@ restart = element.GetChild("RestartButton", true);

			SubscribeToEvent(exit, "Pressed", "HandleExitPressed");
			// SubscribeToEvent(restart, "Pressed", "HandleRestartPressed");
		}
	}

	void HandleExitPressed(StringHash type, VariantMap& data)
	{
		engine.Exit();
	}

	void HandleRestartPressed(StringHash type, VariantMap& data)
	{
		VariantMap levelData;
		levelData["Name"] = "New Level";
		levelData["Level"] = "Scenes/TestScene.xml";
		SendEvent("LevelStart", levelData);
	}
}