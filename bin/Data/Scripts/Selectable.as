class Selectable : ScriptObject
{
	String selected_;
	String unselected_;
	bool isSelected_;

	void Start()
	{
		isSelected_ = false;
		SubscribeToEvent(node, "UnitSelect", "HandleUnitSelected");
	}

	void DelayedStart()
	{
	}

	void Save(Serializer& serializer)
	{
		serializer.WriteString(selected_);
		serializer.WriteString(unselected_);
	}

	void Load(Deserializer& deserializer)
	{
		selected_ = deserializer.ReadString();
		unselected_ = deserializer.ReadString();
	}

	void Stop()
	{
	}

	void HandleUnitSelected(StringHash type, VariantMap& data)
	{
		isSelected_ = data["Selected"].GetBool();
		Node@ modelNode = node.GetChild("Model", true);
		StaticModel@ staticModel = modelNode.GetComponent("StaticModel");
		AnimatedModel@ animatedModel = modelNode.GetComponent("AnimatedModel");
		if (staticModel !is null)
		{
			if (isSelected_)
			{
				staticModel.material = cache.GetResource("Material", selected_);
			}
			else
			{
				staticModel.material = cache.GetResource("Material", unselected_);
			}
		}
		if (animatedModel !is null)
		{
			if (isSelected_)
			{
				animatedModel.material = cache.GetResource("Material", selected_);
			}
			else
			{
				animatedModel.material = cache.GetResource("Material", unselected_);
			}
		}
	}
}