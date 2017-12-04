class Movable : ScriptObject
{
	float height_;
	float maxSpeed_;
	float maxAccel_;

	CrowdAgent@ crowdAgent_;
	Array<Vector3> path_;

	Movable()
	{
		height_ = 2.0f;
		maxSpeed_ = 3.0f;
		maxAccel_ = 5.0f;
	}

	void Start()
	{
		SubscribeToEvent(node, "UnitMove", "HandleUnitMove");
		SubscribeToEvent("PostRenderUpdate", "HandlePostRenderUpdate");
	}

	void DelayedStart()
	{
		CrowdManager@ manager = scene.GetComponent("CrowdManager");
		manager.animationEnabled = true;
		crowdAgent_ = node.GetComponent("CrowdAgent");
		crowdAgent_.height = height_;
		crowdAgent_.maxSpeed = maxSpeed_;
		crowdAgent_.maxAccel = maxAccel_;
		// crowdAgent_.animationEnabled = true;
	}

	void Save(Serializer& serializer)
	{
		serializer.WriteFloat(height_);
		serializer.WriteFloat(maxSpeed_);
		serializer.WriteFloat(maxAccel_);
	}

	void Load(Deserializer& deserializer)
	{
		height_ = deserializer.ReadFloat();
		maxSpeed_ = deserializer.ReadFloat();
		maxAccel_ = deserializer.ReadFloat();
	}

	void Stop()
	{
		crowdAgent_.enabled = false;
		crowdAgent_.Remove();
		UnsubscribeFromEvent("PostRenderUpdate");
	}

	void Update(float timestep)
	{
		Vector3 direction = crowdAgent_.actualVelocity;
		if (direction.lengthSquared > 1)
		{
			Quaternion rotation;
			rotation.FromLookRotation(direction);
			node.rotation = rotation;
		}
	}

	void HandleUnitMove(StringHash type, VariantMap& data)
	{
		Vector3 target = data["Target"].GetVector3();
		NavigationMesh@ navMesh = scene.GetComponent("NavigationMesh");
		CrowdManager@ crowd = scene.GetComponent("CrowdManager");
		Vector3 nearest = navMesh.FindNearestPoint(data["Target"].GetVector3());
		crowd.SetCrowdTarget(nearest, node);
	}

	void HandlePostRenderUpdate(StringHash type, VariantMap& data)
	{
		if (input.keyDown[KEY_N] && node.HasTag("debug"))
		{
			CrowdAgent@ crowdAgent = node.GetComponent("CrowdAgent");
			crowdAgent.DrawDebugGeometry(debugRenderer, true);
		}
	}
}