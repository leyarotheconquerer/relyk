#include "RelykApp.h"

#include <Urho3D/Engine/EngineDefs.h>

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
}

void RelykApp::Stop()
{
}