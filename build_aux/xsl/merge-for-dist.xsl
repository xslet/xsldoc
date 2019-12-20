<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="3.0"
 xmlns:ut="https://github.com/xslet/2020/xslutil"
 xmlns:xsx="dummy-ns" exclude-result-prefixes="xsx"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

 <xsl:param name="product">
  <xsl:for-each select="document('../../build.xml', /)/project">
   <xsl:value-of select="property[@name='product']/@value"/>
  </xsl:for-each>
 </xsl:param>
 <xsl:param name="version">
  <xsl:for-each select="document('../../build.xml', /)/project">
   <xsl:value-of select="property[@name='version']/@value"/>
  </xsl:for-each>
 </xsl:param>
 <xsl:param name="copyright">
  <xsl:for-each select="document('../../build.xml', /)/project">
   <xsl:value-of select="property[@name='copyright']/@value"/>
  </xsl:for-each>
 </xsl:param>
 <xsl:param name="license">
  <xsl:for-each select="document('../../build.xml', /)/project">
   <xsl:value-of select="property[@name='license']/@value"/>
  </xsl:for-each>
 </xsl:param>

 <xsl:strip-space elements="*"/>
 <xsl:namespace-alias result-prefix="xsl" stylesheet-prefix="xsx"/>

 <xsl:template match="/">
  <xsl:call-template name="merge">
   <xsl:with-param name="destfile" select="'xsldoc.xsl'"/>
   <xsl:with-param name="srcdir" select="'../../src/xsl'"/>
   <xsl:with-param name="libdir" select="'../../src/xsl/lib'"/>
   <xsl:with-param name="extdir" select="'../../src/xsl/ext'"/>
  </xsl:call-template>
 </xsl:template>

 <xsl:template name="merge">
  <xsl:param name="destfile"/>
  <xsl:param name="srcdir"/>
  <xsl:param name="libdir"/>
  <xsl:param name="extdir"/>

  <xsl:result-document href="{$destfile}">

   <xsl:comment>
    <xsl:text> </xsl:text>
    <xsl:value-of select="$product"/>
    <xsl:text> v</xsl:text>
    <xsl:value-of select="$version"/>
    <xsl:text>. </xsl:text>
    <xsl:value-of select="$copyright"/>
    <xsl:text>. </xsl:text>
    <xsl:value-of select="$license"/>
    <xsl:text> </xsl:text>
   </xsl:comment>

   <xsx:stylesheet version="1.0">

    <xsl:merge>
     <xsl:merge-source for-each-source="uri-collection($srcdir)"
       select="xsl:stylesheet/xsl:import">
      <xsl:merge-key select="href"/>
     </xsl:merge-source>
     <xsl:merge-source for-each-source="uri-collection($libdir)"
       select="xsl:stylesheet/xsl:import">
      <xsl:merge-key select="href"/>
     </xsl:merge-source>
     <xsl:merge-source for-each-source="uri-collection($extdir)"
       select="xsl:stylesheet/xsl:import">
      <xsl:merge-key select="href"/>
     </xsl:merge-source>
     <xsl:merge-action>
      <xsl:copy-of select="current-merge-group()"/>
     </xsl:merge-action>
    </xsl:merge>

    <xsl:merge>
     <xsl:merge-source for-each-source="uri-collection($srcdir)"
       select="xsl:stylesheet/xsl:param">
      <xsl:merge-key select="name"/>
     </xsl:merge-source>
     <xsl:merge-source for-each-source="uri-collection($libdir)"
       select="xsl:stylesheet/xsl:param">
      <xsl:merge-key select="name"/>
     </xsl:merge-source>
     <xsl:merge-source for-each-source="uri-collection($extdir)"
       select="xsl:stylesheet/xsl:param">
      <xsl:merge-key select="name"/>
     </xsl:merge-source>
     <xsl:merge-action>
      <xsl:copy-of select="current-merge-group()"/>
     </xsl:merge-action>
    </xsl:merge>

    <xsl:merge>
     <xsl:merge-source for-each-source="uri-collection($srcdir)"
       select="xsl:stylesheet/xsl:template">
      <xsl:merge-key select="name|match"/>
      <xsl:merge-key select="mode"/>
     </xsl:merge-source>
     <xsl:merge-source for-each-source="uri-collection($libdir)"
       select="xsl:stylesheet/xsl:template">
      <xsl:merge-key select="name|match"/>
      <xsl:merge-key select="mode"/>
     </xsl:merge-source>
     <xsl:merge-source for-each-source="uri-collection($extdir)"
       select="xsl:stylesheet/xsl:template">
      <xsl:merge-key select="name|match"/>
      <xsl:merge-key select="mode"/>
     </xsl:merge-source>
     <xsl:merge-action>
      <xsl:copy-of select="current-merge-group()"/>
     </xsl:merge-action>
    </xsl:merge>

   </xsx:stylesheet>

  </xsl:result-document>
 </xsl:template>

</xsl:stylesheet>
