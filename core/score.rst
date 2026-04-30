.. Index:: Scoring System

Scoring System
==============

The scoring system is one of THOR's core features. A score expresses a
combination of severity and confidence as a percentage.

All signatures have a score, and every finding reported by THOR also has
a score derived from the matching signatures. The exact formula is
described in :ref:`core/score:Accumulated Scores`.

All finding scores are between 0 and 100. For example, a finding with a
score of 95 can generally be interpreted as severe and high-confidence.
As always, exceptions can occur, for example in the case of obvious
false positives such as unencrypted or in-memory AV signatures.

The finding score determines the level or severity of the resulting log
message:

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


.. note::

    In addition to the score, the
    :ref:`scanning/using-thor:Object Logging` flag also affects whether
    objects are logged.

Accumulated Scores
^^^^^^^^^^^^^^^^^^

If multiple signatures match the same element, their scores are combined
into one final score. The following section explains how that score is
calculated.

By default, only positive scores and the top two reasons are shown. You
can use ``--alert-reason-limit`` to adjust the number of displayed
reasons.

Reason scores are not added up directly. Instead, given a number of
scores ``(s_0, s_1, ...)`` sorted in descending order, the total score
is calculated with the following formula:

.. code-block:: none

   100 * (1 - (1 - s_0 / 100 / 2^0) * (1 - s_1 / 100 / 2^1)  * (1 - s_2 / 100 / 2^2) * ...)

This means that scores are effectively capped at 100, while multiple
lower scores contribute much less to the total.

You can use Python to try the formula yourself. The following example
uses five subscores, with none of them individually exceeding the alert
threshold of 75:

.. code-block:: python

   subscore0 = 1 - 70 / 100 / pow(2, 0)
   subscore1 = 1 - 70 / 100 / pow(2, 1)
   subscore2 = 1 - 50 / 100 / pow(2, 2)
   subscore3 = 1 - 40 / 100 / pow(2, 3)
   subscore4 = 1 - 40 / 100 / pow(2, 4)
   score = 100 * (1 - (subscore0 * subscore1 * subscore2 * subscore3 * subscore4))
   print(score)
   84.195859375
