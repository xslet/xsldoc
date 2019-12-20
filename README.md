# [@xslet/xsldoc](https://github.com/xslet/xsldoc) ver.0.1.0

A tool to print an API document of a XSL file on Web browsers.

This program is written in XSLT 1.0.

## API

The API document of this program is [here](https://xslet.github.io/xsldoc/api/xsldoc.xml).

## Usage

Writes the path of `xsldoc.xsl` in processing instruction in a XML file, as follows.

```
<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="application/xml" href="path/to/xsldoc.xsl"?>

<xsl:stylesheet version="1.0" xmlns:xsl="xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  ...
</xsl:stylesheet>
```

### Design comment

The format of XML comment is like: `<!-- This is a comment. -->`.

xsldoc deals with a comment which starts with `**` like: `<!--** This is a design comment. -->` as a design comment, and output them as a summary for each design item in an API document.

A design comment can be written in multiple lines like:

```
<--**
  This is
  a multiple
  comment.
-->
```

Or 

```
<!--
** This is 
** a multiple
** comment, too.
-->
```

### File Title & Summary 

xsldoc deals with a comment which precedes a `<xsl:stylesheet>` element immediately as a file summary, and deals with the first line in a file summary as a file title.

```
<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="application/xml" href="xsldoc.xsl"?>
<!--**     
  This is dealed with the file title.
  
  This is dealed with
  a file summary.
--->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  ...
</xsl:stylesheet>
```

## License

Copyright &copy; 2019 Takayuki Sato

This program is free software under [MIT](https://opensource.org/licenses/MIT) License.
See the file LICENSE in this distribution for more details.
