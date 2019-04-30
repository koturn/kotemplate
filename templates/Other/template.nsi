!include "MUI.nsh"
!include "x64.nsh"
!include "WinVer.nsh"
!include "WinMessages.nsh"

!define ARCH "any"
# !define ARCH "x64"
# !define ARCH "x86"

!define PRODUCT_NAME "NSIS Template"
!define PRODUCT_VERSION "1.0.0.0"
!define AUTHOR "<+AUTHOR+>"
!define APP_NAME "NsisTemplate"

# Destinations
!define INSTALLED_CHILD_DIR "${AUTHOR}\${APP_NAME}"
!define INSTALLED_APP_FILEPATH "$INSTDIR\${APP_NAME}.exe"
!define UNINSTALLER_FILE_PATH "$INSTDIR\uninst.exe"


Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "Setup.exe"
SetCompressor zlib
# SetCompressor /SOLID lzma
# SetDatablockOptimize on
ShowInstDetails show
ShowUnInstDetails show
!if ${ARCH} == "x86"
  InstallDir "$PROGRAMFILES32\${INSTALLED_CHILD_DIR}"
!else
  InstallDir "$PROGRAMFILES64\${INSTALLED_CHILD_DIR}"
!endif


# Install items
!define COMMON_DIR "common"
!define X64_DIR "x64"
!define X86_DIR "x86"
!define COMMON_DEPENDENT_COMPONENT_DIR "${COMMON_DIR}\DependentComponentInstallers"
!define COMMON_INSTALL_FILE_DIR "${COMMON_DIR}\InstallFiles"
!define X64_DEPENDENT_COMPONENT_DIR "${X64_DIR}\DependentComponentInstallers"
!define X64_INSTALL_FILE_DIR "${X64_DIR}\InstallFiles"
!define X86_DEPENDENT_COMPONENT_DIR "${X86_DIR}\DependentComponentInstallers"
!define X86_INSTALL_FILE_DIR "${X86_DIR}\InstallFiles"
!define TEMP_DIR "$TEMP\${AUTHOR}\${APP_NAME}"
!define INSTALLER_DOTNET_FRAMEWORK "NDP461-KB3102436-x86-x64-AllOS-ENU.exe"
!define INSTALLER_VCRUNTIME_X64 "VC_redist.x64.exe"
!define INSTALLER_VCRUNTIME_X86 "VC_redist.x86.exe"

# MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"


!if ${ARCH} == "x64"
Function .onInit
  ${IfNot} ${RunningX64}
    MessageBox MB_OK "It cannot be installed in a 32 bit environment."
    Abort
  ${EndIf}
FunctionEnd
!endif

!if ${ARCH} == "x86"
Function .onInit
  ${If} ${RunningX64}
    MessageBox MB_YESNO|MB_ICONQUESTION "This is 32 bit application installer.$\nBut your environment is 64 bit system.$\nAre you sure want to install 32 bit application to your 64 bit environment?" IDYES +2
    Abort
  ${EndIf}
FunctionEnd
!endif

Function .onInstSuccess
  # MessageBox MB_YESNO|MB_ICONQUESTION "Installation is completed.$\nWould you like to restart now?"  IDNO +2
  # Reboot
  MessageBox MB_YESNO|MB_ICONQUESTION "Installation is completed.$\nWould you like to launch installed application now?"  IDNO +2
  Exec "${INSTALLED_APP_FILEPATH}"
FunctionEnd

Function .onInstFailed
  MessageBox MB_OK|MB_ICONEXCLAMATION "Failed to install application"
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) is completly deleted from this computer"
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure want to delete $(^Name) and its components?" IDYES +2
  Abort
FunctionEnd


# Install .NET Framework and VC runtime
Function SetupDependentComponents
  SetOutPath "${TEMP_DIR}"
  File /r "${COMMON_DEPENDENT_COMPONENT_DIR}\*"
  ExecWait "${TEMP_DIR}\${INSTALLER_DOTNET_FRAMEWORK}"
  Call "${ARCH}SetupDependentComponents"
  RMDir /r "${TEMP_DIR}"
FunctionEnd

!if ${ARCH} == "any"
Function anySetupDependentComponents
  ${If} ${RunningX64}
    Call x64SetupDependentComponents
  ${Else}
    Call x86SetupDependentComponents
  ${Endif}
FunctionEnd
!endif

!if "${ARCH}" != "x86"
Function x64SetupDependentComponents
  SetOutPath "${TEMP_DIR}"
  File /r "${X64_DEPENDENT_COMPONENT_DIR}\*"
  ExecWait "${TEMP_DIR}\${INSTALLER_VCRUNTIME_X64}"
FunctionEnd
!endif

!if ${ARCH} != "x64"
Function x86SetupDependentComponents
  SetOutPath "${TEMP_DIR}"
  File /r "${X86_DEPENDENT_COMPONENT_DIR}\*"
  ExecWait "${TEMP_DIR}\${INSTALLER_VCRUNTIME_X86}"
FunctionEnd
!endif


# Create application shortcut and uninstaller shortcut on startmenu
Function CreateShortcut
  CreateShortCut "$DESKTOP\${APP_NAME}.lnk" "${INSTALLED_APP_FILEPATH}"
  Call CreateUninstallerShortcutOnStartmenu
FunctionEnd

Function CreateUninstallerShortcutOnStartmenu
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk" "$INSTDIR\uninst.exe"
FunctionEnd


!if ${ARCH} == "any"
Function anyCopyFiles
  ${If} ${RunningX64}
    Call x64CopyFiles
  ${Else}
    Call x86CopyFiles
  ${Endif}
FunctionEnd
!endif

!if ${ARCH} != "x86"
Function x64CopyFiles
  File /r "${X64_INSTALL_FILE_DIR}\*"
FunctionEnd
!endif

!if ${ARCH} != "x64"
Function x86CopyFiles
  File /r "${X86_INSTALL_FILE_DIR}\*"
FunctionEnd
!endif


Section "MainSection"
  SetOutPath "$INSTDIR"
  File /r "${COMMON_INSTALL_FILE_DIR}\*"
  Call "${ARCH}CopyFiles"
  Call CreateShortcut
  Call SetupDependentComponents
SectionEnd


# Uninstall
Section Uninstall
  RMDir /r "$INSTDIR"
  Delete "$DESKTOP\${APP_NAME}.lnk"
  SetAutoClose true
SectionEnd

Section -Post
  WriteUninstaller "${UNINSTALLER_FILE_PATH}"
SectionEnd
