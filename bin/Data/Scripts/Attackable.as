#include "Scripts/Constants.as"

class Attackable : ScriptObject
{
	int healthPoints_;
	int maxHealthPoints_;
	int scorePoints_;
	String team_;
	String type_;
	Billboard@ health_;
	int healthSize_;

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
		Node@ healthNode = node.GetChild("Health", true);
		BillboardSet@ set = healthNode.GetComponent("BillboardSet");
		health_ = set.billboards[0];
		healthSize_ = health_.size.x;
		Node@ modelNode = node.GetChild("Model", true);
		SubscribeToEvent(modelNode, "AnimationTrigger", "HandleDeathAnimationTrigger");
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
		// Dead units can't be attacked
		if (healthPoints_ <= 0)
		{
			return;
		}

		int damage = data["Damage"].GetInt();
		bool typeMatch = data["Type"].GetString() == type_;
		if (typeMatch)
		{
			damage = damage * TYPE_MULTIPLIER;
		}

		healthPoints_ -= damage;
		log.Debug(node.name + " (" + node.id + ") HP " + healthPoints_ + " = " + (healthPoints_ + damage) + " - " + damage);
		healthPoints_ = healthPoints_ < 0 ? 0 : healthPoints_;

		health_.size.x = int(healthSize_ * (float(healthPoints_) / maxHealthPoints_));
		VariantMap damageData;
		damageData["Damage"] = damage;
		damageData["TypeMatch"] = typeMatch;
		damageData["Health"] = healthPoints_;
		damageData["MaxHealth"] = maxHealthPoints_;
		SendEvent("UnitDamaged", damageData);

		if (healthPoints_ <= 0)
		{
			health_.enabled = false;
			log.Info(node.name + " (" + node.id + ") is dead");
			DisableNode(node);
			VariantMap deathAnimData;
			deathAnimData["State"] = "Die";
			node.SendEvent("UnitAnimate", deathAnimData);
		}
	}

	void HandleDeathAnimationTrigger(StringHash type, VariantMap& data)
	{
		log.Debug("Animation says hello: " + data["Data"].GetString() + " (" + data["Name"].GetString() + ")");
		if (data["Data"].GetString() == "Complete")
		{
			VariantMap deathData;
			deathData["Team"] = team_;
			deathData["Type"] = type_;
			deathData["Node"] = node;
			deathData["Score"] = scorePoints_;
			SendEvent("UnitDied", deathData);
			if (node.GetScriptObject("GameOver") is null)
			{
				node.Remove();
			}
		}
	}

	void DisableNode(Node@ node)
	{
		Array<Component@> components = node.GetComponents();
		for(uint i = 0; i < components.length; i++)
		{
			if (components[i].typeName == "ScriptInstance")
			{
				ScriptInstance@ instance = cast<ScriptInstance>(components[i]);
				if (
					not instance.IsA("Attackable") &&
					not instance.IsA("Animated") &&
					not instance.IsA("GameOver")
				) {
					instance.Remove();
					components[i].Remove();
				}
			}
		}
	}
}