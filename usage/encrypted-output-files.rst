
Encrypted Output Files
======================

THOR allows to encrypt the output files of each scan using the
**--encrypt** parameter. A second parameter **--pubkey** can be used to
specify a public key to use. The public key must be a RSA key of 1024,
2048 or 4096 bit size in PEM format.

.. code:: batch
 
   thor64.exe --encrypt --pubkey mykey.pub

If you don’t specify a public key, THOR uses a default key. The private
key for this default key is stored in "thor-util", which can be used to
decrypt output files encrypted with the default key.

.. code:: bash

   thor-util decrypt file.txt
