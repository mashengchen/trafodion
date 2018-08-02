; @@@ START COPYRIGHT @@@
; Licensed to the Apache Software Foundation (ASF) under one
; or more contributor license agreements.  See the NOTICE file
; distributed with this work for additional information
; regarding copyright ownership.  The ASF licenses this file
; to you under the Apache License, Version 2.0 (the
; "License"); you may not use this file except in compliance
; with the License.  You may obtain a copy of the License at
;   http://www.apache.org/licenses/LICENSE-2.0
; Unless required by applicable law or agreed to in writing,
; software distributed under the License is distributed on an
; "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
; KIND, either express or implied.  See the License for the
; specific language governing permissions and limitations
; under the License.
; @@@ END COPYRIGHT @@@
;
; Script generated by the Inno Script Studio Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Trafodion ODBC64 2.2"
#define MyAppVersion "2.2.0"
#define MyAppPublisher "Apache Trafodion"
#define MyAppURL ""
#define MyDriverName "TRAF ODBC 2.2"
#define BUILDDIR  GetEnv('BUILDDIR')

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{5E6042F8-7C2F-490A-899F-9552D5DE8DE2}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultGroupName={#MyAppName}
DefaultDirName={pf}\Trafodion\TRAF ODBC 2.2
OutputBaseFilename=TFODBC64-{#MyAppVersion}
Compression=lzma
SolidCompression=yes
DisableProgramGroupPage=yes
ArchitecturesInstallIn64BitMode=x64
UninstallDisplayName={#MyAppName}
ArchitecturesAllowed=x64
SetupLogging=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "{#BUILDDIR}\win-odbc64\odbcclient\inc\trafsqlext.h"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#BUILDDIR}\lib\x64\Release\traf_odbcDrvMsg_intl0100.dll"; DestDir: "{sys}"
Source: "{#BUILDDIR}\lib\x64\Release\traf_ores0100.dll"; DestDir: "{sys}"
Source: "{#BUILDDIR}\lib\x64\Release\traf_tcpipv40100.dll"; DestDir: "{sys}"
Source: "{#BUILDDIR}\lib\x64\Release\traf_tcpipv60100.dll"; DestDir: "{sys}"
Source: "{#BUILDDIR}\lib\x64\Release\traf_translation01.dll"; DestDir: "{sys}"
Source: "{#BUILDDIR}\lib\x64\Release\trfoadm1.dll"; DestDir: "{sys}"
Source: "{#BUILDDIR}\lib\x64\Release\trfodbc1.dll"; DestDir: "{sys}"
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\MS ODBC Administrator"; Filename: "{sys}\odbcad32.exe";  WorkingDir: "{sys}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"

[Registry]
Root: HKLM; SubKey: Software\ODBC\ODBCINST.INI\ODBC Drivers; ValueType: string; ValueName: {#MyDriverName}; ValueData: Installed ;Flags: uninsdeletekey
Root: HKLM; SubKey: Software\ODBC\ODBCINST.INI\{#MyDriverName}; ValueType: dword; ValueName: UsageCount; ValueData: $00000001 ;Flags: uninsdeletekey
Root: HKLM; SubKey: Software\ODBC\ODBCINST.INI\{#MyDriverName}; ValueType: string; ValueName: Driver; ValueData: {sys}\trfodbc1.dll ;Flags: uninsdeletekey
Root: HKLM; SubKey: Software\ODBC\ODBCINST.INI\{#MyDriverName}; ValueType: string; ValueName: Setup; ValueData: {sys}\trfoadm1.dll ;Flags: uninsdeletekey
Root: HKLM; SubKey: Software\ODBC\ODBCINST.INI\{#MyDriverName}; ValueType: string; ValueName: CertificateDir; ValueData: "{code:getCerDir}" ;Flags: uninsdeletekey
Root: HKLM; SubKey: Software\ODBC\ODBCINST.INI\{#MyDriverName}; ValueType: string; ValueName: CPTimeout; ValueData: 60 ;Flags: uninsdeletekey

[UninstallDelete]
Type: filesandordirs; Name: "{app}"

[Code]
#IFDEF UNICODE
  #DEFINE AW "W"
#ELSE
  #DEFINE AW "A"
#ENDIF
type
  INSTALLSTATE = Longint;
const
  INSTALLSTATE_INVALIDARG = -2;  // An invalid parameter was passed to the function.
  INSTALLSTATE_UNKNOWN = -1;     // The product is neither advertised or installed.
  INSTALLSTATE_ADVERTISED = 1;   // The product is advertised but not installed.
  INSTALLSTATE_ABSENT = 2;       // The product is installed for a different user.
  INSTALLSTATE_DEFAULT = 5;      // The product is installed for the current user.

  VC_2013_REDIST_X64_MIN = '{A749D8E6-B613-3BE3-8F5F-045C84EBA29B}';
  VC_2013_REDIST_X64_ADD = '{929FBD26-9020-399B-9A7A-751D61F0B942}';

var
  CerDirEdit: TNewEdit;
  CerDirButton: TButton;
  CerDirLabel: TLabel;
  CerDirDesLabel: TLabel;

function getCerDir(Param: String): string;
begin
  Result := CerDirEdit.Text;
end;

function MsiQueryProductState(szProduct: string): INSTALLSTATE;
  external 'MsiQueryProductState{#AW}@msi.dll stdcall';

function VCVersionInstalled(const ProductID: string): Boolean;
begin
  Result := MsiQueryProductState(ProductID) = INSTALLSTATE_DEFAULT;
end;

function VCRedistNeedsInstall: Boolean;
begin
  // here the Result must be True when you need to install your VCRedist
  // or False when you don't need to, so now it's upon you how you build
  // this statement, the following won't install your VC redist only when
  // the Visual C++ 2010 Redist (x64) and Visual C++ 2010 SP1 Redist(x64)
  // are installed for the current user
  Result := not (VCVersionInstalled(VC_2013_REDIST_X64_MIN) or
    VCVersionInstalled(VC_2013_REDIST_X64_ADD));
end;

function GetUninstallString(): string;
var
  sUnInstPath: string;
  sUnInstPath_is1: string;
  sUnInstallString: String;
  sAppId: String;
  sAppId_is1: String;
begin
  Result := '';
  sAppId := ExpandConstant('{#emit SetupSetting("AppId")}');
  sAppId_is1 := ExpandConstant('{#emit SetupSetting("AppId")}_is1');
  sUnInstPath := ExpandConstant('Software\Microsoft\Windows\CurrentVersion\Uninstall\') + sAppId;
  sUnInstPath_is1 := ExpandConstant('Software\Microsoft\Windows\CurrentVersion\Uninstall\') + sAppId_is1;

  sUnInstallString := '';
  if not RegQueryStringValue(HKLM, sUnInstPath, 'UninstallString', sUnInstallString) then
    if not RegQueryStringValue(HKCU, sUnInstPath, 'UninstallString', sUnInstallString) then
      if not RegQueryStringValue(HKLM, sUnInstPath_is1, 'UninstallString', sUnInstallString) then
        RegQueryStringValue(HKCU, sUnInstPath_is1, 'UninstallString', sUnInstallString);
  Result := sUnInstallString;
end;

function IsUpgrade: Boolean;
begin
  Result := (GetUninstallString() <> '');
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  bRedistNeedsInstall: Boolean;
  sDefaultBrowserName: String;
  sDefaultBrowserReg: String;
  sDefaultBrowserValue: String;
  iQuotePos: Integer;
  lLength: Longint;
  iRetCode: Integer;
begin
  if CurStep=ssPostInstall then
  begin
    bRedistNeedsInstall := VCRedistNeedsInstall();
    if bRedistNeedsInstall=True then
    begin
      MsgBox('Run-time dependency required by the driver is not found.'+ #13#10#13#10 + 'Proceeding to download and install run-time dependency from Microsoft.', mbInformation, MB_OK);
      if RegQueryStringValue(HKCU,'Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice','Progid',sDefaultBrowserName) then
      begin
        sDefaultBrowserReg := sDefaultBrowserName + '\shell\open\command';
        if RegQueryStringValue(HKCR,sDefaultBrowserReg,'',sDefaultBrowserValue) then
        begin
          iQuotePos := Pos('"',sDefaultBrowserValue);
          Delete(sDefaultBrowserValue,iQuotePos,1);
          lLength := Length(sDefaultBrowserValue);
          iQuotePos := Pos('"',sDefaultBrowserValue);
          Delete(sDefaultBrowserValue,iQuotePos,lLength);
          Exec(sDefaultBrowserValue, 'http://www.microsoft.com/en-us/download/details.aspx?id=40784', '', SW_SHOW, ewNoWait, iRetCode)
        end
      end
    end
  end
end;   


function InitializeSetup: Boolean;
var
  V: Integer;
  iResultCode: Integer;
  sUnInstallString: string;
  sAppId: String;
  sAppId_is1: String;
  sAppName: String;
begin
  Result := True; // in case when no previous version is found
  sAppId := ExpandConstant('{#emit SetupSetting("AppId")}');
  sAppId_is1 := ExpandConstant('{#emit SetupSetting("AppId")}_is1');
  sAppName := ExpandConstant('{#emit SetupSetting("AppName")}');
  sUnInstallString := GetUninstallString();
  if (sUnInstallString <> '') then  //Your App GUID/ID
  begin
    V := MsgBox(ExpandConstant('An existing install of '+ sAppName + ' was detected.' + #13#10#13#10 +'The installer will now uninstall the old version and install the new version.' + #13#10#13#10 +'Do you want to continue?'), mbInformation, MB_YESNO); //Custom Message if App installed
    if V = IDYES then
    begin
      sUnInstallString :=  RemoveQuotes(sUnInstallString);
      if (Pos('msiexec',Lowercase(sUnInstallString)) <> 0) then
      begin
        if not Exec('msiexec.exe', '/X'+sAppId+' /qn', '', SW_SHOW, ewWaitUntilTerminated, iResultCode) then
        begin
        MsgBox('Failed to uninstall existing files.' + #13#10 + ' ' + SysErrorMessage(iResultCode), mbError, MB_OK);
        Result := False;
        end
      end
      else
      begin
        if not Exec(sUnInstallString, '/SILENT', '', SW_SHOW, ewWaitUntilTerminated, iResultCode) then
        begin
        MsgBox('Failed to uninstall existing files.' + #13#10 + ' ' + SysErrorMessage(iResultCode), mbError, MB_OK);
        Result := False;
        end
        else

        Result := True; //if you want to proceed after uninstall
                  //Exit; //if you want to quit after uninstall
     end
     end
    else
      Result := False; //when older version present and not uninstalled
  end;

end;

procedure ChoseCerDirClick(Sender: TObject);
var
  choicedDIR:String;
begin
  if BrowseForFolder(ExpandConstant('choose a Certificate Directory'),choicedDIR,True) then
    CerDirEdit.Text := choicedDIR;
end;

procedure CreateAddonPage;
begin

end;

procedure InitializeWizard();
begin
  CerDirDesLabel := TLabel.Create(WizardForm);
  CerDirDesLabel.Parent := WizardForm.SelectDirPage;
  CerDirDesLabel.Left := ScaleX(0);
  CerDirDesLabel.Top := ScaleY(100);
  CerDirDesLabel.Width := ScaleX(75);
  CerDirDesLabel.Height := ScaleY(21);
  CerDirDesLabel.Caption := ExpandConstant('Certificate directory location');

  CerDirEdit := TNewEdit.Create(WizardForm);
  CerDirEdit.Parent := WizardForm.SelectDirPage;
  CerDirEdit.Left := ScaleX(0);
  CerDirEdit.Top := ScaleY(125);
  CerDirEdit.Width := ScaleX(333);
  CerDirEdit.Height := ScaleY(29);
  CerDirEdit.Text := 'SYSTEM_DEFAULT';

  CerDirButton := TButton.Create(WizardForm);
  CerDirButton.Parent := WizardForm.SelectDirPage;
  CerDirButton.Left := ScaleX(342);
  CerDirButton.Top := ScaleY(125);
  CerDirButton.Width := ScaleX(75);
  CerDirButton.Height := ScaleY(21);
  CerDirButton.Caption := ExpandConstant('Browse... ');
  CerDirButton.OnClick := @ChoseCerDirClick;

  CerDirLabel := TLabel.Create(WizardForm);
  CerDirLabel.Parent := WizardForm.SelectDirPage;
  CerDirLabel.Left := ScaleX(0);
  CerDirLabel.Top := ScaleY(150);
  CerDirLabel.Width := ScaleX(75);
  CerDirLabel.Height := ScaleY(21);
  CerDirLabel.Caption := ExpandConstant('SYSTEM_DEFAULT is the user’s HOME folder');
end;