.. Index:: Ansible

Ansible (Linux)
---------------

Distribute Run with Ansible
^^^^^^^^^^^^^^^^^^^^^^^^^^^

In practice it is crucial to execute THOR on many servers in a network.
A possible way to achieve this is described within this paper, taking
into account that the footprint on the target should be minimal and that
the procedure should not depend on the used Linux Distribution.

Ansible
^^^^^^^

The software Ansible (https://www.ansible.com) is a solution to perform
tasks distributed over a network on different targets. An Open Source
Version is available as well as a version with commercial support for
enterprises. Ansible uses SSH to connect to the target hosts and
performs a defined set of tasks on them called playbooks. Per default it
uses keys for authentication, but this can be setup differently. Please
refer to the official documentation for other methods of
authentication. The tasks and the targets can be customized using
host groups. The host groups may be used to separate different Linux
distributions. The other steps may remain the same. Within the playbook
any command line option may be customized for the given scenario.

Ansible does parallelization of the tasks by itself. The default amount
of parallel executions is five and can be configured using the ``-f`` or
``--forks`` parameter when starting the playbooks.

Execute THOR using Ansible
^^^^^^^^^^^^^^^^^^^^^^^^^^

The following section will show how to use an Ansible playbook to execute
THOR on multiple Linux systems.

It will perform following steps on each system:

* Create a temporary folder
* Mount a RAM drive using the folder as mount point
* Copy THOR to this RAM drive
* Execute THOR
* Unmount the RAM drive
* Delete the temporary folder

Inventory File
^^^^^^^^^^^^^^

First it is needed to define a list of hosts to execute THOR on. This is
done by setting up a YAML file with the hostnames or IP addresses of the
hosts. This file is later used with the -i parameter in the
ansible-playbook command. A simple version of this could look like
following:

.. code-block:: yaml
   
   ---
   host1.com
   host2.com
   132.123.213.111

To learn more about Ansible inventory files and how to use them, please
refer to the official documentation:

https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html

Ansible Playbook Template
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ../examples/ansible-template.yml
   :language: yaml
   :linenos:

Usage of THOR's Ansible playbook
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Copy the playbook in the main directory of THOR. After this is done it
can be started as follows:

.. code-block:: console

   nextron@unix:~$ ansible-playbook -f <number_of_parallel_executions> -i <inventory_file> thorplaybook.yml

After the playbook finished running the scans, the output of each system
can be found in the **thoransible**-output directory located at the
parent directory of THOR. Therefor it is important that the user
starting ansible-playbook has the required rights to write in this
directory.

Adjust THOR's Command Line Parameters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Per default this playbook will only start THOR with the parameter that
defines the output log file. This can be changed in the playbook in the
"Execute THOR"-Task. However, it should be kept in mind, that changing
the output log file is not recommended, since the later tasks of the
playbook depend on this.
