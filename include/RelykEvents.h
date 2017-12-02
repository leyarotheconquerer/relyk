#ifndef Relyk_RelykEvents_H
#define Relyk_RelykEvents_H

#include <Urho3D/Core/Object.h>

namespace Relyk
{
	URHO3D_EVENT(E_LEVELSTART, LevelStart)
	{
		URHO3D_PARAM(P_LEVEL, Level);           // Urho3D::String
		URHO3D_PARAM(P_NAME, Name);             // Urho3D::String
	}

	URHO3D_EVENT(E_UNITSELECT, UnitSelect)
	{
		URHO3D_PARAM(P_SELECT, Select);         // bool
	}
}

#endif // Relyk_RelykEvents_H