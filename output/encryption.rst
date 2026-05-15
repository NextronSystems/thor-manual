.. Index:: Encryption

Encrypted Output Files
======================

THOR can encrypt the output files of each scan by using the
``--encryption-key`` parameter. This parameter expects an RSA public key
in PEM format with a size of 1024, 2048, or 4096 bits.

.. code-block:: doscon
 
   C:\thor>thor64.exe --encryption-key mykey-public.pem

You can decrypt the logs later with THOR Util:

.. code-block:: console

   nextron@unix:~$ thor-util decrypt --privkey mykey-private.pem thorlog.json

For more information about ``thor-util``, see the separate `THOR Util
manual <https://thor-util-manual.nextron-systems.com/>`__.
