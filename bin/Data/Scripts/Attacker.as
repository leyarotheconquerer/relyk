const int ATTACKABLE_LAYER = 4;

class Attacker : ScriptObject
{
	Timer timer_;
	String target_;
	String type_;
	uint attackDelay_;
	float attackRange_;
	int attackStrength_;

	Attacker()
	{
		target_ = "player";
		type_ = "cuboid";
		attackDelay_ = 1000;
		attackRange_ = 10;
		attackStrength_ = 10;
	}

	void Start()
	{
		SubscribeToEvent("PostRenderUpdate", "HandlePostRenderUpdate");
	}

	void DelayedStart()
	{
		timer_.Reset();
	}

	void Save(Serializer& serializer)
	{
		serializer.WriteString(target_);
		serializer.WriteString(type_);
		serializer.WriteInt(attackDelay_);
		serializer.WriteFloat(attackRange_);
		serializer.WriteInt(attackStrength_);
	}

	void Load(Deserializer& deserializer)
	{
		target_ = deserializer.ReadString();
		type_ = deserializer.ReadString();
		attackDelay_ = deserializer.ReadInt();
		attackRange_ = deserializer.ReadFloat();
		attackStrength_ = deserializer.ReadInt();
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
					VariantMap sendData;
					sendData["Damage"] = attackStrength_;
					sendData["Type"] = type_;
					sendData["Attacker"] = node;
					target.SendEvent("UnitAttack", sendData);
				}
			}
			timer_.Reset();
		}
	}

	Node@ GetTarget(Array<RigidBody@>@ bodies)
	{
		Node@ target = null;
		float minDistance = attackRange_ * attackRange_;
		for(uint i = 0; i < bodies.length; i++)
		{
			Node@ other = bodies[i].node;
			if (other.HasTag(target_))
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

	void Stop()
	{
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