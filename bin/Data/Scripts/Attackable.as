#include "Scripts/Constants.as"

class Attackable : ScriptObject
{
	int healthPoints_;
	int maxHealthPoints_;
	int scorePoints_;
	String team_;
	String type_;

	Attackable()
	{
		maxHealthPoints_ = 100;
		healthPoints_ = maxHealthPoints_;
		scorePoints_ = 1;
		type_ = "cuboid";
		team_ = "player";
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
		serializer.WriteInt(scorePoints_);
		serializer.WriteString(type_);
		serializer.WriteString(team_);
	}

	void Load(Deserializer& deserializer)
	{
		healthPoints_ = deserializer.ReadInt();
		maxHealthPoints_ = deserializer.ReadInt();
		scorePoints_ = deserializer.ReadInt();
		type_ = deserializer.ReadString();
		team_ = deserializer.ReadString();
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
			deathData["Team"] = team_;
			deathData["Type"] = type_;
			deathData["Node"] = node;
			deathData["Score"] = scorePoints_;
			SendEvent("UnitDied", deathData);
			node.Remove();
		}
	}
}