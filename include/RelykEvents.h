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

	URHO3D_EVENT(E_UNITMOVE, UnitMove)
	{
		URHO3D_PARAM(P_TARGET, Target);         // Urho3D::Vector3
	}

	URHO3D_EVENT(E_UNITATTACK, UnitAttack)
	{
		URHO3D_PARAM(P_DAMAGE, Damage);         // int
		URHO3D_PARAM(P_TYPE, Type);             // Urho3D::String
		URHO3D_PARAM(P_ATTACKER, Attacker);     // Urho3D::Node*
	}

	URHO3D_EVENT(E_UNITDAMAGED, UnitDamaged)
	{
		URHO3D_PARAM(P_DAMAGE, Damage);         // int
		URHO3D_PARAM(P_TYPEMATCH, TypeMatch);   // bool
		URHO3D_PARAM(P_HEALTH, Health);         // int
		URHO3D_PARAM(P_MAXHEALTH, MaxHealth);   // int
	}

	URHO3D_EVENT(E_UNITDIED, UnitDied)
	{
		URHO3D_PARAM(P_TEAM, Team);             // Urho3D::String
		URHO3D_PARAM(P_TYPE, Type);             // Urho3D::String
		URHO3D_PARAM(P_NODE, Node);             // Urho3D::Node*
		URHO3D_PARAM(P_SCORE, Score);           // int
	}

	URHO3D_EVENT(E_UNITSPAWN, UnitSpawn)
	{
		URHO3D_PARAM(P_TEAM, Team);             // Urho3D::String
		URHO3D_PARAM(P_TYPE, Type);             // Urho3D::String
	}

	URHO3D_EVENT(E_UNITPURCHASE, UnitPurchase)
	{
		URHO3D_PARAM(P_TEAM, Team);             // Urho3D::String
		URHO3D_PARAM(P_TYPE, Type);             // Urho3D::String
		URHO3D_PARAM(P_TARGET, Target);         // Urho3D::Vector3
	}

	URHO3D_EVENT(E_UNITUPGRADE, UnitUpgrade)
	{
		URHO3D_PARAM(P_TEAM, Team);             // Urho3D::String
		URHO3D_PARAM(P_TYPE, Type);             // Urho3D::String
	}

	URHO3D_EVENT(E_UNITDIVIDER, UnitDivider)
	{
		URHO3D_PARAM(P_TEAM, Team);             // Urho3D::String
		URHO3D_PARAM(P_TYPE, Type);             // Urho3D::String
		URHO3D_PARAM(P_DIVIDER, Divider);       // int
	}

	URHO3D_EVENT(E_PLAYERPOINTS, PlayerPoints)
	{
		URHO3D_PARAM(P_TOTAL, Total);           // int
		URHO3D_PARAM(P_NEW, New);               // int
		URHO3D_PARAM(P_SPENT, Spent);           // int
	}
}

#endif // Relyk_RelykEvents_H