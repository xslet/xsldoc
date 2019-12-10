# [@xslet/xsldoc](https://github.com/xslet/xsldoc)

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

## License

Copyright &copy; 2019 Takayuki Sato

This program is free software under [MIT](https://opensource.org/licenses/MIT) License.
See the file LICENSE in this distribution for more details.
