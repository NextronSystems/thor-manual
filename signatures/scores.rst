Scoring
=======

All signatures contain a score. Signature scores can range from ``-100``
to ``100``. Negative values reduce the score of elements that are prone
to false positives, while positive values increase the score of the
elements they match.

For more details about scoring, see :ref:`core/score:Scoring System`.

How the score is specified depends on the signature format. See the
format-specific chapters, such as YARA or Sigma, for more information.

Examples
^^^^^^^^

Example false-positive rule:

.. code-block:: yara
   :linenos:

   rule FalsePositive_AVSig1 {
        meta:
             description = "Match on McAfee Signature Files"
             score = -50
        strings:
             $s1 = "%%%McAfee-Signature%%%"
        condition:
             1 of them
   }
