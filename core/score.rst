.. Index:: Scoring System

Scoring System
==============

The scoring system is one of THOR's core features:

* Every signature (rule or IOC) has a **score** that expresses a
  combination of severity and confidence as a percentage, from 0 to 100.
* When a signature matches an element (for example a file or a process),
  that match becomes a **reason** carrying the signature's score.
* If an element matches several signatures, its **assessment** can have
  several reasons.
* THOR combines those reason-scores into **one overall score** that
  determines the assessment's **level** (Info, Notice, Warning, or Alert).
* **Alert** additionally requires at least one high-scoring reason.

Score of a Single Finding
-------------------------

Every reason in a finding inherits the score of the signature it matched.
For example, a reason with a score of 95 can generally be interpreted as
severe and high-confidence. Exceptions can occur, for example with obvious
false positives such as unencrypted or in-memory AV signatures.

Overall Score of an Assessment
------------------------------

THOR combines all reason-scores for one element into one overall score.
In practice, the more matches an element has, and the stronger they are,
the higher its overall score. The overall score maps to these levels:

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

These minima apply to an assessment's **overall** score. For Alert,
the overall score alone is not enough:

.. admonition:: When is an assessment an Alert?

    An assessment is logged as an Alert only when **both** of these hold:

    * its **overall score** is at least **81** (set with ``--score-alert``),
      **and**
    * at least **one reason** scores higher than **75**.

.. note::

    In addition to the score, the
    :ref:`scanning/using-thor:Object Logging` flag also affects whether
    objects are logged.

Each assessment can list several of the reasons behind its score. By default,
only positive scores and the top two reasons are shown. You can use
``--alert-reason-limit`` to adjust the number of displayed reasons.

.. tip::

    The formula below is an *under-the-hood* detail that most users can
    safely skip. Read on only for the precise calculation.

Reason scores are not added up directly. Instead, given a number of
scores ``(s_0, s_1, ...)`` sorted in descending order, the overall score
is calculated with the following formula:

.. code-block:: none

    100 * (1 - (1 - s_0 / 100 / 2^0) * (1 - s_1 / 100 / 2^1) * (1 - s_2 / 100 / 2^2) * ...)

This means that scores are effectively capped at 100, while multiple
lower scores contribute much less to the total.

You can use Python to try the formula yourself. The following example
uses five reasons, the strongest of which scores only 70:

.. code-block:: python

   subscore0 = 1 - 70 / 100 / pow(2, 0)
   subscore1 = 1 - 70 / 100 / pow(2, 1)
   subscore2 = 1 - 50 / 100 / pow(2, 2)
   subscore3 = 1 - 40 / 100 / pow(2, 3)
   subscore4 = 1 - 40 / 100 / pow(2, 4)
   score = 100 * (1 - (subscore0 * subscore1 * subscore2 * subscore3 * subscore4))
   print(score)
   84.195859375

Although the overall score (about 84.2) passes the Alert threshold, the
strongest reason (70) stays below the single-reason threshold. This assessment
is therefore a **Warning**, not an Alert.
