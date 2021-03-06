# Tool to build OGRE dependency packages

## Contents

This repository holds scripts to prebuild OGRE for our *NIX and Windows builds. Supported OS:

* Linux x64
  * Debian Buster (10 LTS)
  * Ubuntu Bionic Beaver (18.04 LTS)
  * Ubuntu Eoan Ermine (19.10)
  * Ubuntu Focal Fossa (20.04 LTS)
  * Ubuntu Groovy Gorilla (20.10)
  * Fedora 31
  * Fedora 32
  * Fedora 33

* Windows x64
  * Windows 10

## ToDo's when creating a new branch

A new branch will trigger an automatic build for all supported OS's. Therefore, the branch name must be in the format **vXX.YY.ZZ** where XX.YY.ZZ is the desired OGRE version, e.g. **v1.12.5**. Inside the new branch, do the following:

* Update *version* file to match version in branch name
* Update *ogre* submodule to corresponding OGRE tag
* Update *imgui* submodule to corresponding ImGui tag/branch

## Disclaimer

Please note that this repository does not contain the *OGRE* rendering engine at all. It contains only scripts to build OGRE correspondingly. While these scripts here are licensed under GPLv3, *OGRE* (https://github.com/OGRECave/ogre) is licensed under MIT:

>MIT License
>
>Copyright (c) 2000-2013 Torus Knot Software Ltd
>
>Permission is hereby granted, free of charge, to any person obtaining a copy
>of this software and associated documentation files (the "Software"), to deal
>in the Software without restriction, including without limitation the rights
>to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
>copies of the Software, and to permit persons to whom the Software is
>furnished to do so, subject to the following conditions:
>
>The above copyright notice and this permission notice shall be included in
>all copies or substantial portions of the Software.
>
>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
>AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
>LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
>OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
>THE SOFTWARE.

We also link to our fork of *ImGui* (https://github.com/openhoi/imgui; Original repo: https://github.com/ocornut/imgui) as we use *ImGui* as a *OGRE* build dependency. *ImGui* is also licensed under MIT:

>The MIT License (MIT)
>
>Copyright (c) 2014-2020 Omar Cornut
>
>Permission is hereby granted, free of charge, to any person obtaining a copy
>of this software and associated documentation files (the "Software"), to deal
>in the Software without restriction, including without limitation the rights
>to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
>copies of the Software, and to permit persons to whom the Software is
>furnished to do so, subject to the following conditions:
>
>The above copyright notice and this permission notice shall be included in all
>copies or substantial portions of the Software.
>
>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
>AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
>LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
>OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
>SOFTWARE.
