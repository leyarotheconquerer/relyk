class WaveSpawner : ScriptObject
{
	String cuboid_;
	String spheroid_;
	String pyramoid_;

	uint wave_;
	Node@ waveConfig_;
	Array<Node@> spawners_;

	int killCounter_;

	WaveSpawner()
	{
		cuboid_ = "Objects/EnemyCuboid.xml";
		spheroid_ = "Objects/EnemySpheroid.xml";
		pyramoid_ = "Objects/EnemyPyramoid.xml";
	}

	void Start()
	{
		SubscribeToEvent("UnitDied", "HandleUnitDied");
	}

	void DelayedStart()
	{
		waveConfig_ = scene.GetChild("Waves", true);
		Node@ spawnerNode = scene.GetChild("Spawners", true);
		if (spawnerNode !is null)
		{
			spawners_ = spawnerNode.GetChildren();
		}
		wave_ = 0;
		killCounter_ = 0;

		if (waveConfig_ is null || spawners_ is null)
		{
			log.Error(
				"Unable to spawn wave missing a resource (waves = " + 
				(waveConfig_ !is null) + 
				", spawners = " + 
				(spawners_ !is null) + 
				")"
			);
		}
		else
		{
			SpawnWave();
		}
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
	}

	void HandleUnitDied(StringHash type, VariantMap& data)
	{
		Node@ unit = data["Node"].GetPtr();
		if (unit.HasTag("ai"))
		{
			killCounter_ -= 1;
			killCounter_ = killCounter_ < 0 ? 0 : killCounter_;
		}

		if (killCounter_ <= 0)
		{
			SpawnWave();
		}
	}

	void SpawnWave()
	{
		Array<Node@>@ waves = waveConfig_.GetChildren();
		log.Debug("We have " + waves.length + " waves (" + wave_ + ")");
		Node@ currentWave;
		if (wave_ >= waves.length)
		{
			currentWave = waves[waves.length - 1];
		}
		else
		{
			currentWave = waves[wave_];
		}
		int min = currentWave.vars["Min"].GetInt();
		int max = currentWave.vars["Max"].GetInt();
		Array<String>@ types = currentWave.tags;
		SpawnWave(min, max, types);
		wave_ += 1;
	}

	void SpawnWave(int min, int max, Array<String>@ types)
	{
		log.Debug("Spawning wave (" + min + " to " + max + ") Types:");
		for(uint i = 0; i < types.length; i++)
		{
			log.Debug("  - " + types[i]);
		}
		int count = RandomInt(min, max + 1);
		killCounter_ = count;
		for(int i = 0; i < count; i++)
		{
			int typeIndex = RandomInt(0, types.length);
			String type = types[typeIndex];

			int spawnIndex = RandomInt(0, spawners_.length);
			Node@ spawner = spawners_[spawnIndex];

			String resource;
			if (type == "cuboid")
			{
				resource = cuboid_;
			}
			else if (type == "spheroid")
			{
				resource = spheroid_;
			}
			else if (type == "pyramoid")
			{
				resource = pyramoid_;
			}
			Node@ node = scene.InstantiateXML(
				cache.GetResource("XMLFile", resource),
				spawner.position,
				spawner.rotation
			);
			log.Debug("Spawned " + type + " at spawner " + spawnIndex + " = " + (node !is null));
		}
	}
}