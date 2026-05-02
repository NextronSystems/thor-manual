.. Index:: Ansible

Ansible (Linux)
================

Distribute Run with Ansible
^^^^^^^^^^^^^^^^^^^^^^^^^^^

In practice, it is often necessary to run THOR on many servers in a
network. This section describes one way to do that while keeping the
footprint on the target system minimal and avoiding dependencies on a
specific Linux distribution.

Ansible
^^^^^^^

`Ansible <https://www.ansible.com>`_ is a solution for performing tasks
across multiple systems in a network. It is available in an open-source
edition as well as in commercially supported enterprise offerings.
Ansible uses SSH to connect to target hosts and executes defined sets of
tasks called playbooks. By default, it uses key-based authentication,
but other authentication methods can also be configured. Tasks and
targets can be customized using host groups, which can be used, for
example, to separate different Linux distributions. The remaining steps
can stay the same. Within the playbook, any THOR command-line option can
be customized for the given scenario.

Ansible handles task parallelization automatically. The default number
of parallel executions is five and can be adjusted with the ``-f`` or
``--forks`` parameter when starting a playbook.

Execute THOR using Ansible
^^^^^^^^^^^^^^^^^^^^^^^^^^

The following section shows how to use an Ansible playbook to execute
THOR on multiple Linux systems.

It performs the following steps on each system:

* Create a temporary folder
* Mount a RAM drive using the folder as mount point
* Copy THOR to this RAM drive
* Execute THOR
* Unmount the RAM drive
* Delete the temporary folder

Inventory File
^^^^^^^^^^^^^^

First, define the list of hosts on which THOR should run. This is done
by creating a YAML file containing the hostnames or IP addresses of the
target hosts. The file is later used with the ``-i`` parameter of the
``ansible-playbook`` command. A simple example could look like this:

.. code-block:: yaml

   ---
   host1.com
   host2.com
   132.123.213.111

To learn more about Ansible inventory files, refer to the
`official documentation <https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html>`_.

Ansible Playbook Template
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ../examples/ansible-template.yml
   :language: yaml
   :linenos:

Usage of THOR's Ansible playbook
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Copy the playbook into THOR's main directory. It can then be started as
follows:

.. code-block:: console

   nextron@unix:~$ ansible-playbook -f <number_of_parallel_executions> -i <inventory_file> thorplaybook.yml

After the playbook has finished running the scans, the output for each
system can be found in the ``thoransible-output`` directory located in
THOR's parent directory. Therefore, the user running
``ansible-playbook`` must have sufficient write permissions for this
directory.

Adjust THOR's Command Line Parameters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

By default, this playbook starts THOR only with the parameter that
defines the output log file. You can change this in the ``Execute
THOR`` task of the playbook. However, changing the output log file is
not recommended, because later tasks in the playbook depend on it.
