const int SELECTION_LAYER = 1;
const int MOVEMENT_LAYER = 2;

class UnitSelection : ScriptObject
{
	int maxRayDistance_;
	Array<Node@> selected_;
	Vector3 position_;
	Vector3 normal_;

	UnitSelection()
	{
		maxRayDistance_ = 50.0f;
	}

	void Start()
	{
		input.SetMouseVisible(true);

		SubscribeToEvent("MouseButtonDown", "HandleMouseButtonDown");
		SubscribeToEvent("PostRenderUpdate", "HandlePostRenderUpdate");
	}

	void Save(Serializer& serializer)
	{
		serializer.WriteInt(maxRayDistance_);
	}

	void Load(Deserializer& deserializer)
	{
		maxRayDistance_ = deserializer.ReadInt();
	}

	void Stop()
	{
		UnsubscribeFromEvent("MouseButtonDown");
		UnsubscribeFromEvent("PostRenderUpdate");
		input.SetMouseVisible(false);
	}

	void HandleMouseButtonDown(StringHash type, VariantMap& data)
	{
		Viewport@ viewport = renderer.viewports[0];
		int button = data["Button"].GetInt();
		int qualifiers = data["Qualifiers"].GetInt();
		if (button == MOUSEB_LEFT)
		{
			//log.Debug("Casting up to " + maxRayDistance_);
			PhysicsRaycastResult result = physicsWorld.RaycastSingle(
				viewport.GetScreenRay(input.mousePosition.x, input.mousePosition.y),
				maxRayDistance_,
				SELECTION_LAYER
			);
			if (
				result.body !is null && 
				result.body.node.GetScriptObject("Selectable") !is null
			) {
				Node@ unit = result.body.node;
				if (qualifiers & QUAL_SHIFT != 0)
				{
					AddSelection(unit);
				}
				else
				{
					ClearSelection();
					AddSelection(unit);
				}

			}
			else
			{
				if (qualifiers & QUAL_SHIFT == 0)
				{
					ClearSelection();
				}
			}
			DumpSelection();
		}
		else if (button == MOUSEB_RIGHT)
		{
			PhysicsRaycastResult result = physicsWorld.RaycastSingle(
				viewport.GetScreenRay(input.mousePosition.x, input.mousePosition.y),
				maxRayDistance_,
				MOVEMENT_LAYER
			);
			position_ = result.position;
			normal_ = result.normal;
			Move(position_);
		}
	}

	void AddSelection(Node@ node)
	{
		VariantMap sendData;
		sendData["Selected"] = true;
		node.SendEvent("UnitSelect", sendData);
		bool found = false;
		for(uint i = 0; i < selected_.length; i++)
		{
			found = (selected_[i].id == node.id);
			if (found) { break; }
		}
		if (not found)
		{
			selected_.Push(node);
		}
	}

	void ClearSelection()
	{
		for(uint i = 0; i < selected_.length; i++)
		{
			VariantMap sendData;
			sendData["Selected"] = false;
			selected_[i].SendEvent("UnitSelect", sendData);
		}
		selected_.Clear();
	}

	void DumpSelection()
	{
		log.Debug("Current selection:");
		for(uint i = 0; i < selected_.length; i++)
		{
			log.Debug("    - " + selected_[i].id + " (" + selected_[i].name + ")");
		}
	}

	void Move(Vector3 position)
	{
		for(uint i = 0; i < selected_.length; i++)
		{
			VariantMap sendData;
			sendData["Target"] = position;
			selected_[i].SendEvent("UnitMove", sendData);
		}
	}

	void HandlePostRenderUpdate(StringHash type, VariantMap& data)
	{
		if (input.keyDown[KEY_P] && node.HasTag("debug"))
		{
			DebugRenderer@ debugRenderer = node.scene.GetComponent("DebugRenderer");
			PhysicsWorld@ world = node.scene.GetComponent("PhysicsWorld");

			debugRenderer.AddLine(position_, position_ + normal_ * 5, Color(0, 1, 0));

			world.DrawDebugGeometry(debugRenderer, true);
		}
	}
}