class Bullet : ScriptObject
{
	Node@ target_;
	Node@ attacker_;
	String type_;
	int damage_;

	float delay_;
	float elapsed_;

	void Start()
	{
		log.Debug("Bullet created");
		SubscribeToEvent(node, "BulletFire", "HandleBulletFire");
	}

	void DelayedStart()
	{
	}

	void Save(Serializer& serializer)
	{
		serializer.WriteFloat(delay_);
	}

	void Load(Deserializer@ deserializer)
	{
		delay_ = deserializer.ReadFloat();
	}

	void FixedUpdate(float timestep)
	{
		if (target_ !is null)
		{
			Node@ targetCenter = target_.GetChild("Center");
			if (targetCenter !is null)
			{
				elapsed_ += timestep * 1000;
				node.worldPosition = node.worldPosition.Lerp(
					targetCenter.worldPosition,
					elapsed_ / delay_
				);
				if ((targetCenter.worldPosition - node.worldPosition).lengthSquared < 0.1)
				{
					log.Debug("Arrived at target, sending event");
					VariantMap attackData;
					attackData["Attacker"] = attacker_;
					attackData["Type"] = type_;
					attackData["Damage"] = damage_;
					target_.SendEvent("UnitAttack", attackData);
					node.Remove();
				}
			}
		}
	}

	void HandleBulletFire(StringHash type, VariantMap& data)
	{
		log.Debug("Beginning to fire");
		target_ = data["Target"].GetPtr();
		attacker_ = data["Attacker"].GetPtr();
		damage_ = data["Damage"].GetInt();
		type_ = data["Type"].GetString();
		elapsed_ = 0;
	}
}