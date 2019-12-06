<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="3.0"
 xmlns:ut="https://github.com/xslet/2020/xslutil"
 xmlns:xsx="dummy-ns" exclude-result-prefixes="xsx"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

 <xsl:strip-space elements="*"/>
 <xsl:namespace-alias result-prefix="xsl" stylesheet-prefix="xsx"/>

 <xsl:template match="/">
  <xsl:call-template name="merge">
   <xsl:with-param name="destfile" select="'unit.test.xsl'"/>
   <xsl:with-param name="srcdir" select="'../../src/xsl/lib'"/>
  </xsl:call-template>
 </xsl:template>

 <xsl:template name="merge">
  <xsl:param name="destfile"/>
  <xsl:param name="srcdir"/>

  <xsl:result-document href="{$destfile}">
   <xsx:stylesheet version="1.0">

    <xsl:merge>
     <xsl:merge-source for-each-source="uri-collection($srcdir)"
       select="xsl:stylesheet/xsl:import">
      <xsl:merge-key select="href"/>
     </xsl:merge-source>
     <xsl:merge-action>
      <xsl:copy-of select="current-merge-group()"/>
      <xsl:apply-templates select="current-merge-group()"
        mode="create-matchable-template"/>
     </xsl:merge-action>
    </xsl:merge>

    <xsl:merge>
     <xsl:merge-source for-each-source="uri-collection($srcdir)"
       select="xsl:stylesheet/xsl:param">
      <xsl:merge-key select="name"/>
     </xsl:merge-source>
     <xsl:merge-action>
      <xsl:copy-of select="current-merge-group()"/>
      <xsl:apply-templates select="current-merge-group()"
        mode="create-matchable-template"/>
     </xsl:merge-action>
    </xsl:merge>

    <xsl:merge>
     <xsl:merge-source for-each-source="uri-collection($srcdir)"
       select="xsl:stylesheet/xsl:template">
      <xsl:merge-key select="name|match"/>
      <xsl:merge-key select="mode"/>
     </xsl:merge-source>
     <xsl:merge-action>
      <xsl:copy-of select="current-merge-group()"/>
      <xsl:apply-templates select="current-merge-group()"
        mode="create-matchable-template"/>
     </xsl:merge-action>
    </xsl:merge>

    <xsx:template match="/unit-test">
     <html>
      <head>
       <meta charset="utf-8"/>
       <title><xsx:value-of select="@title"/></title>
      </head>
      <body>
       <h2><xsx:value-of select="@title"/></h2>
       <hr/>
       <xsx:apply-templates select="*"/>
      </body>
     </html>
    </xsx:template>

   </xsx:stylesheet>

  </xsl:result-document>
 </xsl:template>

 <xsl:template match="xsl:param" mode="create-matchable-template">
  <xsx:template match="assert-not-empty[@name='{@name}']">
  </xsx:template>
  <xsx:template match="assert-empty[@name='{@name}']">
  </xsx:template>
  <xsx:template match="assert-equal[@name='{@name}']">
  </xsx:template>
 </xsl:template>

 <xsl:template match="xsl:template" mode="create-matchable-template">
  <xsx:template match="assert-not-empty[@name='{@name}']">
   <xsx:variable name="result">
    <xsx:call-template name="{@name}">
     <xsl:for-each select="xsl:param">
      <xsx:with-param name="{@name}" select="{@name}"/>
     </xsl:for-each>
    </xsx:call-template>
   </xsx:variable>
   <div><code>
    <div>
     <h3><xsl:value-of select="@name"/></h3>
     <xsx:variable name="param">
      <xsl:for-each select="xsl:param">
       <xsl:text>,</xsl:text>
       <xsl:value-of select="@name"/>
       <xsl:text>='</xsl:text>
       <xsx:value-of select="{@name}"/>
       <xsl:text>'</xsl:text>
      </xsl:for-each>
     </xsx:variable>
     <xsx:value-of select="concat('(', substring($param, 2), ')')"/>
     <xsl:text> … </xsl:text>
     <xsx:choose>
      <xsx:when test="string-length($result) != 0">
       <span style="color:#0d0">PASS</span>
      </xsx:when>
      <xsx:otherwise>
       <span style="color:#d00">FAIL</span>
       <style>h2 { background-color: #f00 }</style>
      </xsx:otherwise>
     </xsx:choose>
    </div>
    <div style="padding-left: 1rem">
     <xsl:text>- Result[</xsl:text>
     <xsx:value-of select="$result"/>
     <xsl:text>]</xsl:text>
    </div>
   </code></div>
   <hr/>
  </xsx:template>

  <xsx:template match="assert-empty[@name='{@name}']">
   <xsx:variable name="result">
    <xsx:call-template name="{@name}">
     <xsl:for-each select="xsl:param">
      <xsx:with-param name="{@name}" select="{@name}"/>
     </xsl:for-each>
    </xsx:call-template>
   </xsx:variable>
   <div><code>
    <div>
     <h3><xsl:value-of select="@name"/></h3>
     <xsx:variable name="param">
      <xsl:for-each select="xsl:param">
       <xsl:text>,</xsl:text>
       <xsl:value-of select="@name"/>
       <xsl:text>='</xsl:text>
       <xsx:value-of select="{@name}"/>
       <xsl:text>'</xsl:text>
      </xsl:for-each>
     </xsx:variable>
     <xsx:value-of select="concat('(', substring($param, 2), ')')"/>
     <xsl:text> … </xsl:text>
     <xsx:choose>
      <xsx:when test="string-length($result) = 0">
       <span style="color:#0d0">PASS</span>
      </xsx:when>
      <xsx:otherwise>
       <span style="color:#d00">FAIL</span>
       <style>h2 { background-color: #f00 }</style>
      </xsx:otherwise>
     </xsx:choose>
    </div>
    <div style="padding-left: 1rem">
     <xsl:text>- Result[</xsl:text>
     <xsx:value-of select="$result"/>
     <xsl:text>]</xsl:text>
    </div>
   </code></div>
   <hr/>
  </xsx:template>

  <xsx:template match="assert-equal[@name='{@name}']">
   <xsx:variable name="result">
    <xsx:call-template name="{@name}">
     <xsl:for-each select="xsl:param">
      <xsx:with-param name="{@name}" select="{@name}"/>
     </xsl:for-each>
    </xsx:call-template>
   </xsx:variable>
   <div><code>
    <div>
     <h3><xsl:value-of select="@name"/></h3>
     <xsx:variable name="param">
      <xsl:for-each select="xsl:param">
       <xsl:text>,</xsl:text>
       <xsl:value-of select="@name"/>
       <xsl:text>='</xsl:text>
       <xsx:value-of select="{@name}"/>
       <xsl:text>'</xsl:text>
      </xsl:for-each>
     </xsx:variable>
     <xsx:value-of select="concat('(', substring($param, 2), ')')"/>
     <xsl:text> … </xsl:text>
     <xsx:choose>
      <xsx:when test="$result = expect">
       <span style="color:#0d0">PASS</span>
      </xsx:when>
      <xsx:otherwise>
       <span style="color:#d00">FAIL</span>
       <style>h2 { background-color: #f00 }</style>
      </xsx:otherwise>
     </xsx:choose>
    </div>
    <div style="padding-left: 1rem">
     <xsl:text>- Expect[</xsl:text>
     <xsx:value-of select="expect"/>
     <xsl:text>]</xsl:text>
    </div>
    <div style="padding-left: 1rem">
     <xsl:text>- Result[</xsl:text>
     <xsx:value-of select="$result"/>
     <xsl:text>]</xsl:text>
    </div>
   </code></div>
   <hr/>
  </xsx:template>
 </xsl:template>

</xsl:stylesheet>
