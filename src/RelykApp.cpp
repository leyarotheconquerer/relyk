#include "RelykApp.h"

#include <Urho3D/Engine/EngineDefs.h>
#include <Urho3D/AngelScript/Script.h>
#include <Urho3D/AngelScript/ScriptFile.h>
#include <Urho3D/Resource/ResourceCache.h>
#include <Urho3D/Resource/ResourceEvents.h>

using namespace Relyk;
using namespace Urho3D;

URHO3D_DEFINE_APPLICATION_MAIN(RelykApp);

RelykApp::RelykApp(Urho3D::Context* context) :
	Urho3D::Application(context),
	context_(context)
{
}

void RelykApp::Setup()
{
	engineParameters_[EP_FULL_SCREEN] = false;
	engineParameters_[EP_LOG_NAME] = "relyk.log";
	engineParameters_[EP_WINDOW_TITLE] = "Relyk";
}

void RelykApp::Start()
{
	context_->RegisterSubsystem(new Script(context_));
	script_ = context_->GetSubsystem<ResourceCache>()
		->GetResource<ScriptFile>("Scripts/Main.as");
	if (script_ && script_->Execute("void Start()"))
	{
		SubscribeToEvent(
			script_,
			E_RELOADSTARTED,
			URHO3D_HANDLER(RelykApp, HandleScriptReloadStarted)
		);
		SubscribeToEvent(
			script_,
			E_RELOADFAILED,
			URHO3D_HANDLER(RelykApp, HandleScriptReloadFailed)
		);
		SubscribeToEvent(
			script_,
			E_RELOADFINISHED,
			URHO3D_HANDLER(RelykApp, HandleScriptReloadFinished)
		);
		return;
	}
	ErrorExit();
}

void RelykApp::Stop()
{
}

void RelykApp::HandleScriptReloadStarted(Urho3D::StringHash type, Urho3D::VariantMap& data)
{
	if (script_->GetFunction("void Stop()"))
	{
		script_->Execute("void Stop()");
	}
}

void RelykApp::HandleScriptReloadFailed(Urho3D::StringHash type, Urho3D::VariantMap& data)
{
	script_.Reset();
	ErrorExit();
}

void RelykApp::HandleScriptReloadFinished(Urho3D::StringHash type, Urho3D::VariantMap& data)
{
	if (!script_->Execute("void Start()"))
	{
		script_.Reset();
		ErrorExit();
	}
}