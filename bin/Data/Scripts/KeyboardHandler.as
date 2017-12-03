#include "Scripts/Constants.as"

class KeyboardHandler : ScriptObject
{
	NavigationMesh@ navMesh_;

	void Start()
	{
		SubscribeToEvent("KeyDown", "HandleKeyDown");
		SubscribeToEvent("PostRenderUpdate", "HandlePostRenderUpdate");
	}

	void DelayedStart()
	{
		navMesh_ = scene.GetComponent("NavigationMesh");
		navMesh_.Build();
	}

	void Stop()
	{
	}

	void HandleKeyDown(StringHash type, VariantMap& data)
	{
		Viewport@ viewport = renderer.viewports[0];
		float maxRayDistance_ = 50.0f;
		PhysicsRaycastResult result = physicsWorld.RaycastSingle(
			viewport.GetScreenRay(input.mousePosition.x, input.mousePosition.y),
			maxRayDistance_,
			MOVEMENT_LAYER
		);
		if (data["Key"] == KEY_ESCAPE)
		{
			engine.Exit();
		}
		else if (data["Key"] == KEY_B)
		{
			log.Debug("Sending purchase data");
			VariantMap purchaseData;
			purchaseData["Team"] = "player";
			purchaseData["Type"] = "cuboid";
			purchaseData["Target"] = result.position;
			SendEvent("UnitPurchase", purchaseData);
		}
		else if (data["Key"] == KEY_T)
		{
			log.Debug("Sending upgrade data");
			VariantMap upgradeData;
			upgradeData["Team"] = "player";
			upgradeData["Type"] = "cuboid";
			SendEvent("UnitUpgrade", upgradeData);
		}
	}

	void HandlePostRenderUpdate(StringHash type, VariantMap& data)
	{
		if (input.keyDown[KEY_N])
		{
			navMesh_.DrawDebugGeometry(debugRenderer, true);
		}
	}
}