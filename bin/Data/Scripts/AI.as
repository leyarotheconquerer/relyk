enum AiStates
{
	MOVE,
	ATTACK
}

class AI : ScriptObject
{
	float attackRange_;
	uint tickRate_;

	Timer timer_;
	AiStates currentState_;
	Node@ monolith_;

	AI()
	{
		attackRange_ = 9;
		tickRate_ = 1000;
	}

	void Start()
	{
	}

	void DelayedStart()
	{
		currentState_ = AiStates::MOVE;
		monolith_ = scene.GetChild("Monolith", true);
		timer_.Reset();
	}

	void Save(Serializer& serializer)
	{
		serializer.WriteFloat(attackRange_);
		serializer.WriteInt(tickRate_);
	}

	void Load(Deserializer& deserializer)
	{
		attackRange_ = deserializer.ReadFloat();
		tickRate_ = deserializer.ReadInt();
	}

	void Update(float timestep)
	{
		float distance = (monolith_.position - node.position).lengthSquared;
		if (currentState_ == AiStates::MOVE)
		{
			if (distance < attackRange_ * attackRange_)
			{
				currentState_ = AiStates::ATTACK;
			}
			else if(timer_.GetMSec(false) >= tickRate_)
			{
				VariantMap sendData;
				sendData["Target"] = monolith_.position;
				node.SendEvent("UnitMove", sendData);
				timer_.Reset();
			}
		}
		else if(currentState_ == AiStates::ATTACK)
		{
			if (distance >= attackRange_ * attackRange_)
			{
				currentState_ = AiStates::MOVE;
			}
		}
	}

	void Stop()
	{
	}

	Node@ GetClosesMonolith(Array<Node@>@ monolithen)
	{
		Node@ theOne = null;
		float minDistance = -1;
		for(uint i = 0; i < monolithen.length; i++)
		{
			float distance = (monolithen[i].position - node.position).lengthSquared;
			if (minDistance < 0 || distance < minDistance)
			{
				minDistance = distance;
				theOne = monolithen[i];
			}
		}
		return theOne;
	}

	void HandlePostRenderUpdate()
	{
		if (input.keyDown[KEY_E] && node.HasTag("debug"))
		{
			Color color = Color(0, 0, .5);
			if (currentState_ == AiStates::ATTACK)
			{
				color = Color(0, 0.5, 1);
			}
			int multiplier = 5;
			debugRenderer.AddLine(
				node.position + Vector3::UP * multiplier,
				monolith_.position + Vector3::UP * multiplier,
				color
			);
		}
	}
}