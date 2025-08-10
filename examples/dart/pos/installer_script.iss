[Setup]
AppId={{E1A2B3C4-D5E6-F7A8-B9C0-D1E2F3A4B5C6}
AppName=Luxe Nails POS
AppVersion=1.0.0
AppPublisher=Luxe Nails
AppPublisherURL=https://luxenails.com
AppSupportURL=https://luxenails.com/support
AppUpdatesURL=https://luxenails.com/updates
DefaultDirName={autopf}\Luxe Nails POS
DefaultGroupName=Luxe Nails POS
AllowNoIcons=yes
OutputDir=installer
OutputBaseFilename=LuxeNails_POS_v1.0.0_Setup
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
MinVersion=10.0
DisableProgramGroupPage=yes
DisableReadyPage=no
DisableFinishedPage=no
SetupLogging=yes
UninstallDisplayName=Luxe Nails POS
UninstallDisplayIcon={app}\luxe_pos.exe

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"
Name: "startupicon"; Description: "Start with Windows (Auto-launch)"; GroupDescription: "Kiosk Mode Options"; Flags: unchecked

[Files]
; Main application files
Source: "build\windows\x64\runner\Release\luxe_pos.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "build\windows\x64\runner\Release\flutter_windows.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "build\windows\x64\runner\Release\flutter_secure_storage_windows_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "build\windows\x64\runner\Release\sqlite3.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "build\windows\x64\runner\Release\sqlite3_flutter_libs_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "build\windows\x64\runner\Release\data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs

; Visual C++ Redistributable (include if needed)
; Source: "redist\VC_redist.x64.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall

; Application assets and database (copying from build output)
Source: "build\windows\x64\runner\Release\data\flutter_assets\assets\database\pos.db"; DestDir: "{app}\data\flutter_assets\assets\database"; Flags: ignoreversion onlyifdoesntexist
Source: "assets\icons\*"; DestDir: "{app}\data\flutter_assets\assets\icons"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\Luxe Nails POS"; Filename: "{app}\luxe_pos.exe"; WorkingDir: "{app}"
Name: "{group}\{cm:UninstallProgram,Luxe Nails POS}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\Luxe Nails POS"; Filename: "{app}\luxe_pos.exe"; WorkingDir: "{app}"; Tasks: desktopicon
Name: "{userstartup}\Luxe Nails POS"; Filename: "{app}\luxe_pos.exe"; WorkingDir: "{app}"; Tasks: startupicon

[Run]
; Install Visual C++ Redistributable if needed
; Filename: "{tmp}\VC_redist.x64.exe"; Parameters: "/quiet"; StatusMsg: "Installing Visual C++ Redistributable..."; Flags: waituntilterminated

; Launch application after installation
Filename: "{app}\luxe_pos.exe"; Description: "{cm:LaunchProgram,Luxe Nails POS}"; Flags: nowait postinstall skipifsilent; WorkingDir: "{app}"

[Registry]
; Add any registry entries needed for the application
Root: HKCU; Subkey: "Software\YourCompany\POS Flutter"; ValueType: string; ValueName: "InstallPath"; ValueData: "{app}"

[Code]
// Custom installation logic can go here
function GetUninstallString(): String;
var
  sUnInstPath: String;
  sUnInstallString: String;
begin
  sUnInstPath := ExpandConstant('Software\Microsoft\Windows\CurrentVersion\Uninstall\{#SetupSetting("AppId")}_is1');
  sUnInstallString := '';
  if not RegQueryStringValue(HKLM, sUnInstPath, 'UninstallString', sUnInstallString) then
    RegQueryStringValue(HKCU, sUnInstPath, 'UninstallString', sUnInstallString);
  Result := sUnInstallString;
end;

function IsUpgrade(): Boolean;
begin
  Result := (GetUninstallString() <> '');
end;
