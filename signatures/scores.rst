Scoring
=======

All signatures contain a score. Signature scores can be between -100 and 100;
negative values are used to reduce the score on elements that are prone
to false positives, positive scores increase the score of elements that they
match on.

For more details about scoring, see :ref:`core/score:Scoring System`.

How the score is specified depends on the signature format. See the specific
chapter for each format (YARA, Sigma, ...) for more information.

Examples
^^^^^^^^

False Positive Rule:

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
