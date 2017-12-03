class Animated : ScriptObject
{
	AnimationController@ animController;
	String state;

	String idleAnim;
	String attackAnim;
	String dieAnim;

	void Start()
	{
		SubscribeToEvent(node, "UnitAnimate", "HandleUnitAnimate");
	}

	void DelayedStart()
	{
		animController = node.GetComponent("AnimationController", true);
		animController.PlayExclusive(idleAnim, 0, true);
	}

	void Save(Serializer& serializer)
	{
		serializer.WriteString(state);
		serializer.WriteString(idleAnim);
		serializer.WriteString(attackAnim);
		serializer.WriteString(dieAnim);
	}

	void Load(Deserializer& deserializer)
	{
		state = deserializer.ReadString();
		idleAnim = deserializer.ReadString();
		attackAnim = deserializer.ReadString();
		dieAnim = deserializer.ReadString();
	}

	void Update(float timestep)
	{
		if (state == "Idle")
		{
			animController.PlayExclusive(idleAnim, 1, true);
		}
		else if (state == "Attack")
		{
			animController.PlayExclusive(attackAnim, 1, false);
			if (animController.IsAtEnd(attackAnim))
			{
				state == "Idle";
			}
		}
		else if (state == "Die")
		{
			animController.PlayExclusive(dieAnim, 1, false);
		}
	}

	void Stop()
	{
	}

	void HandleUnitAnimate(StringHash type, VariantMap& data)
	{
		state = data["State"].GetString();
		log.Debug(node.id + " (" + node.name + ") playing " + state);
		if (state == "Attack")
		{
			animController.SetTime(attackAnim, 0);
		}
	}
}