<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="3.0"
 xmlns:ut="https://github.com/xslet/2020/xslutil"
 xmlns:xsx="dummy-ns" exclude-result-prefixes="xsx"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

 <xsl:strip-space elements="*"/>
 <xsl:namespace-alias result-prefix="xsl" stylesheet-prefix="xsx"/>

 <xsl:template match="/">
  <xsl:call-template name="merge">
   <xsl:with-param name="destfile" select="'api/xsldoc.xml'"/>
   <xsl:with-param name="srcdir" select="'../../src/xsl'"/>
   <xsl:with-param name="libdir" select="'../../src/xsl/lib'"/>
  </xsl:call-template>
 </xsl:template>

 <xsl:template name="merge">
  <xsl:param name="destfile"/>
  <xsl:param name="srcdir"/>
  <xsl:param name="libdir"/>

  <xsl:result-document href="{$destfile}">
   <xsl:processing-instruction name="xml-stylesheet">type="application/xml" href="xsldoc/xsldoc.xsl"</xsl:processing-instruction>

   <xsl:for-each select="collection(concat($srcdir, '?select=*.xsl'))">
    <xsl:comment><xsl:value-of select="xsl:stylesheet/preceding-sibling::comment()[1]"/></xsl:comment>
   </xsl:for-each>

   <xsx:stylesheet version="1.0">

    <xsl:merge>
     <xsl:merge-source for-each-source="uri-collection($srcdir)"
       select="xsl:stylesheet/xsl:import|xsl:stylesheet/comment()[following-sibling::*[1]/name() = 'xsl:import']">
      <xsl:merge-key select="href"/>
     </xsl:merge-source>
     <xsl:merge-source for-each-source="uri-collection($libdir)"
       select="xsl:stylesheet/xsl:import|xsl:stylesheet/comment()[following-sibling::*[1]/name() = 'xsl:import']">
      <xsl:merge-key select="href"/>
     </xsl:merge-source>
     <xsl:merge-action>
      <xsl:copy-of select="current-merge-group()"/>
     </xsl:merge-action>
    </xsl:merge>

    <xsl:merge>
     <xsl:merge-source for-each-source="uri-collection($srcdir)"
       select="xsl:stylesheet/xsl:param|xsl:stylesheet/comment()[following-sibling::*[1]/name() = 'xsl:param']">
      <xsl:merge-key select="name"/>
     </xsl:merge-source>
     <xsl:merge-source for-each-source="uri-collection($libdir)"
       select="xsl:stylesheet/xsl:param|xsl:stylesheet/comment()[following-sibling::*[1]/name() = 'xsl:param']">
      <xsl:merge-key select="name"/>
     </xsl:merge-source>
     <xsl:merge-action>
      <xsl:copy-of select="current-merge-group()"/>
     </xsl:merge-action>
    </xsl:merge>

    <xsl:merge>
     <xsl:merge-source for-each-source="uri-collection($srcdir)"
       select="xsl:stylesheet/xsl:template|xsl:stylesheet/comment()[following-sibling::*[1]/name() = 'xsl:template']">
      <xsl:merge-key select="name|match"/>
      <xsl:merge-key select="mode"/>
     </xsl:merge-source>
     <xsl:merge-source for-each-source="uri-collection($libdir)"
       select="xsl:stylesheet/xsl:template|xsl:stylesheet/comment()[following-sibling::*[1]/name() = 'xsl:template']">
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
