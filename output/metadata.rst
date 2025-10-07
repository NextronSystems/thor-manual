.. Index:: Signature Metadata

Signature Metadata
------------------

By using the ``--print-signatures`` flag, you can get a list of all
initialized YARA and Sigma rules.

.. figure:: ../images/image35.png
   :alt: Signature Metadata

   Signature Metadata

This information can also be printed machine readable as JSON by using the ``--print-signatures-json`` flag.

The output of this argument also reflects any signature selectors or filters
set via command line argument. Please see :ref:`scanning/using-thor:select or filter signatures during initialization`
for more information.

This can be a nice way to verify which signatures will be used during a
scan when setting specific arguments. Additionally, this way of looking
for a specific signature or vulnerability can show you quickly if
we have any signatures for your specific use case available.

.. figure:: ../images/signatures-include-print-signatures.png
   :alt: Signatures-Include with Print-Signatures

   Signatures-Include with Print-Signatures