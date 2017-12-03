class PlayerPoints : ScriptObject
{
	int points_;
	VariantMap prices_;

	String cuboid_;
	String spheroid_;
	String pyramoid_;

	void Start()
	{
		prices_["cuboid"] = 1;
		prices_["spheroid"] = 2;
		prices_["pyramoid"] = 3;
		cuboid_ = "Objects/Cuboid.xml";
		spheroid_ = "Objects/Spheroid.xml";
		pyramoid_ = "Objects/Pyramoid.xml";
		points_ = 0;
		SubscribeToEvent("UnitDied", "HandleUnitDied");
		SubscribeToEvent("UnitPurchase", "HandlePlayerPurchase");
	}

	void DelayedStart()
	{
		SendScoreUpdate(0, 0);
	}

	void Save(Serializer& serializer)
	{
		serializer.WriteString(cuboid_);
		serializer.WriteString(spheroid_);
		serializer.WriteString(pyramoid_);
	}

	void Load(Deserializer& deserializer)
	{
		cuboid_ = deserializer.ReadString();
		spheroid_ = deserializer.ReadString();
		pyramoid_ = deserializer.ReadString();
	}

	void Stop()
	{
		UnsubscribeFromEvent("UnitDied");
	}

	void HandleUnitDied(StringHash type, VariantMap& data)
	{
		if (data["Team"].GetString() == "ai")
		{
			int score = data["Score"].GetInt();
			points_ += score;
			SendScoreUpdate(score, 0);
		}
	}

	void SendScoreUpdate(int new, int spent)
	{
		log.Info("Player score " + points_ + " (+" + new + ", -" + spent + ")");
		VariantMap scoreData;
		scoreData["Total"] = points_;
		scoreData["New"] = new;
		scoreData["Spent"] = spent;
		SendEvent("PlayerScore", scoreData);
	}

	void HandlePlayerPurchase(StringHash type, VariantMap& data)
	{
		String unitType = data["Type"].GetString();
		String resource;
		int price;
		if (unitType == "cuboid")
		{
			price = 1;
			resource = cuboid_;
		}
		else if (unitType == "spheroid")
		{
			price = 2;
			resource = spheroid_;
		}
		else if (unitType == "pyramoid")
		{
			price = 3;
			resource = pyramoid_;
		}
		log.Debug("Trying to spawn a " + unitType + " costing " + price + " ("+ points_+")");
		if(points_ >= price)
		{
			points_ -= price;
			Node@ node = scene.InstantiateXML(
				cache.GetResource("XMLFile", resource),
				data["Target"].GetVector3(),
				Quaternion()
			);
			VariantMap spawnData;
			spawnData["Team"] = "player";
			spawnData["Type"] = unitType;
			SendEvent("UnitSpawn", spawnData);
		}
		else
		{
			log.Warning("Can't build without more points (need " + price + " have " + points_ + ")");
		}
	}
}
