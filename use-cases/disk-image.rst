.. Index:: Disk Image Analysis

Disk Image Analysis
-------------------

.. hint:: 
  A lot of functions in this chapter require a **forensic lab**
  or **lab** license. This license is geared towards forensic
  experts. Forensic Lab Licenses are a special license type
  with more functionality.

THOR, as a scanner, does not mount disk images to a certain drive
on your forensic workstation. You have to use 3rd party tools for
that task. Please see :ref:`use-cases/disk-image:arsenal image mounter (aim)`
and :ref:`use-cases/disk-image:ftkimager` for Windows or :ref:`use-cases/disk-image:dissect`
for Linux to get an overview of potential tools to use. Other tools
should also work.

First, you mount the image to a certain drive/path with your preferred tool.
Afterwards you can use THOR in the lab scanning mode to analyze the
mounted image.

The following example shows a recommended set of parameters, scanning
a mounted image of a host named ``WKS0001`` on drive ``S:\`` of
your forensic Windows workstation. 

.. code-block:: doscon

  C:\thor>thor64.exe --lab --path-remap S:C -j WKS0001 -p S:\

The following example shows the same parameters for a Linux forensic
workstation. The drive is mounted to ``/mnt/image/fs/sysvol/``.

.. code-block:: console

  nextron@unix:~/thor$ ./thor-linux-64 --lab --path-remap /mnt/image/fs/sysvol/:C -j WKS0001 -p /mnt/image/fs/sysvol/ 

The ``--lab`` parameter will apply several internal flags (e.g. enables
intense mode to scan every file, enables multi-threading, disables
resource control, removes all limitations). The ``--path-remap``
parameter maps every file found in elements of that image to the
original drive letter and allows the message enrichment to work
correctly. The ``-j HOSTNAME`` parameter can be used to write every
log line with the hostname of the original system and not with that
of the forensic workstation.

You find more information on the scan parameters in the chapter
:ref:`scanning/special-scan-modes:lab scanning`.

.. hint::
  This `blog post <https://thinkdfir.com/2021/06/03/you-want-me-to-deal-with-how-many-vmdks/>`__
  mentions different ways to use commercial or built-in tools to mount and scan VMDK images.

Arsenal Image Mounter (AIM)
^^^^^^^^^^^^^^^^^^^^^^^^^^^

We recommend using `Arsenal Image Mounter <https://arsenalrecon.com/products/arsenal-image-mounter>`_.

In case you plan to use an automated setup in which you use scripts
to automatically process images, you could try to use the command-line
of AIM, please see the ``aim_cli.exe`` within the program folder for more help.

FTKImager
^^^^^^^^^

Alternatively, you can use the tool `FTKImager <https://www.exterro.com/digital-forensics-software/ftk-imager>`_
to mount your image.

.. note:: 
  We recommend using Arsenal Image Mounter to mount your images, since we observed better performance
  during our internal tests.

Dissect
^^^^^^^

Dissect is an incident response framework build from various parsers and implementations
of file formats. Tying this all together, Dissect allows you to work with tools named
``target-query`` and ``target-shell`` to quickly gain access to forensic artefacts,
such as Runkeys, Prefetch files, and Windows Event Logs, just to name a few!

You can find the tool here:
https://github.com/fox-it/dissect

For instructions on how to mount a disk image, you can find information here:
https://docs.dissect.tools/en/latest/tools/target-mount.html
