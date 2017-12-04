#include "Scripts/Constants.as"

class Attacker : ScriptObject
{
	Timer timer_;
	String team_;
	String type_;
	String bullet_;
	int divider_;
	uint attackDelay_;
	float attackRange_;
	int attackStrength_;
	int maxAttackStrength_;
	Node@ target_;

	Attacker()
	{
		team_ = "player";
		type_ = "cuboid";
		bullet_ = "Objects/Bullet.xml";
		attackDelay_ = 1000;
		attackRange_ = 10;
		attackStrength_ = 10;
		maxAttackStrength_ = 10;
		divider_ = 1;
	}

	void Start()
	{
		SubscribeToEvent("PostRenderUpdate", "HandlePostRenderUpdate");
		SubscribeToEvent("UnitDivider", "HandleUnitDivider");
	}

	void DelayedStart()
	{
		node.AddTag(team_);
		node.AddTag(type_);
		timer_.Reset();

		Node@ modelNode = node.GetChild("Model");
		SubscribeToEvent(modelNode, "AnimationTrigger", "HandleAttackAnimationTrigger");
	}

	void Save(Serializer& serializer)
	{
		serializer.WriteString(team_);
		serializer.WriteString(type_);
		serializer.WriteString(bullet_);
		serializer.WriteInt(attackDelay_);
		serializer.WriteFloat(attackRange_);
		serializer.WriteInt(attackStrength_);
		serializer.WriteInt(maxAttackStrength_);
	}

	void Load(Deserializer& deserializer)
	{
		team_ = deserializer.ReadString();
		type_ = deserializer.ReadString();
		bullet_ = deserializer.ReadString();
		attackDelay_ = deserializer.ReadInt();
		attackRange_ = deserializer.ReadFloat();
		attackStrength_ = deserializer.ReadInt();
		maxAttackStrength_ = deserializer.ReadInt();
	}

	void FixedUpdate(float timestep)
	{
		if (timer_.GetMSec(false) > attackDelay_)
		{
			Array<RigidBody@>@ bodies = physicsWorld.GetRigidBodies(
				Sphere(node.position, attackRange_),
				ATTACKABLE_LAYER
			);

			if (bodies.length > 0)
			{
				Node@ target = GetTarget(bodies);
				if (target !is null)
				{
					target_ = target;
					VariantMap attackAnimData;
					attackAnimData["State"] = "Attack";
					node.SendEvent("UnitAnimate", attackAnimData);
				}
			}
			timer_.Reset();
		}
	}

	void Stop()
	{
		UnsubscribeFromEvent("PostRenderUpdate");
		UnsubscribeFromEvent("UnitDivider");
	}

	Node@ GetTarget(Array<RigidBody@>@ bodies)
	{
		Node@ target = null;
		float minDistance = attackRange_ * attackRange_;
		for(uint i = 0; i < bodies.length; i++)
		{
			Node@ other = bodies[i].node;
			if (not other.HasTag(team_))
			{
				float distance = (other.position - node.position).lengthSquared;
				if (distance < minDistance)
				{
					target = other;
					minDistance = distance;
				}
			}
		}
		return target;
	}

	void HandleUnitDivider(StringHash type, VariantMap& data)
	{
		if (
			data["Team"].GetString() == team_ &&
			data["Type"].GetString() == type_
		) {
			divider_ = data["Divider"].GetInt();
			attackStrength_ = maxAttackStrength_ / divider_;
			attackStrength_ = attackStrength_ < 1 ? 1 : attackStrength_;
			log.Debug(node.name + " (" + node.id + ") reporting divider of " + divider_ + " (attack = " + attackStrength_ + ")");
		}
	}

	void HandleAttackAnimationTrigger(StringHash type, VariantMap& data)
	{
		if (data["Data"] == "Attack" && target_ !is null)
		{
			Node@ center = node.GetChild("Center");
			Node@ bullet = scene.InstantiateXML(
				cache.GetResource("XMLFile", bullet_),
				center.worldPosition,
				node.rotation
			);
			VariantMap sendData;
			sendData["Damage"] = attackStrength_;
			sendData["Type"] = type_;
			sendData["Attacker"] = node;
			sendData["Target"] = target_;
			bullet.SendEvent("BulletFire", sendData);
			// target_.SendEvent("UnitAttack", sendData);
			target_ = null;
		}
	}

	void HandlePostRenderUpdate(StringHash type, VariantMap& data)
	{
		if (
			(input.keyDown[KEY_E] && node.HasTag("debug") && node.HasTag("ai")) ||
			(input.keyDown[KEY_P] && node.HasTag("debug") && node.HasTag("player"))
		) {
			Array<RigidBody@>@ bodies = physicsWorld.GetRigidBodies(
				Sphere(node.position, attackRange_),
				ATTACKABLE_LAYER
			);
			Node@ target = GetTarget(bodies);

			int multiplier = 3;
			for(uint i = 0; i < bodies.length; i++)
			{
				Color color = Color(.5, 0, 0);
				if (target !is null && target.id == bodies[i].node.id)
				{
					color = Color(1, .8, 0);
				}
				debugRenderer.AddLine(node.position + Vector3::UP * multiplier, bodies[i].node.position + Vector3::UP * multiplier, color);
			}

			debugRenderer.AddSphere(
				Sphere(node.position, attackRange_),
				Color(1,.5,0)
			);
		}
	}
}