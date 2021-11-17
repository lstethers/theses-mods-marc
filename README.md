# theses-mods-marc

XSLT to convert Islandora theses MODS records to Marc in order to create Alma print thesis records. It can be used in MarcEdit Tools or in any XSLT interpreter such as XML Notepad.

It is initially based upon the default MODS to Marc21 XSLT converter in MarcEdit, but has been extensively modified by Wesleyan to fit our own data.

See explanations of Wesleyan's field mappings here:
https://docs.google.com/spreadsheets/d/1kEcpSG2uheLLJnO8OxDHJkAh5x-3pZXUvuvqgNgo0Yk/edit#gid=0

This XSLT file is used in the following workflow:
- export MODS XML files for student theses from Islandora
- merge all XML files into a single XML file
- Use MarcEdit's Tools to transform the MODS XML file to MARC XML
