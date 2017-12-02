const int TYPE_MULTIPLIER = 2;

class Attackable : ScriptObject
{
	int healthPoints_;
	int maxHealthPoints_;
	String type_;

	Attackable()
	{
		maxHealthPoints_ = 100;
		healthPoints_ = maxHealthPoints_;
		type_ = "cuboid";
	}

	void Start()
	{
		SubscribeToEvent(node, "UnitAttack", "HandleUnitAttack");
	}

	void DelayedStart()
	{
	}

	void Save(Serializer& serializer)
	{
		serializer.WriteInt(healthPoints_);
		serializer.WriteInt(maxHealthPoints_);
		serializer.WriteString(type_);
	}

	void Load(Deserializer& deserializer)
	{
		healthPoints_ = deserializer.ReadInt();
		maxHealthPoints_ = deserializer.ReadInt();
		type_ = deserializer.ReadString();
	}

	void HandleUnitAttack(StringHash type, VariantMap& data)
	{
		int damage = data["Damage"].GetInt();
		bool typeMatch = data["Type"].GetString() == type_;
		if (typeMatch)
		{
			damage = damage * TYPE_MULTIPLIER;
		}

		healthPoints_ -= damage;
		log.Debug(node.name + " (" + node.id + ") HP " + healthPoints_ + " = " + (healthPoints_ + damage) + " - " + damage);
		healthPoints_ = healthPoints_ < 0 ? 0 : healthPoints_;

		VariantMap damageData;
		damageData["Damage"] = damage;
		damageData["TypeMatch"] = typeMatch;
		damageData["Health"] = healthPoints_;
		damageData["MaxHealth"] = maxHealthPoints_;
		SendEvent("UnitDamaged", damageData);

		if (healthPoints_ <= 0)
		{
			log.Info(node.name + " (" + node.id + ") is dead");
			VariantMap deathData;
			deathData["Type"] = type_;
			deathData["Node"] = node;
			SendEvent("UnitDied", deathData);
		}
	}
}