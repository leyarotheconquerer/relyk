#ifndef Relyk_RelykApp_H
#define Relyk_RelykApp_H

#include <Urho3D/Engine/Application.h>

namespace Urho3D
{
	class Context;
	class ScriptFile;
}

namespace Relyk
{
	class RelykApp : public Urho3D::Application
	{
		URHO3D_OBJECT(RelykApp, Urho3D::Application);

	public:
		RelykApp(Urho3D::Context* context);
		~RelykApp() = default;
	
	protected:
		virtual void Setup();
		virtual void Start();
		virtual void Stop();

	private:
		void HandleScriptReloadStarted(Urho3D::StringHash type, Urho3D::VariantMap& data);
		void HandleScriptReloadFailed(Urho3D::StringHash type, Urho3D::VariantMap& data);
		void HandleScriptReloadFinished(Urho3D::StringHash type, Urho3D::VariantMap& data);

		Urho3D::Context* context_;
		Urho3D::SharedPtr<Urho3D::ScriptFile> script_;
	};
}

#endif // Relyk_RelykApp_H