class KeyboardHandler : ScriptObject
{
	NavigationMesh@ navMesh_;

	void Start()
	{
		SubscribeToEvent("KeyDown", "HandleKeyDown");
		SubscribeToEvent("PostRenderUpdate", "HandlePostRenderUpdate");
	}

	void DelayedStart()
	{
		navMesh_ = scene.GetComponent("NavigationMesh");
		navMesh_.Build();
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

	void HandlePostRenderUpdate(StringHash type, VariantMap& data)
	{
		if (input.keyDown[KEY_N])
		{
			navMesh_.DrawDebugGeometry(debugRenderer, true);
		}
	}
}