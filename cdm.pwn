/*
					Creative • DM 
		Skrypt wykonany przez LukeSQLY oraz serinho.
		Ostatnia data kompilacji: 22.01.2018
		
*/

#include <a_samp>
#include <YSI\y_ini>
#include <zcmd>
#include <sscanf2>
#include <streamer>
 
#pragma tabsize 0
 
//========= > USTAWIENIA < =========//
 
#define DNAZWA "Creative DM"
#define DWERSJA "1.8"
#define SYSTEM " SYSTEM (0)"
#define DKOMPILACJA "22.01.2018"
#define PATH "/Players/%s.ini"
#define LOGPATH "/Log/%s.ini"
#define ADMINPASS "kurwachuj"
 
//========= > USTAWIENIA < =========//
 
#define COLOR_ACHAT 0x0EE46FFF
#define COLOR_GRAD1 0xB4B5B7FF
#define COLOR_GRAD2 0xBFC0C2FF
#define COLOR_GRAD3 0xCBCCCEFF
#define COLOR_GRAD4 0xD8D8D8FF
#define COLOR_GRAD5 0xE3E3E3FF
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREEN 0x33AA33AA
#define COLOR_RED 0xFF0000FF
#define COLOR_LIGHTRED 0xFF6347AA
#define COLOR_CIEMBLUE 0x8D8DFF00
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_BLUE 0x0000BBAA
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_ORANGE 0xFF9900AA
#define COLOR_LIME 0x10F441AA
#define COLOR_MAGENTA 0xFF00FFFF
#define COLOR_NAVY 0x000080AA
#define COLOR_AQUA 0xF0F8FFAA
#define COLOR_CRIMSON 0xDC143CAA
#define COLOR_FLBLUE 0x6495EDAA
#define COLOR_BISQUE 0xFFE4C4AA
#define COLOR_BLACK 0x000000AA
#define COLOR_CHARTREUSE 0x7FFF00AA
#define COLOR_BROWN 0XA52A2AAA
#define COLOR_CORAL 0xFF7F50AA
#define COLOR_GOLD 0xB8860BAA
#define COLOR_GREENYELLOW 0xADFF2FAA
#define COLOR_INDIGO 0x4B00B0AA
#define COLOR_IVORY 0xFFFF82AA
#define COLOR_LAWNGREEN 0x7CFC00AA
#define COLOR_LIMEGREEN 0x32CD32AA //<--- Dark lime
#define COLOR_MIDNIGHTBLUE 0X191970AA
#define COLOR_MAROON 0x800000AA
#define COLOR_OLIVE 0x808000AA
#define COLOR_ORANGERED 0xFF4500AA
#define COLOR_PINK 0xFFC0CBAA // - Light light pink
#define COLOR_SEAGREEN 0x2E8B57AA
#define COLOR_SPRINGGREEN 0x00FF7FAA
#define COLOR_TOMATO 0xFF6347AA // -
#define COLOR_YELLOWGREEN 0x9ACD32AA //- like military green
#define COLOR_MEDIUMAQUA 0x83BFBFAA
#define COLOR_MEDIUMMAGENTA 0x8B008BAA
#define COLOR_WHITE 0xFFffffff
 
// ---dialogs--
 
#define DIALOG_ADMINLOGIN 1
 
//--enum
enum e_PlayerInfo{
    Level,
    Kills,
    Deaths,
    Cash,
    Jail,
    Warns,
    OnDuty,
    AdminLevel,
    ModLevel,
    Skin,
    Vip,
    Weapon1,
    Weapon1_ammo,
    Weapon2,
    Weapon2_ammo,
    Weapon3,
    Weapon3_ammo
};
new pInfo[MAX_PLAYERS][e_PlayerInfo];
 
public OnGameModeInit()
{
    //Ustawienia gamemodu:
    SetGameModeText(DNAZWA" "DWERSJA);
    SendRconCommand("stream_distance "#STREAM_DISTANCE_S);
    //Ustawienia rozgrywki:
    AllowInteriorWeapons(1); //bron w intkach
    DisableInteriorEnterExits(); //wy31czenie wejoa do intków z GTA
    EnableStuntBonusForAll(0); //brak hajsu za stunty
    ShowNameTags(1); //Pokazywanie nicków graczy
    UsePlayerPedAnims(); //animki CJ - Trzymanie broni w obu dloniach, obecnie OFF
    //SetNameTagDrawDistance(20.0); //Wyowietlanie nicków od 20 metrów
    print("|| WYKONANO: OnGameModeInit || ");
    printf(DNAZWA" "DWERSJA" compiled on "DKOMPILACJA);
    WasteDeAMXersTime();
    return 1;
}
public OnGameModeExit()
{
    return 1;
}
public OnPlayerConnect(playerid)
{
    new string[128];
    ClearLastUserData(playerid);
    //TogglePlayerSpectating(playerid, 1);
    //InterpolateCameraPos(playerid, 2148.0, -1640.0, 50.0, 2480.0, -1665.0, 35.0, 30*1000, CAMERA_MOVE);
    //InterpolateCameraLookAt(playerid, 2480.0, -1665.0, 35.0, 2490.0, -1665.0, 20.0, 10*1000, CAMERA_MOVE);
    if(fexist(UserPath(playerid))) {
        SetPlayerColor(playerid, COLOR_WHITE);
        INI_ParseFile(UserPath(playerid), "LoadUser_%s", .bExtra = true, .extra = playerid);
        GivePlayerMoney(playerid, pInfo[playerid][Cash]);
        //ShowAdminLoginDialog(playerid);
    }
    else
    {
        new INI:File = INI_Open(UserPath(playerid));
        INI_SetTag(File,"data");
        INI_WriteInt(File,"Level",1);
        INI_WriteInt(File,"Kills",0);
        INI_WriteInt(File,"Deaths",0);
        INI_WriteInt(File,"Jail",0);
        INI_WriteInt(File,"Warns",0);
        INI_WriteInt(File,"AdminLevel",0);
        INI_WriteInt(File,"ModLevel",0);
        INI_WriteInt(File,"Cash",5000);
        INI_WriteInt(File,"Skin",50);
        INI_WriteInt(File,"Vip",0);
        INI_WriteInt(File,"Weapon1",24);
        INI_WriteInt(File,"Weapon1_ammo",100);
        INI_WriteInt(File,"Weapon2",0);
        INI_WriteInt(File,"Weapon2_ammo",0);
        INI_WriteInt(File,"Weapon3",0);
        INI_WriteInt(File,"Weapon3_ammo",0);
        INI_Close(File);
        SetPlayerSkin(playerid, 50);
        pInfo[playerid][Skin] = 50;
    }
    if(GetPlayerAdminLevel(playerid) > 1)
    {
        SendClientMessage(playerid, COLOR_CIEMBLUE, "» Zalogowa³eœ siê jako Administrator, sprawdŸ dostepne komendy! (/acmd)");
        format(string, sizeof(string), "Administrator %s [%d] zalogowa³ siê na serwer!", pName(playerid), playerid);
        GameTextForPlayer(playerid, "~w~Zalogowa³es sie jako ~r~Administrator~w~, Witaj!", 8000, 4);
        AdminWarning(COLOR_YELLOW, string, 1);
        return 1;
    }
    else if(pInfo[playerid][ModLevel] > 1)
    {
        SendClientMessage(playerid, COLOR_CIEMBLUE, "» Zalogowa³eœ siê jako Moderator, sprawdŸ dostêpne komendy! (/acmd)");
        format(string, sizeof(string), "Moderator %s [%d] zalogowa³ siê na serwer!", pName(playerid), playerid);
        AdminWarning(COLOR_YELLOW, string, 1);
        return 1;
    }
    else if (IsPlayerVip(playerid)) {
        
        SetPlayerColor(playerid, 0xDFB509FF);
        SendClientMessage(playerid, COLOR_WHITE, "» Jesteœ posiadaczem konta {E9CE16}VIP{FFFFFF} ¯yczymy mi³ej gry :)");
        GameTextForPlayer(playerid, "~w~Pakiet ~y~VIP", 8000, 4);
    }
    SetPlayerColor(playerid, COLOR_WHITE);
    SetPlayerScore(playerid, pInfo[playerid][Level]);
    //TogglePlayerSpectating(playerid, 0);
    //SetCameraBehindPlayer(playerid);
    format(string, sizeof(string), "%s do³¹czy³ na serwer.", pName(playerid));
    SendClientMessageToAll(COLOR_GREEN, string);
    return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
    new playerName[MAX_PLAYER_NAME], string[128];
    GetPlayerName(playerid, playerName, sizeof(playerName));
    switch(reason)
    {
        case 0: format(string, sizeof(string), "%s opuœci³ serwer (timeout/crash)", playerName);
        case 1: format(string, sizeof(string), "%s opuœci³ serwer (/q)", playerName);
        case 2: format(string, sizeof(string), "%s opuœci³ serwer (ban/kick)", playerName);
    }
    SendClientMessageToAll(COLOR_GRAD2, string);
    printf(string);
    //zapiswyanie
    pInfo[playerid][Cash] = GetPlayerMoney(playerid);
    new INI:File = INI_Open(UserPath(playerid));
    INI_SetTag(File,"data");
    INI_WriteInt(File,"Level",pInfo[playerid][Level]);
    INI_WriteInt(File,"Kills",pInfo[playerid][Kills]);
    INI_WriteInt(File,"Deaths",pInfo[playerid][Deaths]);
    INI_WriteInt(File,"Jail",pInfo[playerid][Jail]);
    INI_WriteInt(File,"Warns",pInfo[playerid][Warns]);
    INI_WriteInt(File,"AdminLevel",pInfo[playerid][AdminLevel]);
    INI_WriteInt(File,"ModLevel",pInfo[playerid][ModLevel]);
    INI_WriteInt(File,"Cash",pInfo[playerid][Cash]);
    INI_WriteInt(File,"Skin",pInfo[playerid][Skin]);
    INI_WriteInt(File,"Vip",pInfo[playerid][Vip]);
    INI_WriteInt(File,"Weapon1",pInfo[playerid][Weapon1]);
    INI_WriteInt(File,"Weapon1_ammo",pInfo[playerid][Weapon1_ammo]);
    INI_WriteInt(File,"Weapon2",pInfo[playerid][Weapon2]);
    INI_WriteInt(File,"Weapon2_ammo",pInfo[playerid][Weapon2_ammo]);
    INI_WriteInt(File,"Weapon3",pInfo[playerid][Weapon3]);
    INI_WriteInt(File,"Weapon3_ammo",pInfo[playerid][Weapon3_ammo]);
    INI_Close(File);
    return 1;
}
public OnPlayerRequestClass(playerid, classid)
{
    SetSpawnInfo(playerid, 0, PlayerSkin(playerid), 2494.1304, -1674.7213, 13.3359, 90.0, pInfo[playerid][Weapon1], pInfo[playerid][Weapon1_ammo], pInfo[playerid][Weapon2], pInfo[playerid][Weapon2_ammo], pInfo[playerid][Weapon3], pInfo[playerid][Weapon3_ammo]);
    SpawnPlayer(playerid);
    return 1;
}
public OnPlayerSpawn(playerid)
{
    if(IsPlayerVip(playerid)) {
        SetPlayerArmour(playerid, 100.0);
    }
    SetPlayerSkin(playerid, PlayerSkin(playerid));
    return 1;
}
public OnPlayerDeath(playerid, killerid, reason)
{
    pInfo[playerid][Deaths]++;
    if(playerid != killerid) pInfo[killerid][Kills]++;
    return 1;
}
public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
    if(issuerid != INVALID_PLAYER_ID && bodypart != 3 && PlayerArmor(playerid) > 0) {
        new Float:health, Float:newhealth, Float:armor;
        GetPlayerHealth(playerid, Float:health);
        GetPlayerArmour(playerid, Float:armor);
        newhealth = Float:health - Float:amount;
        SetPlayerHealth(playerid, Float:newhealth);
        SetPlayerArmour(playerid, Float:armor);
    }
    return 1;
}
public OnPlayerText(playerid, text[])
{
    new textstring[128];
    if(IsPlayerOnAdminDuty(playerid))
    {
        format(textstring, sizeof(textstring), "%s {FF0000}[ADMIN]{FFFFFF} [%d]: %s", pName(playerid), playerid, text);
        SendClientMessageToAll(COLOR_WHITE, textstring);
    }
    else if(!IsPlayerOnAdminDuty(playerid))
    {
        format(textstring, sizeof(textstring), "%s {6495ED}[%d]{FFFFFF}: %s", pName(playerid), playerid, text);
        SendClientMessageToAll(COLOR_WHITE, textstring);
    }
    return 0;
}
public OnPlayerCommandText(playerid, cmdtext[])
{
    return 1;
}
public OnRconCommand(cmd[])
{
    return 1;
}
public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
    /*new string[48];
    format(string, sizeof(string), "x * Zap³aci³eœ $200 za naprawê pojazdu! * x");
    SendClientMessage(playerid, COLOR_LIGHTBLUE, string);*/
    return 1;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    return 1;
}
public OnRconLoginAttempt(ip[], password[], success)
{
    new string[128];
    if(!success)
    {
        format(string, sizeof(string), "RCON WARNING: IP %s tried to log in using password %s and failed!", ip, password);
        AdminWarning(COLOR_RED, string, 5);
    }
    return 1;
}
public OnPlayerUpdate(playerid)
{
    return 1;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
        if(dialogid == 5) {
            if(response)
                {
                    new skinid, message[64];
                    skinid = strval(inputtext);
                    if(skinid < 1 || skinid > 299)
                    {
                        SendClientMessage(playerid, 0xFFFFFFFF, "Bledne ID skina! Wybierz skin od 1 do 299!");
                    }
                    else
                    {
                        SetPlayerSkin(playerid, skinid);
                        format(message, sizeof(message), "Otrzymujesz skina (ID %d)", skinid);
                        SendClientMessage(playerid, COLOR_LIGHTBLUE, message);
                    }
                }
        } 
        if(dialogid = DIALOG_ADMINLOGIN) {
            if(response) {
                if(strcmp(inputtext, ADMINPASS, false)) {
                    SetPVarInt(playerid, "AdminLogged", 1);
                    SendClientMessage(playerid, COLOR_LIGHTBLUE, "» Pomyœlnie siê zalogowa³eœ!");
                }
                if(isnull(inputtext)) return Kick(playerid);
            }
            else return Kick(playerid);
        }
        return 1;
}
public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
    new string[128];
    if(IsPlayerOnAdminDuty(playerid) || IsPlayerAdmin(playerid))
    {
        format(string, sizeof(string), "» Sprawdzasz statystyki gracza: %s", pName(clickedplayerid));
        SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
        format(string, sizeof(string), "Name: %s | Level: %d | Kills: %d | Deaths: %d | Warns: %d | VIP: %d | Admin Level: %d | Mod Level: %d", pName(clickedplayerid), pInfo[clickedplayerid][Level], pInfo[clickedplayerid][Kills], pInfo[clickedplayerid][Deaths], pInfo[clickedplayerid][Warns], pInfo[clickedplayerid][Vip], pInfo[clickedplayerid][AdminLevel], pInfo[clickedplayerid][ModLevel]);
        SendClientMessage(playerid, COLOR_WHITE, string);
    }
    return 1;
}
public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{ 
    if(!success) return SendClientMessage(playerid, COLOR_RED, "» B£¥D:{ffffff} Nieznana komenda!");  
    return 1;
}
//==============================================================================================================================================================//
//=====================[< KOMENDY ZCMD > ]======================================================================================================================//
//==============================================================================================================================================================//
 
CMD:skin(playerid, temps[])
{
    ShowPlayerDialog(playerid, 5, DIALOG_STYLE_INPUT, DNAZWA" » Zmiana skina", "Wpisz ID skina", "Ok", "Zamknij");
    return 1;
}
CMD:teleporty(playerid, temps[])
{
    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, DNAZWA "- Teleporty   ", "\n1. /ls\n2. /lv\n3. /sf", "Ok", "Zamknij");
    return 1;
}
 
CMD:ls(playerid, temps[])
{
    SetPlayerPos(playerid, 2494.1304,-1674.7213,13.3359);
    SendClientMessage(playerid, COLOR_LIGHTBLUE, "» Teleportowales sie do Los Santos!");
    return 1;
}
 
CMD:lv(playerid, temps[])
{
    SetPlayerPos(playerid, 2146.7803,1000.5715,10.8203);
    SendClientMessage(playerid, COLOR_LIGHTBLUE, "» Teleportowales sie do Las Venturas!");
    return 1;
}
 
CMD:sf(playerid, temps[])
{
    SetPlayerPos(playerid, 2-1971.6472,258.6663,35.1719);
    SendClientMessage(playerid, COLOR_LIGHTBLUE, "» Teleportowales sie do San Fierro!");
    return 1;
}
 
CMD:gmx(playerid, params[])
{
    if(IsPlayerAdmin(playerid) || IsPlayerSuperAdmin(playerid))
    {
    SendClientMessage(playerid, COLOR_LIGHTBLUE, "» Restartujesz serwer");
    GameModeExit();
    return 1;
    }
    else
    {
    SendClientMessage(playerid, COLOR_RED, "Zostales wyrzucony z serwera przez Admina" SYSTEM " | ""Powód: Próba restartu serwera [GMX]");
    printf("%s próbowal zrestarowac serwer przy uzyciu komendy /gmx!", pName(playerid));
    SetTimerEx("KickEx", 1000 * 1, false, "i", playerid);
    return 1;
    }
}
 
CMD:setvw(playerid, params[])
{
    new string[128], targetid, val;
    if (IsPlayerOnAdminDuty(playerid)) {
        if(sscanf(params, "ui", targetid, val)) return SendClientMessage(playerid, COLOR_LIGHTRED, "» U¯YCIE: /setvw [id/nick] [virtualworld]");
        SetPlayerVirtualWorld(targetid, val);
        format(string, sizeof(string), "» Administrator %s zmieni³ twój virtualworld na %i", pName(playerid), val);
        SendClientMessage(targetid, COLOR_LIGHTRED, string);
        format(string, sizeof(string), "» Zmieni³eœ graczowi %s virtualworld na %i", pName(targetid), val);
        SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
        format(string, sizeof(string), "ADMINWARNING: Administrator %s zmieni³ virtualworld gracza %s na %i", pName(playerid), pName(targetid), val);
        AdminWarning(COLOR_RED, string, 1);
    }
    else SendClientMessage(playerid, COLOR_RED, "» Aby uzyc tej komendy musisz byc na sluzbie administratora!(/duty)");
    return 1;
 
}
 
CMD:setint(playerid, params[])
{
    if (IsPlayerOnAdminDuty(playerid))
    {
    new string[128], value = strval(params);
    SetPlayerInterior(playerid, value);
    format(string, sizeof(string), "»  Zmieniles swój INT! Twoj interior to teraz: %d", value);
    SendClientMessage(playerid, -1, string);
    }
    else SendClientMessage(playerid, COLOR_RED, "» Aby uzyc tej komendy musisz byc na sluzbie administratora!(/duty)");
    return 1;
}
 
 
CMD:minigun(playerid, params[])
{
    if (IsPlayerOnAdminDuty(playerid))
    {
        GivePlayerWeapon(playerid, 38 , 900);
        SendClientMessage(playerid, COLOR_RED, "» Otrzymujesz minigun!");
        return 1;
    }
    else SendClientMessage(playerid, COLOR_RED, "» Aby uzyc tej komendy musisz byc na sluzbie administratora!(/duty)");
    return 1;
 
}
 
CMD:duty(playerid, temps[])
{
    if(IsPlayerAdmin(playerid) || IsPlayerScriptAdmin(playerid)) {
        if(!IsPlayerOnAdminDuty(playerid)) {
            SetPVarInt(playerid, "AdminDuty", 1);
            SendClientMessage(playerid, COLOR_GREEN, "» Teraz jestes na sluzbie administratora!");
        }
        else {
            SetPVarInt(playerid, "AdminDuty", 0);
            SendClientMessage(playerid, COLOR_ORANGE, "» Juz nie jestes na sluzbie administratora!");
        }
        return 1;
    }
    else SendClientMessage(playerid, COLOR_RED, "» Aby u¿yæ tej komendy musisz byæ administratorem!");  
    return 1;
}
 
CMD:setadmin(playerid, params[])
{
    new string[128], string2[128], recieverid, value;
    if (IsPlayerAdmin(playerid) || IsPlayerSuperAdmin(playerid))
    {
        if(IsPlayerConnected(value)) {
            if (sscanf(params, "ui", recieverid, value)) return SendClientMessage(playerid, COLOR_LIGHTRED, "» U¯YCIE: /setadmin [id/nick] [level]");
            SetPlayerAdminLevel(recieverid, value);
            format(string, sizeof(string), "»  Nadales graczowi %s (ID:%d) funkcje administratorskie",pName(recieverid), recieverid);
            format(string2, sizeof(string2), "»  Otrzymales %i poziom administratora od %s", value, pName(playerid));
            SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
            SendClientMessage(recieverid, COLOR_LIGHTBLUE, string2);
            format(string, sizeof(string), "» ADMINWARNING: Administrator %s nada³ %i poziom administratora %s (ID:%d)!", pName(playerid), value, pName(recieverid), recieverid);
            AdminWarning(COLOR_RED, string, 1);
            return 1;
        }
        else SendClientMessage(playerid, COLOR_RED, "» Nie ma takiego gracza na serwerze!");
    }
    else SendClientMessage(playerid, COLOR_RED, "» Nie jesteœ administratorem RCON lub nie masz wystarczajaco wysokiego poziomu administratora.");
    return 1;
}
CMD:setmod(playerid, params[])
{
    if (IsPlayerAdmin(playerid) || IsPlayerSuperAdmin(playerid))
    {
        new string[128], string2[128], value = strval(params);
        if(IsPlayerConnected(value)) {
            if (sscanf(params, "u", value)) return SendClientMessage(playerid, COLOR_LIGHTRED, "» U¯YCIE: /setmod [id/nick]");
            SetPlayerModLevel(value, 3);
            format(string, sizeof(string), "»  Nadales graczowi %s (ID:%d) funkcje moderatora.",pName(value), value);
            format(string2, sizeof(string2), "»  Otrzymales funkcje moderatora od administratora %s", pName(playerid));
            SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
            SendClientMessage(value, COLOR_LIGHTBLUE, string2);
            format(string, sizeof(string), "Administrator %s nadal funkcje moderacyjne graczowi %s (ID:%d)!", pName(playerid), pName(value), value);
            AdminWarning(COLOR_RED, string, 1);
            return 1;
        }
        else SendClientMessage(playerid, COLOR_RED, "» Nie ma takiego gracza na serwerze!");
    }
    else SendClientMessage(playerid, COLOR_RED, "» Nie jestes Administratorem RCON");    
    return 1;
}
 
CMD:stats(playerid, temps[])
{
    new string[144];
    format(string, sizeof(string), "Name: %s | Level: %d | Kills: %d | Deaths: %d | Warns: %d | VIP: %d | Admin Level: %d | Mod Level: %d", pName(playerid), pInfo[playerid][Level], pInfo[playerid][Kills], pInfo[playerid][Deaths], pInfo[playerid][Warns], pInfo[playerid][Vip], pInfo[playerid][AdminLevel], pInfo[playerid][ModLevel]);
    SendClientMessage(playerid, COLOR_WHITE, string);
    return 1;
}
 
CMD:admins(playerid, temps[])
{
    new string[128];
    SendClientMessage(playerid, COLOR_WHITE, "Lista administratorów:");
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            if(IsPlayerAdmin(i) || IsPlayerSuperAdmin(i)) {
                format(string, sizeof(string), "RCON:{ff6347} %s | ID: %d", pName(i), i);
                SendClientMessage(playerid, COLOR_WHITE, string);
            }
            else if(IsPlayerOnAdminDuty(i)) {
                format(string, sizeof(string), "Administrator(on duty): {33ccff}%s | ID: %d | Admin level: %d", pName(i), i, GetPlayerAdminLevel(i));
                SendClientMessage(playerid, COLOR_WHITE, string);
            }
            else if(IsPlayerScriptAdmin(i)) {
                format(string, sizeof(string), "Administrator: {33ccff}%s | ID: %d | Admin level: %d", pName(i), i, GetPlayerAdminLevel(i));
                SendClientMessage(playerid, COLOR_WHITE, string);
            }
        }
    }
    return 1;
}
 
//----------SYSTEM KAR----------
 
CMD:warn(playerid, params[])
{
    new string[128], warnid, reason[64];
    if (IsPlayerOnAdminDuty(playerid))
    {
        if(IsPlayerConnected(warnid))
        {
            if (sscanf(params, "us[64]", warnid, reason)) return SendClientMessage(playerid, COLOR_LIGHTRED, "» U¯YCIE: /warn [id/nick] [powod]");
            pInfo[warnid][Warns]++;
            format(string, sizeof(string), "» Zosta³eœ zwarnowany przez administratora %s. (%d/3) Powod: %s", pName(playerid), pInfo[warnid][Warns], reason);
            SendClientMessage(warnid, COLOR_TOMATO, string);
            format(string, sizeof(string), "» Zwarnowa³eœ gracza %s (%d/3) z powodem %s", pName(playerid), pInfo[warnid][Warns], reason);
            SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
            format(string, sizeof(string), "ADMINWARNING: Administrator %s zwarnowa³ gracza %s. (%d/3) Powód: %s", pName(playerid), pName(warnid), pInfo[warnid][Warns], reason);
            AdminWarning(COLOR_RED, string, 1);
            if(pInfo[warnid][Warns] == 3)
            {
                SetTimerEx("BanTimed", 500, false, "d", warnid);
                format(string, 200, "Gracz %s zosta³ zbanowany przez administratora: %s | Powód: Przekroczenie limitu warnów (3)", pName(warnid), pName(playerid));
                SendClientMessageToAll(COLOR_LIGHTRED, string);
                printf("BanLog: %s zosta³ zbanowany przez administratora: %s | Powód: Przekroczenie limitu warnów (3)", pName(warnid), pName(playerid));
            }
           
        }
        else SendClientMessage(playerid, COLOR_RED, "» Nie ma takiego gracza na serwerze!");
    }
    else SendClientMessage(playerid, COLOR_RED, "» Aby u¿yæ tej komendy musisz byæ na slu¿bie administratora! (/duty)");
    return 1;
}
 
CMD:unwarn(playerid, params[])
{
    new string[128], warnid = strval(params);
    if (IsPlayerOnAdminDuty(playerid))
    {
        if(IsPlayerConnected(warnid))
        {
                if (sscanf(params, "u", warnid)) return SendClientMessage(playerid, COLOR_LIGHTRED, "» U¯YCIE: /unwarn [id/nick]");
                if(pInfo[warnid][Warns] > 0)
                {
                    pInfo[warnid][Warns]--;
                    format(string, sizeof(string), "» Zosta³eœ unwarnowany przez administratora %s. (%d/3)", pName(playerid), pInfo[warnid][Warns]);
                    SendClientMessage(warnid, COLOR_LIGHTBLUE, string);
                    format(string, sizeof(string), "» Unwarnowa³eœ gracza %s (%d/3).", pName(playerid), pInfo[warnid][Warns]);
                    SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
                    format(string, sizeof(string), "» ADMINWARNING: Administrator %s unwarnowa³ gracza %s. (%d/3)", pName(playerid), pName(warnid), pInfo[warnid][Warns]);
                    AdminWarning(COLOR_RED, string, 1);
                }
                 else SendClientMessage(playerid, COLOR_TOMATO, "» Ten gracz ma ju¿ 0 warnów.");
        }
        else SendClientMessage(playerid, COLOR_RED, "» Nie ma takiego gracza na serwerze!");
    }
    else SendClientMessage(playerid, COLOR_RED, "» Aby u¿yæ tej komendy musisz byæ na slu¿bie administratora! (/duty)");
    return 1;
}
 
CMD:kick(playerid, params[])
{
    new string[128], kickid, reason[64];
    if (IsPlayerOnAdminDuty(playerid))
    {
        if(IsPlayerConnected(kickid))
        {
            if (sscanf(params, "us[64]", kickid, reason)) return SendClientMessage(playerid, COLOR_LIGHTRED, "» U¯YCIE: /kick [id/nick] [powod]");
            format(string, sizeof(string), "Gracz %s zosta³ wyrzucony z serwera przez administratora: %s | Powód: %s", pName(kickid), pName(playerid), reason);
            SendClientMessageToAll(COLOR_LIGHTRED, string);
            printf(string);
            SetTimerEx("KickEx", 1000, false, "i", kickid);
        }
        else SendClientMessage(playerid, COLOR_RED, "» Nie ma takiego gracza na serwerze!");
    }
    else SendClientMessage(playerid, COLOR_RED, "» Aby u¿yæ tej komendy musisz byæ na slu¿bie administratora! (/duty)");
    return 1;
}
 
CMD:ban(playerid, params[])
{
    new string[128], bannedid, reason[64];
    if (IsPlayerOnAdminDuty(playerid))
    {
        if(IsPlayerConnected(bannedid))
        {
            if (sscanf(params, "us[64]", bannedid, reason)) return SendClientMessage(playerid, COLOR_LIGHTRED, "» U¯YCIE: /ban [id/nick] [powod]");
            format(string, sizeof(string), "Gracz %s zostal zbanowany przez administratora: %s | Powód: %s", pName(bannedid), pName(playerid), reason);
            SendClientMessageToAll(COLOR_LIGHTRED, string);
            printf(string);
            BanEx(bannedid, reason);
        }
        else SendClientMessage(playerid, COLOR_RED, "» Nie ma takiego gracza na serwerze!");
    }
    else SendClientMessage(playerid, COLOR_RED, "» Aby u¿yæ tej komendy musisz byæ na slu¿bie administratora! (/duty)");
    return 1;
}
 
CMD:slap(playerid, params[])
{
    new string[128], targetid, reason[64], Float:posX, Float:posY, Float:posZ;
    if(IsPlayerScriptAdmin(playerid)) {
        if (sscanf(params, "us[64]", targetid, reason)) return SendClientMessage(playerid, COLOR_LIGHTRED, "» U¯YCIE: /slap [id/nick] [powod]");
        if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_LIGHTRED, "»  Nie ma takiego gracza!");
        GetPlayerPos(targetid, Float:posX, Float:posY, Float:posZ);
        SetPlayerPos(targetid, Float:posX, Float:posY, Float:posZ + 5.0);
        format(string, sizeof(string), "» Dosta³eœ klapsa od administratora %s, powód: %s", pName(playerid), reason);
        SendClientMessage(targetid, COLOR_LIGHTRED, string);
        format(string, sizeof(string), "Administrator %s da³ slapa graczowi %s, powód: %s", pName(playerid), pName(targetid), reason);
        AdminWarning(COLOR_RED, string, 1);
    }
    else SendClientMessage(playerid, COLOR_RED, "» Aby u¿yæ tej komendy musisz byæ administratorem!");
    return 1;
}
 
CMD:freeze(playerid, params[])
{
    new string[128], targetid, time;
    if(IsPlayerOnAdminDuty(playerid)) {
        if (sscanf(params, "ui", targetid, time)) return SendClientMessage(playerid, COLOR_LIGHTRED, "» U¯YCIE: /freeze [id/nick] [czas w sekundach]");
        if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_LIGHTRED, "» Nie ma takiego gracza!");
        TogglePlayerControllable(targetid, 0);
        SetTimerEx("UnFreeze", time*1000, false, "i", targetid);
        format(string, sizeof(string), "Zosta³eœ zamro¿ony na %i sekund!", time);
        GameTextForPlayer(targetid, string, time*1000, 4);
        format(string, sizeof(string), "» Zosta³eœ zamro¿ony przez administratora %s na czas %i sekund.", pName(playerid), time);
        SendClientMessage(targetid, COLOR_LIGHTRED, string);
        format(string, sizeof(string), "Administrator %s zamrozi³ gracza %s na czas %i sekund.", pName(playerid), pName(targetid), time);
        AdminWarning(COLOR_RED, string, 1);
    }
    else SendClientMessage(playerid, COLOR_RED, "» Aby u¿yæ tej komendy musisz byæ na slu¿bie administratora! (/duty)");
    return 1;
}
 
CMD:silentkill(playerid, params[]) {
    new string[128], targetid;
    if(IsPlayerScriptAdmin(playerid)) {
        if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_LIGHTRED, "» U¯YCIE: /silentkill [id/nick]");
        if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_LIGHTRED, "»  Nie ma takiego gracza!");
        SetPlayerHealth(targetid, 0.0);
        format(string, sizeof(string), "» Zabi³eœ gracza %s!", pName(targetid));
        SendClientMessage(targetid, COLOR_LIGHTBLUE, string);
        format(string, sizeof(string), "AdminWarning: Administrator %s u¿y³ /silentkill na graczu %s [ID:%d]!", pName(playerid), pName(targetid), targetid);
        printf(string);
    }
    else SendClientMessage(playerid, COLOR_RED, "» Aby u¿yæ tej komendy musisz byæ administratorem!");
    return 1;
}
CMD:spec(playerid, params[])
{
   if(IsPlayerScriptAdmin(playerid)) {
        new string[64], targetid;
        if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_LIGHTRED, "» U¯YCIE: /spec [id/nick]");
        if(targetid == playerid) return SendClientMessage(playerid, COLOR_LIGHTRED, "» Nie mo¿esz podgl¹daæ samego siebie!");
        if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_LIGHTRED, "»  Nie ma takiego gracza!");
        if(GetPVarInt(playerid, "Spectating") == 0) {
            SetPVarInt(playerid, "Spectating", 1);
            TogglePlayerSpectating(playerid, 1);
            PlayerSpectatePlayer(playerid, targetid);
            format(string, sizeof(string), "» Podgl¹dasz gracza %s!");
            SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
            format(string, sizeof(string), "%s(ID: %d)", pName(targetid), targetid);
            GameTextForPlayer(playerid, string, 1000000, 4);
        }
        else {
            SetPVarInt(playerid, "Spectating", 0);
            TogglePlayerSpectating(playerid, 0);
            SendClientMessage(playerid, COLOR_LIGHTBLUE, "» Ju¿ nikogo nie podgl¹dasz!");
            GameTextForPlayer(playerid, ".", 1, 4);  
        }
    }
    else SendClientMessage(playerid, COLOR_RED, "» Aby u¿yæ tej komendy musisz byæ administratorem!");
    return 1;
}
//----------SYSTEM KAR end-------
 
CMD:setskin(playerid, params[])
{
    new string[128], targetid, skinid;
    if (IsPlayerOnAdminDuty(playerid))
    {
        if(sscanf(params, "ui", targetid, skinid)) return SendClientMessage(playerid, COLOR_LIGHTRED, "» U¯YCIE: /setskin [id/nick] [id skin]");
        if(skinid <= 311 && skinid >= 0)
        {
            SetPlayerSkin(targetid, skinid);
            pInfo[playerid][Skin] = skinid;
            format(string, sizeof(string), "» Administrator %s nada³ ci skin ID %i.", pName(playerid), skinid);
            SendClientMessage(targetid, COLOR_LIGHTBLUE, string);
            format(string, sizeof(string), "» Ustawi³eœ graczowi %s skin ID %i.", pName(targetid), skinid);
            SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
            format(string, sizeof(string), "AdminWarning: Administrator %s ustawi³ graczowi %s skin ID %i.", pName(playerid), pName(targetid), skinid);
            AdminWarning(COLOR_RED, string, 1);
        }
        else SendClientMessage(playerid, COLOR_RED, "» ID musi byæ liczb¹ pomiêdzy 0 i 311!");
    }
    else SendClientMessage(playerid, COLOR_RED, "» Aby u¿yæ tej komendy musisz byæ na slu¿bie administratora! (/duty)");
    return 1;
}
CMD:giveweapon(playerid, params[])
{
    new string[128], targetid, weaponid, ammoamount, slot;
    if (IsPlayerOnAdminDuty(playerid)) {
        if(sscanf(params, "uiii", targetid, slot, weaponid, ammoamount)) return SendClientMessage(playerid, COLOR_LIGHTRED, "» U¯YCIE: /giveweapon [id/nick] [slot 1-3] [id broni] [ilosc amunicji]");
        if(weaponid <= 46 && weaponid >= 0) {
            if(slot < 1 || slot > 3) return SendClientMessage(playerid, COLOR_LIGHTRED, "» Z³y slot!");
            if(slot == 1) {
                pInfo[targetid][Weapon1] = weaponid;
                pInfo[targetid][Weapon1_ammo] = ammoamount;
                printf("zapisano broñ o id %i z %i ammo pod slotem 1", weaponid, ammoamount);
            }
            else if(slot == 2) {
                pInfo[targetid][Weapon2] = weaponid;
                pInfo[targetid][Weapon2_ammo] = ammoamount;
                printf("zapisano broñ o id %i z %i ammo pod slotem 2", weaponid, ammoamount);
            }
            else if(slot == 3) {
                pInfo[targetid][Weapon3] = weaponid;
                pInfo[targetid][Weapon3_ammo] = ammoamount;
                printf("zapisano broñ o id %i z %i ammo pod slotem 3", weaponid, ammoamount);
            }
            GivePlayerWeapon(playerid, weaponid, ammoamount);
            format(string, sizeof(string), "» Administrator %s nada³ ci broñ o ID %i.", pName(playerid), weaponid);
            SendClientMessage(targetid, COLOR_LIGHTBLUE, string);
            format(string, sizeof(string), "» Da³eœ graczowi %s broñ o ID %i.", pName(targetid), weaponid);
            SendClientMessage(playerid, COLOR_LIGHTRED, string);
            format(string, sizeof(string), "AdminWarning: Administrator %s da³ graczowi %s broñ o ID %i.", pName(playerid), pName(targetid), weaponid);
            AdminWarning(COLOR_RED, string, 1);
        }
        else SendClientMessage(playerid, COLOR_RED, "» ID broni musi byæ liczb¹ pomiêdzy 0 i 46! (wiki.sa-mp.com/wiki/Weapons)");
    }
    else SendClientMessage(playerid, COLOR_RED, "» Aby u¿yæ tej komendy musisz byæ na slu¿bie administratora! (/duty)");
    return 1;
}
 
CMD:killme(playerid, temps) {
    SetPlayerHealth(playerid, 0.0);
    return 1;
}
 
CMD:a(playerid, params[])
{
    new text[128], string[128];
    if (IsPlayerScriptAdmin(playerid)) {
        if(sscanf(params, "s[128]", text)) return SendClientMessage(playerid, COLOR_LIGHTRED, "» U¯YCIE: /a(dminchat) [wiadomoœæ]");
        for(new i = 0; i < MAX_PLAYERS; i++)
        {
            if(IsPlayerConnected(i))
            {
                if (IsPlayerScriptAdmin(playerid))
                {
                    format(string, sizeof(string), "{435638}@ {FF0000}%s [%d]{FFFFFF}:%s", pName(playerid), GetPlayerAdminLevel(playerid), text);
                    SendClientMessage(i, COLOR_WHITE, string);
                }
            }
        }
       
    }
    else SendClientMessage(playerid, COLOR_RED, "» Aby u¿yæ tej komendy musisz byæ administratorem!");
    return 1;
}

CMD:m(playerid, params[])
{
    new text[128], string[128];
    if (IsPlayerModerator(playerid) || IsPlayerScriptAdmin(playerid)) {
        if(sscanf(params, "s[128]", text)) return SendClientMessage(playerid, COLOR_LIGHTRED, "» U¯YCIE: /m(od) [wiadomoœæ]");
        for(new i = 0; i < MAX_PLAYERS; i++)
        {
            if(IsPlayerConnected(i))
            {
                if (IsPlayerModerator(playerid))
                {
                    format(string, sizeof(string), "{0BD9FD}(MODCHAT) {0080FF}%s [%d]{FFFFFF}: %s", pName(playerid), GetPlayerModLevel(playerid), text);
                    SendClientMessage(i, COLOR_WHITE, string);
                }
                if (IsPlayerScriptAdmin(playerid) || IsPlayerSuperAdmin(playerid))
                {
                    format(string, sizeof(string), "{0BD9FD}(MODCHAT) {FF0000} %s [%d]{FFFFFF}: %s", pName(playerid), GetPlayerAdminLevel(playerid), text);
                    SendClientMessage(i, COLOR_WHITE, string);
                }
            }
        }
       
    }
    else SendClientMessage(playerid, COLOR_RED, "» Aby u¿yæ tej komendy musisz byæ moderatorem!");
    return 1;
}
 
CMD:setvip(playerid, params[])
{
    new string[128], targetid;
    if(IsPlayerScriptAdmin(playerid)) {
        if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_LIGHTRED, "» U¯YCIE: /setvip [id/nick]");
        pInfo[targetid][Vip] = 1;
        format(string, sizeof(string), "» Administrator %s nada³ Ci konto VIP.", pName(playerid));
        SendClientMessage(targetid, COLOR_LIGHTRED, string);
        format(string, sizeof(string), "» Nada³eœ graczowi %s konto VIP.", pName(targetid));
        SendClientMessage(playerid, COLOR_LIGHTRED, string);
        format(string, sizeof(string), "AdminWarning: Administrator %s nada³ graczowi %s konto VIP", pName(playerid), pName(targetid));
        AdminWarning(COLOR_RED, string, 1);
    }
    else SendClientMessage(playerid, COLOR_RED, "» Aby u¿yæ tej komendy musisz byæ administratorem!");
    return 1;
}
 
CMD:ulecz(playerid, temps[])
{
    if(IsPlayerVip(playerid)) {
        SendClientMessage(playerid, COLOR_LIGHTRED, "» Zostaniesz uleczony za 3 sekundy!");
        SetTimerEx("Heal", 3000, false, "i", playerid);
    }
    else SendClientMessage(playerid, COLOR_RED, "» Aby u¿yæ tej komendy musisz byæ mieæ konto VIP!");
    return 1;
}
 
CMD:czas(playerid, temps[])
{
    new hour, minute, second, year, month, day, string[64];
    format(string, sizeof(string), "Data: %02d/%02d/%d ~n~Godzina: %02d:%02d:%02d", day, month, year, hour, minute, second);
    GameTextForPlayer(playerid, string, 8000, 1);
    return 1;
}
CMD:togglewarning(playerid, temps[])
{
    if(IsPlayerScriptAdmin(playerid)) {
        if(SetPVarInt(playerid, "DisplayWarnings", 1)) {
            SetPVarInt(playerid, "DisplayWarnings", 0);
            SendClientMessage(playerid, COLOR_ORANGE, "» Wy³¹czy³eœ warningi administratorskie!");
        }
        else {
            SetPVarInt(playerid, "DisplayWarnings", 1);
            SendClientMessage(playerid, COLOR_GREEN, "» W³¹czy³eœ warningi administratorskie!");
        }
    }
    else SendClientMessage(playerid, COLOR_RED, "» Aby u¿yæ tej komendy musisz byæ administratorem!");
    return 1;
}
 
CMD:ann(playerid, params[])
{
   if(IsPlayerScriptAdmin(playerid)) {
        new string[64], input[64];
        if(sscanf(params, "s[64]", input)) return SendClientMessage(playerid, COLOR_LIGHTRED, "» U¯YCIE: /ann [wiadomoœæ]");
        for(new i = 0; i < MAX_PLAYERS; i++)
        {
            if(IsPlayerConnected(i))
            {
                format(string, sizeof(string), "~r~%s~w~: %s", pName(playerid), input);
                GameTextForPlayer(i, string, 10000, 6);
            }
        }
    }
    else SendClientMessage(playerid, COLOR_RED, "» Aby u¿yæ tej komendy musisz byæ administratorem!");
    return 1;
}

CMD:kasa(playerid, params[])
{
    GivePlayerMoney(playerid, 50000);
    SendClientMessage(playerid, COLOR_RED, "» Otrzymujesz $50000 od " SYSTEM );
    return 1;
}
 
//=====================[> FORWARD, PUBLIC >//=====================]
 
//------[KICK CZAS]-----------
forward KickEx(playerid);
public KickEx(playerid)
{
Kick(playerid);
}
forward AdminWarning(color,const string[],level);
public AdminWarning(color,const string[],level)
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            if (pInfo[i][AdminLevel] >= level && GetPVarInt(i, "DisplayWarnings") != 0)
            {
                SendClientMessage(i, color, string);
                printf("%s", string);
            }
        }
    }
    return 1;
}
 
forward LoadUser_data(playerid,name[],value[]);
public LoadUser_data(playerid,name[],value[])
{
    INI_Int("Kills",pInfo[playerid][Kills]);
    INI_Int("Deaths",pInfo[playerid][Deaths]);
    INI_Int("Jail",pInfo[playerid][Jail]);
    INI_Int("Warns",pInfo[playerid][Warns]);
    INI_Int("AdminLevel",pInfo[playerid][AdminLevel]);
    INI_Int("ModLevel",pInfo[playerid][ModLevel]);
    INI_Int("Cash", pInfo[playerid][Cash]);
    INI_Int("Skin", pInfo[playerid][Skin]);
    INI_Int("Vip", pInfo[playerid][Vip]);
    INI_Int("Weapon1",pInfo[playerid][Weapon1]);
    INI_Int("Weapon1_ammo",pInfo[playerid][Weapon1_ammo]);
    INI_Int("Weapon2",pInfo[playerid][Weapon2]);
    INI_Int("Weapon2_ammo",pInfo[playerid][Weapon2_ammo]);
    INI_Int("Weapon3",pInfo[playerid][Weapon3]);
    INI_Int("Weapon3_ammo",pInfo[playerid][Weapon3_ammo]);
    return 1;
}
 
forward ClearLastUserData(playerid);
public ClearLastUserData(playerid) {
    pInfo[playerid][Kills] = 0;
    pInfo[playerid][Deaths] = 0;
    pInfo[playerid][Warns] = 0;
    pInfo[playerid][AdminLevel] = 0;
    pInfo[playerid][ModLevel] = 0;
    pInfo[playerid][Cash] = 0;
    pInfo[playerid][Skin] = 0;
    pInfo[playerid][Jail] = 0;
    pInfo[playerid][Vip] = 0;
    pInfo[playerid][Weapon1] = 0;
    pInfo[playerid][Weapon1_ammo] = 0;
    pInfo[playerid][Weapon2] = 0;
    pInfo[playerid][Weapon2_ammo] = 0;
    pInfo[playerid][Weapon3] = 0;
    pInfo[playerid][Weapon3_ammo] = 0;
    return 1;
}
 
forward Heal(playerid);
public Heal(playerid) {
    SetPlayerHealth(playerid, 100.0);
    SendClientMessage(playerid, COLOR_LIGHTBLUE, "» Uleczy³eœ siê!");
    return 1;
}
 
forward UnFreeze(playerid);
public UnFreeze(playerid) {
    TogglePlayerControllable(playerid, true);
    return 1;
}
/*forward SetPlayerSavedWeapon(playerid, weaponslot, weaponid, ammo);
public SetPlayerSavedWeapon(playerid, weaponslot, weaponid, ammo)
{
    new weaponstring[32], weaponammostring[32];
    if(weaponslot < 1 || weaponslot > 3) return 0;
    format(weaponstring, 24, "pInfo[%i][Weapon%i]", playerid, weaponslot);
    format(weaponammostring, 24, "pInfo[%i][Weapon%i_ammo]", playerid, weaponslot);
    weaponstring = weaponid;
    weaponammostring = ammo;
    return 1;
}*/
forward ShowAdminLoginDialog(playerid);
public ShowAdminLoginDialog(playerid) {
    if(IsPlayerScriptAdmin(playerid)) ShowPlayerDialog(playerid, DIALOG_ADMINLOGIN, DIALOG_STYLE_PASSWORD, DNAZWA DWERSJA " | Administrator", "Wpisz has³o administratora aby kontynuowaæ:", "Login", "Anuluj");
    return 1;
}



//-------------------------
 
pName(playerid)
{
new name[MAX_PLAYER_NAME];
GetPlayerName(playerid, name, MAX_PLAYER_NAME);
return name;
}
GetPlayerAdminLevel(playerid)
{
    new level;
    level = pInfo[playerid][AdminLevel];
    return level;
}
GetPlayerModLevel(playerid)
{
    new level;
    level = pInfo[playerid][ModLevel];
    return level;
}
IsPlayerOnAdminDuty(playerid)
{
    new bool:dutystatus;
    if(GetPVarInt(playerid, "AdminDuty") == 1) {
        dutystatus = true;
        printf("true");
    }
    else if(GetPVarInt(playerid, "AdminDuty") == 0) {
        dutystatus = false;
    }
    return dutystatus;
}
SetPlayerAdminLevel(playerid, level)
{
 return pInfo[playerid][AdminLevel] = level;
}
SetPlayerModLevel(playerid, level)
{
 return pInfo[playerid][ModLevel] = level;
}
UserPath(playerid)
{
    new string[128];
    format(string,sizeof(string),PATH,pName(playerid));
    return string;
}
IsPlayerScriptAdmin(playerid)
{
    new bool:adminstatus;
    if(pInfo[playerid][AdminLevel] > 0)
    {
        adminstatus = true;
    }
    else if(pInfo[playerid][AdminLevel] < 0)
    {
        adminstatus = false;
    }
    return adminstatus;
}
IsPlayerModerator(playerid)
{
    new bool:modstatus;
    if(pInfo[playerid][ModLevel] > 1)
    {
        modstatus = true;
    }
    else if(pInfo[playerid][AdminLevel] < 0)
    {
        modstatus = false;
    }
    return modstatus;
}
IsPlayerVip(playerid)
{
    new bool:vipstatus;
    if(pInfo[playerid][Vip] == 1) {
        vipstatus = true;
    }
    else {
        vipstatus = false;
    }
    return vipstatus;
}
IsPlayerSuperAdmin(playerid)
{
    new bool:adminstatus;
    if(pInfo[playerid][AdminLevel] >= 5000) {
        adminstatus = true;
    }
    else {
        adminstatus = false;
    }
    return adminstatus;
}
PlayerSkin(playerid)
{
    new skin = pInfo[playerid][Skin];
    return skin;
}
/*GetPlayerSavedWeapon(playerid, weaponslot)
{
    new weaponstring[32], val;
    format(weaponstring, 32, "pInfo[%i][Weapon%i]", playerid, weaponslot);
    val = weaponstring;
    return val;
}
GetPlayerSavedWeaponAmmo(playerid, weaponslot)
{
    new weaponstring[32], val;
    format(weaponstring, 32, "pInfo[%i][Weapon%i_ammo]", playerid, weaponslot);
    val = weaponstring;
    return val;
}*/
PlayerArmor(playerid)
{
    new Float:val;
    GetPlayerArmour(playerid, Float:val);
    return Float:val;
}
 
CreateActorWithAnimation(ActorID, ModelID, Float:X, Float:Y, Float:Z, Float:Rotation, animlib[], animname[], loop, freeze, name[], Float:drawdistance, vw, Text3D:textname) {
    ActorID = CreateActor(ModelID, Float:X, Float:Y, Float:Z, Float:Rotation);
    ApplyActorAnimation(ActorID, animlib, animname, 4.1, loop, 1, 1, freeze, 0);
    textname = Create3DTextLabel(name, -1, Float:X, Float:Y, Float:Z + 1.1, Float:drawdistance, vw, 0);
    return 1;
}


CMD:saveactorpos(playerid, params[]) {
    new float:x, float:y, float:z, float:rot, skin, str[128], input[32];
    if(sscanf(params,"s[32]", input)) return SendClientMessage(playerid, COLOR_RED, "USAGE: /saveactorpos [actor name]");
    GetPlayerPos(playerid, Float:x, Float:y, Float:z);
    GetPlayerFacingAngle(playerid, Float:rot);
    skin = GetPlayerSkin(playerid);
    format(str, sizeof(str), "%s, %i, %f, %f, %f, %f", input, skin, float:x, float:y, float:z, float:rot);
    new INI:File = INI_Open("actor_log.ini");
    INI_SetTag(File,"data");
    INI_WriteString(File, "LOG", str);
    INI_Close(File);
    return 1;
}

//ANTI DEAMX - nie w³¹czaæ poki co

WasteDeAMXersTime()
{
    new b;
    #emit load.pri b
    #emit stor.pri b
}