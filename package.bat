@echo off
setlocal EnableDelayedExpansion

@rem ##############################################################################
@rem ##                                                                          ##
@rem ## Tool to build and (if requested) to deploy OGRE library for *NIX         ##
@rem ## !DO NOT RUN THIS SCRIPT AS ROOT!                                         ##
@rem ##                                                                          ##
@rem ##############################################################################




@rem Do some preparations...
set CHECKMARK=[32m[Y][0m
set CROSSMARK=[91m[X][0m
set LINEBEG=[36m:: [0m
set CWD=%CD%




@rem At first, ensure that we are not root as some commands we execute are not recommended
@rem to be called with root permissions
echo %LINEBEG% Checking for Windows environment...

for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
if "%VERSION%" == "10.0" (
    echo %CHECKMARK% Windows 10 is supported.
) else (
    echo %CROSSMARK% Your Windows Version %VERSION% is not supported. Aborting. You may have to install all dependencies manually.
    goto end
)

if "%PROGRAMFILES%" == "C:\Program Files" (
    echo %CHECKMARK% 64 bit is supported.
) else (
    echo %CROSSMARK% 32 bit is not supported. Aborting. You may have to install all dependencies manually.
    goto end
)

where /q MSBuild
if %errorLevel% == 0 (
    echo %CHECKMARK% Inside MSVC developer x64 command promt
) else (
    echo %CROSSMARK% You must call this batch file from a running MSVC x64 developer command prompt
    goto end
)




@rem Then, check for required tools
echo %LINEBEG% Checking for required tools...

where /q choco
if %errorLevel% == 0 (
    echo %CHECKMARK% Chocolatey is installed and found.
    set CHOCOLATEY_INSTALLED=y
) else (
    echo %CROSSMARK% Chocolatey is not installed or not inside Windows PATH. This is okay, but you may have to install required dependencies manually. If you want, install Chocolatey from https://chocolatey.org/install
    set CHOCOLATEY_INSTALLED=n
    goto end
)

where /q git
if %errorLevel% == 0 (
    echo %CHECKMARK% Git is installed and found.
) else (
    if "%CHOCOLATEY_INSTALLED%" == "y" (
        echo %LINEBEG% Installing Git...
        choco install git.install --yes --force --params "/GitAndUnixToolsOnPath /SChannel"
        set SCRIPT_INSTALLED_SOMETHING=y
    ) else (
        echo %CROSSMARK% Git is not installed or not inside Windows PATH. Aborting. Please install Git from https://git-scm.com/download/win
        goto end
    )
)

where /q cmake
if %errorLevel% == 0 (
    echo %CHECKMARK% CMake is installed and found.
) else (
    if "%CHOCOLATEY_INSTALLED%" == "y" (
        echo %LINEBEG% Installing CMake...
        choco install cmake.install --yes --force --installargs 'ADD_CMAKE_TO_PATH=System'
        set SCRIPT_INSTALLED_SOMETHING=y
    ) else (
        echo %CROSSMARK% CMake is not installed or not inside Windows PATH. Aborting. Please install CMake from https://cmake.org/download
        goto end
    )
)

where /q ninja
if %errorLevel% == 0 (
    echo %CHECKMARK% Ninja is installed and found.
) else (
    if "%CHOCOLATEY_INSTALLED%" == "y" (
        echo %LINEBEG% Installing Ninja...
        choco install ninja --yes --force
        set SCRIPT_INSTALLED_SOMETHING=y
    ) else (
        echo %CROSSMARK% Ninja is not installed or not inside Windows PATH. Aborting. Please install Ninja from https://github.com/ninja-build/ninja/releases
        goto end
    )
)

where /q 7z
if %errorLevel% == 0 (
    echo %CHECKMARK% 7-Zip is installed and found.
) else (
    if "%CHOCOLATEY_INSTALLED%" == "y" (
        echo %LINEBEG% Installing 7-Zip...
        choco install 7zip.install --yes
        set SCRIPT_INSTALLED_SOMETHING=y
    ) else (
        echo %CROSSMARK% 7-Zip is not installed or not inside Windows PATH. Aborting. Please install 7-Zip from https://www.7-zip.org
        goto end
    )
)




@rem Refresh environmental variables if required
if "%SCRIPT_INSTALLED_SOMETHING%" == "y" (
    echo %LINEBEG% Refreshing environmental variables...
    refreshenv
)




@rem Then, check, if we shall only do the build
set BUILD_ONLY=%1




@rem Update submodules
echo %LINEBEG% Cleanup and preparations...

git submodule update --init --recursive




@rem Install all required packages...
for /F "tokens=1* delims==" %%A in (version) do (
  set %%A=%%B
)

if not "%BUILD_ONLY%" == "y" (
  @rd /s /q %CWD%/build 2>nul
  mkdir %CWD%/build
)

echo %LINEBEG% Compiling OGRE...
set OGRE_VERSION=%VERSION_MAJOR%.%VERSION_MINOR%.%VERSION_PATCH%
set OGRE_TAG=v%OGRE_VERSION%

git -C ogre reset --hard %OGRE_TAG%

cd ogre
@rd /s /q Components\Overlay\src\imgui 2>nul
mklink /D Components\Overlay\src\imgui %CWD%\imgui
@rd /s /q build 2>nul
mkdir build
cd build
set OGRE_CMAKE_PARAMS=-DOGRE_BUILD_TESTS=OFF -DOGRE_BUILD_SAMPLES=OFF -DOGRE_INSTALL_SAMPLES=OFF -DOGRE_INSTALL_SAMPLES_SOURCE=OFF -DOGRE_BUILD_TOOLS=OFF -DOGRE_BUILD_TOOLS=OFF -DOGRE_INSTALL_TOOLS=OFF -DOGRE_INSTALL_DOCS=OFF -DOGRE_INSTALL_PDB=OFF -DOGRE_CONFIG_DOUBLE=OFF -DOGRE_CONFIG_ENABLE_DDS=ON -DOGRE_CONFIG_ENABLE_ETC=OFF -DOGRE_CONFIG_ENABLE_ZIP=OFF -DOGRE_CONFIG_ENABLE_ETC=OFF -DOGRE_STATIC=OFF -DOGRE_COPY_DEPENDENCIES=OFF -DOGRE_INSTALL_DEPENDENCIES=OFF -DOGRE_BUILD_PLUGIN_BSP=OFF -DOGRE_BUILD_PLUGIN_OCTREE=OFF -DOGRE_BUILD_PLUGIN_PCZ=OFF -DOGRE_BUILD_PLUGIN_PFX=ON -DOGRE_BUILD_PLUGIN_DOT_SCENE=OFF -DOGRE_BUILD_COMPONENT_PAGING=OFF -DOGRE_BUILD_COMPONENT_MESHLODGENERATOR=OFF -DOGRE_BUILD_COMPONENT_TERRAIN=OFF -DOGRE_BUILD_COMPONENT_RTSHADERSYSTEM=ON -DOGRE_BUILD_COMPONENT_VOLUME=OFF -DOGRE_BUILD_COMPONENT_BITES=OFF -DOGRE_BUILD_RENDERSYSTEM_GL=ON -DOGRE_BUILD_RENDERSYSTEM_GL3PLUS=ON -DOGRE_BUILD_RENDERSYSTEM_D3D9=OFF -DOGRE_BUILD_COMPONENT_OVERLAY=ON -DOGRE_BUILD_COMPONENT_OVERLAY_IMGUI=ON
@rem Build Release
cmake %OGRE_CMAKE_PARAMS% -DCMAKE_BUILD_TYPE=Release -G Ninja ..
ninja
ninja install
robocopy "%CWD%\ogre\build\sdk\include" "%CWD%\build\ogre3d\include" /mir
robocopy "%CWD%\ogre\build\sdk\lib" "%CWD%\build\ogre3d\lib" OgreMain.lib OgreOverlay.lib OgreProperty.lib OgreRTShaderSystem.lib OgreGLSupport.lib
robocopy "%CWD%\ogre\build\sdk\lib\OGRE" "%CWD%\build\ogre3d\lib" Codec_STBI.lib Plugin_ParticleFX.lib RenderSystem_Direct3D11.lib RenderSystem_GL.lib RenderSystem_GL3Plus.lib
robocopy "%CWD%\ogre\build\sdk\bin" "%CWD%\build\ogre3d\bin" Codec_STBI.dll OgreBites.dll OgreMain.dll OgreOverlay.dll OgreProperty.dll OgreRTShaderSystem.dll Plugin_ParticleFX.dll RenderSystem_Direct3D11.dll RenderSystem_GL.dll RenderSystem_GL3Plus.dll
robocopy "%CWD%\ogre\build\Dependencies\include\SDL2" "%CWD%\build\sdl2\include\SDL2" /mir
robocopy "%CWD%\ogre\build\Dependencies\lib" "%CWD%\build\sdl2\lib" SDL2.lib SDL2main.lib
robocopy "%CWD%\ogre\build\Dependencies\bin" "%CWD%\build\sdl2\bin" SDL2.dll
@rem Build Debug
cmake %OGRE_CMAKE_PARAMS% -DCMAKE_BUILD_TYPE=Debug -G Ninja ..
ninja
ninja install
robocopy "%CWD%\ogre\build\sdk\lib" "%CWD%\build\ogre3d\lib" OgreMain_d.lib OgreOverlay_d.lib OgreProperty_d.lib OgreRTShaderSystem_d.lib OgreGLSupport_d.lib
robocopy "%CWD%\ogre\build\sdk\lib\OGRE" "%CWD%\build\ogre3d\lib" Codec_STBI_d.lib Plugin_ParticleFX_d.lib RenderSystem_Direct3D11_d.lib RenderSystem_GL_d.lib RenderSystem_GL3Plus_d.lib
robocopy "%CWD%\ogre\build\sdk\bin" "%CWD%\build\ogre3d\bin" Codec_STBI_d.dll Plugin_ParticleFX_d.dll OgreMain_d.dll OgreOverlay_d.dll OgreProperty_d.dll OgreRTShaderSystem_d.dll RenderSystem_Direct3D11_d.dll RenderSystem_GL_d.dll RenderSystem_GL3Plus_d.dll
robocopy "%CWD%\ogre\build\bin" "%CWD%\build\ogre3d\bin" Codec_STBI_d.pdb Plugin_ParticleFX_d.pdb OgreMain_d.pdb OgreOverlay_d.pdb OgreProperty_d.pdb OgreRTShaderSystem_d.pdb RenderSystem_Direct3D11_d.pdb RenderSystem_GL_d.pdb RenderSystem_GL3Plus_d.pdb




@rem PACKAGE
cd %CWD%\build
@rd /s /q package 2>nul
7z a -t7z -mx=9 -mfb=273 -ms -md=31 -myx=9 -mtm=- -mmt -mmtf -md=1536m -mmf=bt3 -mmc=10000 -mpb=0 -mlc=0 %CWD%\build\package\ogre_msvc_%OGRE_VERSION%.7z .\* -r
cd %CWD%


@rem Reset OGRE Overlay code
echo %LINEBEG% Cleanup...

@rd /s /q ogre/Components/Overlay/src/imgui 2>nul
git -C ogre reset --hard %OGRE_TAG%
