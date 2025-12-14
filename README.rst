Window Pack
===========
|MIT| |APPLE| |Itch|

.. |MIT| image:: https://img.shields.io/badge/License-MIT-yellow.svg
   :target: https://opensource.org/licenses/MIT

.. |APPLE| image:: https://img.shields.io/badge/Apple%20II-ProDOS-0000C0.svg?logo=apple&logoColor=ee0000
   :target: https://github.com/AppleWin/AppleWin

.. |Itch| image:: https://img.shields.io/badge/Itch.io-fa5c5c.svg
   :target: https://myleftgoat.itch.io/windowpack


.. image:: banner.png
   :alt: Splash screen banner
   :align: center


Overview
--------
This library was developed around 1987 to provide a more flexible UI framework
for a series of other applications. The library provides a simple window and
menubar abstraction for Apple II systems in 80 column text more (with mousetext).
One thing of note, this library makes use of 65C02 instructions.  It will not
run on basic 6502 systems or systems w/o an 80 column card in slot 3.  Machines
like the enhanced Apple //e and the //c will support the library. 

Around the end of 1987, the library was entered into the Compute!'s Apple
Applications programming contest.  It took second place and was published
in binary form in the October 1988 issue of that magazine.

In 2024, the original source code to the library was unearthed and the original
programmer decided to fix up the project enough so that it could be rebuild
and run again.  The resulting source code is in this repo and one can 
download a generated disk image from itch.io.

Details
-------
At the core of the library is a simple assembly language dispatch table at
$300.  An '&' interface is supplied for easy use from Applesoft programs.
There is a fairly extensive demo program which includes documentation
for the APIs.  The core of the library is located in the auxiliary 64k memory 
on the 80 column card, preserving the maximum amount of memory for Applesoft 
applications at the expense of the /RAM drive.  

The library is written in 65C02 assembly, but some of the dispatch code was 
entered in the mini-assembler.  Source code for 95% of the library exists in 
Merlin format along with support programs in Applesoft basic.

There is a build script in the repo capable of generating a .po file 
from the sources.  It requires several tools be installed:

- Python
- `Merlin32 Assembler <https://brutaldeluxe.fr/products/crossdevtools/merlin/>`_
- `CiderPress II <https://ciderpress2.com/>`_

If one places the CiderPress CLI in a subdirectory named 'ciderpress' (ciderpress/cp2.exe)
and places the Merlin package in a subdirectory named 'merlin32' 
(merlin32\\Windows\\Merlin32.exe), then the following commands will build
the `Windowpack_Release.po` file:

.. code::

   python -m virtualenv venv
   .\venv\Scripts\activate.ps1
   python build.py


One can adjust the pathnames to CiderPress and Merlin at the top of the build.py file.

Documentation and Issues
------------------------
Most of the documentation can be found by interacting with the `DEMO` basic 
program.  Additional documentation can be found in 
the `Compute! article <media/computes_apple_article.pdf>`_.

Normally, one would download the `.po` file and use it with an emulator or 
burn a 5.25" disk with the image.  Thanks to the great work by Chris Torrence
and Michael Morrison on the `Apple2TS <https://github.com/ct6502/apple2ts>`_ browser 
hosted Apple II emulator, one can run the program via a web browser.  

`Run Window Pack in a browser <https://apple2ts.com/?appmode=game&theme=dark#https://github.com/randall-frank/windowpack/releases/download/v1.0.0/Windowpack_Release.po>`_

Please feel free to post issues and other questions at `DigiSim Issues
<https://github.com/randall-frank/windowpack/issues>`_. This is the best place
to post questions and code.

The game is also hosted on `itch.io <https://myleftgoat.itch.io/windowpack>`_ which provides
a simpler download option and forum to discuss more gameplay related issues.


Things To Do
~~~~~~~~~~~~
TBD


License
-------
`WindowPack` source code is licensed under the MIT license.
