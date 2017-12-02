class KeyboardHandler : ScriptObject
{
	void Start()
	{
		SubscribeToEvent("KeyDown", "HandleKeyDown");
	}

	void DelayedStart()
	{
	}

	void Stop()
	{
	}

	void HandleKeyDown(StringHash type, VariantMap& data)
	{
		if (data["Key"] == KEY_ESCAPE)
		{
			engine.Exit();
		}
	}
}