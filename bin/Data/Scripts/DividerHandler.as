class DividerHandler : ScriptObject
{
	VariantMap aiCount;
	VariantMap playerCount;

	void Start()
	{
		Array<String> types;
		types.Push("cuboid");
		types.Push("spheroid");
		types.Push("pyramoid");

		for(uint i = 0; i < types.length; i++)
		{
			aiCount[types[i]] = 0;
			playerCount[types[i]] = 0;
		}

		SubscribeToEvent("UnitDied", "HandleUnitDied");
		SubscribeToEvent("UnitSpawn", "HandleUnitSpawn");
	}

	void DelayedStart()
	{
	}

	void Save(Serializer& serializer)
	{
	}

	void Load(Deserializer& deserializer)
	{
	}

	void Stop()
	{
		UnsubscribeFromEvent("UnitDied");
		UnsubscribeFromEvent("UnitSpawn");
	}

	void HandleUnitDied(StringHash type, VariantMap& data)
	{
		log.Debug("I've seen a death");
		String team = data["Team"].GetString();
		String unitType = data["Type"].GetString();
		int divider = 1;
		if (team == "ai")
		{
			aiCount[unitType] = aiCount[unitType].GetInt() - 1;
			aiCount[unitType] = aiCount[unitType].GetInt() < 0 ? 0 : aiCount[unitType].GetInt();
			divider = aiCount[unitType].GetInt() > divider ? aiCount[unitType].GetInt() : divider;
		}
		else if (team == "player")
		{
			playerCount[unitType] = playerCount[unitType].GetInt() - 1;
			playerCount[unitType] = playerCount[unitType].GetInt() < 0 ? 0 : playerCount[unitType].GetInt();
			divider = playerCount[unitType].GetInt() > divider ? playerCount[unitType].GetInt() : divider;
		}
		log.Debug("Unit death results in " + team + " - " + unitType + " divider of " + divider);
		VariantMap dividerData;
		dividerData["Team"] = team;
		dividerData["Type"] = unitType;
		dividerData["Divider"] = divider;
		SendEvent("UnitDivider", dividerData);
	}

	void HandleUnitSpawn(StringHash type, VariantMap& data)
	{
		log.Debug("I've seen a spawn");
		String team = data["Team"].GetString();
		String unitType = data["Type"].GetString();
		int divider = 1;
		if (team == "ai")
		{
			aiCount[unitType] = aiCount[unitType].GetInt() + 1;
			divider = aiCount[unitType].GetInt() > divider ? aiCount[unitType].GetInt() : divider;
		}
		else if (team == "player")
		{
			playerCount[unitType] = playerCount[unitType].GetInt() + 1;
			divider = playerCount[unitType].GetInt() > divider ? playerCount[unitType].GetInt() : divider;
		}
		log.Debug("Unit spawn results in " + team + " - " + unitType + " divider of " + divider);
		VariantMap dividerData;
		dividerData["Team"] = team;
		dividerData["Type"] = unitType;
		dividerData["Divider"] = divider;
		SendEvent("UnitDivider", dividerData);
	}
}