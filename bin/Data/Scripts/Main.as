Scene@ scene_;
Scene@ newScene_;
Camera@ camera_;

void Start()
{
	log.Debug("The game begins...");
	SubscribeToEvent("LevelStart", "HandleLevelStart");

	VariantMap levelData;
	levelData["Level"] = "Scenes/TestScene.xml";
	levelData["Name"] = "Main Mode";
	SendEvent("LevelStart", levelData);
}

void HandleLevelStart(StringHash type, VariantMap& data)
{
	log.Info("Loading level " + data["Name"].GetString());
	StartScene(data["Level"].GetString());
}

void StartScene(String name)
{
	log.Debug("Start scene");
	newScene_ = Scene();
	newScene_.LoadAsyncXML(cache.GetFile(name));
	SubscribeToEvent("AsyncLoadFinished", "HandleAsyncLoadFinished");
}

void HandleAsyncLoadFinished(StringHash type, VariantMap& data)
{
	log.Debug("Async finished");
	UnsubscribeFromEvent("AsyncLoadFinished");
	newScene_ = data["Scene"].GetPtr();
	SubscribeToEvent("Update", "HandleDelayedStart");
}

void HandleDelayedStart(StringHash type, VariantMap& data)
{
	UnsubscribeFromEvent("Update");
	log.Debug("Final step");

	Node@ cameraNode = newScene_.GetChild("Camera", true);
	Camera@ newCamera = cameraNode.CreateComponent("Camera");

	Viewport@ viewport = Viewport(newScene_, cameraNode.GetComponent("Camera"));
	renderer.viewports[0] = viewport;

	scene_ = newScene_;
	camera_ = newCamera;
	newScene_ = null;
}

void Stop()
{
}