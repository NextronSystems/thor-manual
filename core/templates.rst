.. Index:: Scan Templates

Scan Templates
==============

THOR accepts config files (called "templates") in YAML format. They
reflect all command options to make them flexible and their use as
comfortable as possible.

This means that every parameter set via command line can be provided in
the form of a config file. You can even combine several of these config
files in a single scan run.

Default Template
^^^^^^^^^^^^^^^^

By default, THOR only applies the file named ``thor.yml`` in the
``./config`` sub folder. Other config files can be applied using the
``-t`` command line parameter.

Apply Custom Scan Templates
^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following command line provides a custom scan template named
``mythor.yml`` in the ``config`` directory.

.. code-block:: doscon
   
  C:\nextron\thor>thor.exe -t config\mythor.yml

Example Templates
^^^^^^^^^^^^^^^^^

The default config ``thor.yml`` in the ``./config`` folder has the
following content.

Content of THOR's Default Config ``thor.yml``:

.. literalinclude:: ../examples/thor.yml
   :language: yaml
   :linenos:

Content of Config File ``mythor.yml``:

.. literalinclude:: ../examples/mythor.yml
   :language: yaml
   :linenos:

The default scan template is always applied first. Custom templates can
then overwrite settings in the default template. In the example above,
the ``cpu-limit`` and ``file-size-limit`` parameters are overwritten by
the custom template.

As you can see in the example file, you have to use the long form of the
command line parameter (e.g. ``remote-log``) and not the short form (e.g.
``-s``) in the template files. The long forms can be looked up in the
command line help using ``--help full``.

.. figure:: ../images/image20.png
   :alt: Lookup command line parameter long forms using --help full

   Lookup command line parameter long forms using ``--help full``
