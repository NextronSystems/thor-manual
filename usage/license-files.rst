.. role:: raw-html-m2r(raw)
   :format: html

License Files
=============

THOR processes the program folder and all sub folders in search for a
valid license file with a "**\*.lic**" extension and picks the first
valid license he can find.

This change has been made to facilitate the rollout using the new host
based license model.

You can now generate licenses for a big set of systems, store all the
licenses as "**thor-system1.lic**", "**this-system2.lic**" and so on in
a sub folder "**./licenses**" and transfer the THOR program folder with
the "licenses" sub folder to all the different system for which you have
generated licenses and just run the "**thor.exe**" executable.
