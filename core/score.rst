.. Index:: Scoring System

Scoring System
--------------

The scoring system is one of THOR's most prominent features.
The score is a metric that expresses
a combination of confidence and severity in percent.

All signatures have a score, and all findings that THOR reports
have a score based on the signature matches that are included. The
exact formula for this is described in :ref:`core/score:Accumulated Scores`.

All finding scores are between 0 and 100. 
This means a finding with a score of 95 can be seen as a severe finding with a
high confidence. Exceptions might be - as always - obvious false
positives like unencrypted or in-memory AV signatures.

The finding's score determines the level/severity of the resulting log message:

.. list-table::
  :header-rows: 1
  :widths: 20, 20, 60

  * - Minimum score
    - Level
    - Flag
  * - 30
    - Info
    - ``--score-info``
  * - 40
    - Notice
    - ``--score-notice``
  * - 60
    - Warning
    - ``--score-warning``
  * - 81
    - Alert
    - ``--score-alert``




All signatures contain a score. Signature scores can be between -100 and 100;
negative values are used to reduce the score on elements that are prone
to false positives, positive scores increase the score of elements that they
match on.

When multiple signatures match on the same element, the 


Scoring per Signature Type Match
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
  :header-rows: 1
  :widths: 25, 75

  * - Type
    - Score
  * - YARA match
    - Defined in the meta data of the YARA rule as integer value (e.g. "score = 50")
  * - IOC match
    - Defined in the IOC (dependent on the format, see :ref:`signatures/ioc-formats:YAML IOC files`)
  * - Sigma rule match
    - Based on the Sigma rule's level:
      - Level low translates to score 40
      - Level medium translates to score 50
      - Level high translates to score 70
      - Level critical translates to score 100

Accumulated Scores
^^^^^^^^^^^^^^^^^^

If multiple signatures match on an element, the scores of all signatures
will be accumulated and calculated into one final score.
The following chapters show you how those scores are calculated.

Please keep in mind that only positive scores and the top two reasons are
shown by default. You can use ``--alert-reason-limit`` to customize the number of
reasons shown.

Reason scores are not added up for the total score. Instead, given a number
of scores (s_0, s_1, ...) that are ordered descending. The total score is
calculated with the following formula:

.. code-block :: none

   100 * (1 - (1 - s_0 / 100 / 2^0) * (1 - s_1 / 100 / 2^1)  * (1 - s_2 / 100 / 2^2) * ...)

This means, scores are "capped" at a maximum of 100, and multiple lower
scores are weighted far less.

You can use python to calculate the score and try the formula. Please note
that we use an example with five sub-scores and no sub-score higher than the
threshold of 75 to turn classify this as an alert:

.. code-block:: python

   subscore0 = 1 - 70 / 100 / pow(2, 0)
   subscore1 = 1 - 70 / 100 / pow(2, 1)
   subscore2 = 1 - 50 / 100 / pow(2, 2)
   subscore3 = 1 - 40 / 100 / pow(2, 3)
   subscore4 = 1 - 40 / 100 / pow(2, 4)
   score = 100 * (1 - (subscore0 * subscore1 * subscore2 * subscore3 * subscore4))
   print(score)
   84.195859375
