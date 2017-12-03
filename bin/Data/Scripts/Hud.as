class Hud : ScriptObject
{
	String hud_;
	String style_;

	Node@ PlayerSpawn;

	Text@ ScoreText;
	Text@ CuboidText;
	Text@ SpheroidText;
	Text@ PyramoidText;

	UIElement@ CuboidBar;
	UIElement@ SpheroidBar;
	UIElement@ PyramoidBar;

	int BarHeight;

	Hud()
	{
		hud_ = "UI/GameHud.xml";
		style_ = "UI/RelykStyle.xml";
	}

	void Start()
	{
	}

	void DelayedStart()
	{
		UIElement@ element = ui.root.LoadChildXML(
			cache.GetResource("XMLFile", hud_),
			cache.GetResource("XMLFile", style_)
		);
		ScoreText = element.GetChild("ScoreText", true);
		UIElement@ powerWindow = element.GetChild("PowerWindow", true);
		UIElement@ cuboidSection = powerWindow.GetChild("Cuboid", true);
		CuboidBar = cuboidSection.GetChild("Count", true);
		CuboidText = cuboidSection.GetChild("CountText", true);
		BarHeight = cuboidSection.GetChild("Total", true).height;
		UIElement@ spheroidSection = powerWindow.GetChild("Cuboid", true);
		SpheroidBar = spheroidSection.GetChild("Count", true);
		SpheroidText = spheroidSection.GetChild("CountText", true);
		UIElement@ pyramoidSection = powerWindow.GetChild("Cuboid", true);
		PyramoidBar = pyramoidSection.GetChild("Count", true);
		PyramoidText = pyramoidSection.GetChild("CountText", true);

		UIElement@ purchaseWindow = element.GetChild("PurchaseWindow", true);
		Button@ cuboidButton = purchaseWindow.GetChild("Cuboid").GetChild("Purchase");
		Button@ spheroidButton = purchaseWindow.GetChild("Spheroid").GetChild("Purchase");
		Button@ pyramoidButton = purchaseWindow.GetChild("Pyramoid").GetChild("Purchase");

		PlayerSpawn = scene.GetChild("PlayerSpawn", true);

		SubscribeToEvent(cuboidButton, "Pressed", "HandleCuboidPurchase");
		SubscribeToEvent(spheroidButton, "Pressed", "HandleSpheroidPurchase");
		SubscribeToEvent(pyramoidButton, "Pressed", "HandlePyramoidPurchase");

		CuboidText.text = 1;
		SpheroidText.text = 0;
		PyramoidText.text = 0;

		CuboidBar.height = BarHeight;
		SpheroidBar.height = 0;
		PyramoidBar.height = 0;

		SubscribeToEvent("PlayerPoints", "HandlePlayerPoints");
		SubscribeToEvent("UnitDivider", "HandleUnitDivider");
	}

	void Save(Serializer& serializer)
	{
		serializer.WriteString(hud_);
		serializer.WriteString(style_);
	}

	void Load(Deserializer& deserializer)
	{
		hud_ = deserializer.ReadString();
		style_ = deserializer.ReadString();
	}

	void Stop()
	{
	}

	void HandlePlayerPoints(StringHash type, VariantMap& data)
	{
		ScoreText.text = data["Total"].GetInt();
	}

	void HandleUnitDivider(StringHash type, VariantMap& data)
	{
		String team = data["Team"].GetString();
		if (team == "player")
		{
			String unitType = data["Type"].GetString();
			int divider = data["Divider"].GetInt();

			if (unitType == "cuboid")
			{
				CuboidBar.height = int(BarHeight * (1.0f / divider));
				CuboidText.text = divider;
			}
			else if (unitType == "spheroid")
			{
				SpheroidBar.height = int(BarHeight * (1.0f / divider));
				SpheroidText.text = divider;
			}
			else if (unitType == "pyramoid")
			{
				PyramoidBar.height = int(BarHeight * (1.0f / divider));
				PyramoidText.text = divider;
			}
		}
	}

	void HandleCuboidPurchase(StringHash type, VariantMap& data)
	{
		SendPurchase("cuboid");
	}

	void HandleSpheroidPurchase(StringHash type, VariantMap& data)
	{
		SendPurchase("spheroid");
	}

	void HandlePyramoidPurchase(StringHash type, VariantMap& data)
	{
		SendPurchase("pyramoid");
	}

	void SendPurchase(String type)
	{
		VariantMap purchaseData;
		purchaseData["Team"] = "player";
		purchaseData["Type"] = type;
		purchaseData["Target"] = PlayerSpawn.position;
		SendEvent("UnitPurchase", purchaseData);
	}
}