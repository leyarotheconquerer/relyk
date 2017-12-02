#ifndef Relyk_RelykApp_H
#define Relyk_RelykApp_H

#include <Urho3D/Engine/Application.h>

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
		Urho3D::Context* context_;
	};
}

#endif // Relyk_RelykApp_H