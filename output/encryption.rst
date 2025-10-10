.. Index:: Encryption

Encrypted Output Files
----------------------

THOR allows to encrypt the output files of each scan using the
``--encryption-key`` parameter. This parameter must receive an RSA public key of 1024,
2048 or 4096 bit size in PEM format.

.. code-block:: doscon
 
   C:\thor>thor64.exe --encryption-key mykey-public.pem

THOR Util can be used to decrypt the logs later on: 

.. code-block:: console

   nextron@unix:~$ thor-util decrypt --privkey mykey-private.pem thorlog.json

For more information on "thor-util" see the separate `THOR Util manual <https://thor-util-manual.nextron-systems.com/>`__.
