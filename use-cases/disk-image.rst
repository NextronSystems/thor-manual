.. Index:: Disk Image Analysis

Disk Image Analysis
===================

.. hint:: 
  Many functions in this chapter require a **forensic lab** or
  **lab** license. This license type is intended for forensic use cases
  and includes additional functionality.

THOR does not mount disk images on your forensic workstation by itself.
You need third-party tools for that task. For Windows, see
:ref:`use-cases/disk-image:arsenal image mounter (aim)` and
:ref:`use-cases/disk-image:ftkimager`. For Linux, see
:ref:`use-cases/disk-image:dissect`. Other tools may work as well.

First, mount the image to a drive or path by using your preferred tool.
After that, you can use THOR in lab scanning mode to analyze the
mounted image.

The following example shows a recommended set of parameters for
scanning a mounted image of a host named ``WKS0001`` on drive ``S:\``
of a forensic Windows workstation.

.. code-block:: doscon

  C:\thor>thor64.exe --lab --path-remap S:C -j WKS0001 -p S:\

The following example uses the same parameters on a Linux forensic
workstation, where the image is mounted at
``/mnt/image/fs/sysvol/``.

.. code-block:: console

  nextron@unix:~/thor$ ./thor-linux-64 --lab --path-remap /mnt/image/fs/sysvol/:C -j WKS0001 -p /mnt/image/fs/sysvol/ 

The ``--lab`` parameter enables several internal flags, for example deep
scanning of every file, multi-threading, and disabled resource control.
The ``--path-remap`` parameter maps files found in the mounted image to
their original drive letter so that message enrichment works correctly.
The ``-j HOSTNAME`` parameter makes THOR write the hostname of the
original system to every log line instead of the hostname of the
forensic workstation.

You can find more information about these scan parameters in
:ref:`scanning/special-scan-modes:lab scanning`.

.. hint::
  This `blog post <https://thinkdfir.com/2021/06/03/you-want-me-to-deal-with-how-many-vmdks/>`__
  describes different ways to use commercial or built-in tools to mount
  and scan VMDK images.

Arsenal Image Mounter (AIM)
^^^^^^^^^^^^^^^^^^^^^^^^^^^

We recommend using `Arsenal Image Mounter <https://arsenalrecon.com/products/arsenal-image-mounter>`_.

If you plan to build an automated workflow that processes images with
scripts, consider using the AIM command line. See ``aim_cli.exe`` in
the program directory for more information.

FTKImager
^^^^^^^^^

Alternatively, you can use `FTK Imager <https://www.exterro.com/digital-forensics-software/ftk-imager>`_
to mount your image.

.. note:: 
  We recommend Arsenal Image Mounter for mounting images, as it showed
  better performance in our internal tests.

Dissect
^^^^^^^

Dissect is an incident response framework built from various parsers and
file format implementations. It provides tools such as
``target-query`` and ``target-shell`` to give you quick access to
forensic artifacts such as Run keys, Prefetch files, and Windows Event
Logs.

You can find the tool here:
`Dissect on GitHub <https://github.com/fox-it/dissect>`__

Instructions on mounting a disk image are available here:
`Dissect target-mount documentation <https://docs.dissect.tools/en/latest/tools/target-mount.html>`__
