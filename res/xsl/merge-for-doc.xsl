<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="3.0"
 xmlns:ut="https://github.com/xslet/2020/xslutil"
 xmlns:xsx="dummy-ns" exclude-result-prefixes="xsx"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

 <xsl:namespace-alias result-prefix="xsl" stylesheet-prefix="xsx" />
 <xsl:strip-space elements="*" />


 <xsl:param name="product">
  <xsl:for-each select="document('../../build.xml', /)/project">
   <xsl:value-of select="property[@name='product']/@value" />
  </xsl:for-each>
 </xsl:param>

 <xsl:param name="version">
  <xsl:for-each select="document('../../build.xml', /)/project">
   <xsl:value-of select="property[@name='version']/@value" />
  </xsl:for-each>
 </xsl:param>

 <xsl:param name="copyright">
  <xsl:for-each select="document('../../build.xml', /)/project">
   <xsl:value-of select="property[@name='copyright']/@value" />
  </xsl:for-each>
 </xsl:param>

 <xsl:param name="license">
  <xsl:for-each select="document('../../build.xml', /)/project">
   <xsl:value-of select="property[@name='license']/@value" />
  </xsl:for-each>
 </xsl:param>

 <xsl:param name="prodtype">
  <xsl:for-each select="document('../../build.xml', /)/project">
   <xsl:value-of select="property[@name='prodtype']/@value" />
  </xsl:for-each>
 </xsl:param>


 <xsl:template match="/">
  <xsl:call-template name="merge">
   <xsl:with-param name="destfile" select="concat('api/', substring-before($product, '.xsl'), '.xml')" />
   <xsl:with-param name="srcdir" select="'../../src/xsl'" />
   <xsl:with-param name="libdir" select="'../../src/xsl/lib'" />
   <xsl:with-param name="extdir" select="'../../src/xsl/ext'" />
  </xsl:call-template>
 </xsl:template>


 <xsl:template name="merge">
  <xsl:param name="destfile" />
  <xsl:param name="srcdir" />
  <xsl:param name="libdir" />
  <xsl:param name="extdir" />

  <xsl:result-document href="{$destfile}">
   <xsl:processing-instruction name="xml-stylesheet">
    <xsl:text>type="application/xml" href="xsldoc/xsldoc.xsl"</xsl:text>
   </xsl:processing-instruction>

   <xsl:comment><!-- The file status comment -->
    <xsl:text> </xsl:text>
    <xsl:value-of select="$product" />
    <xsl:text> </xsl:text>
    <xsl:value-of select="$version" />
    <xsl:text> </xsl:text>
    <xsl:value-of select="$copyright" />
    <xsl:text> </xsl:text>
    <xsl:value-of select="$license" />
    <xsl:text> </xsl:text>
   </xsl:comment>

   <xsl:comment><!-- The file summary comment -->
    <xsl:value-of select="concat('** ', $product, ' ver', $version, ' - API Document&#10;')" />
    <xsl:for-each select="collection(concat($srcdir, '?select=**.xsl'))">
     <xsl:value-of select="xsl:stylesheet/preceding-sibling::comment()[1]" />
    </xsl:for-each>
    <xsl:value-of select="'&#10;'" />
    <xsl:value-of select="concat('** ', $copyright, '&#10;')" />
    <xsl:value-of select="concat('** ', $license, '&#10;')" />
   </xsl:comment>

   <xsx:stylesheet version="1.0">
    <xsl:if test="$prodtype != 'application'">
     <xsl:merge><!-- Merge `xsl:import`s and these comments -->
      <xsl:merge-source for-each-source="uri-collection($srcdir)"
       select="xsl:stylesheet/xsl:import|xsl:stylesheet/comment()[following-sibling::*[1]/name() = 'xsl:import']">
       <xsl:merge-key select="href" />
      </xsl:merge-source>
      <xsl:merge-source for-each-source="uri-collection($libdir)"
       select="xsl:stylesheet/xsl:import|xsl:stylesheet/comment()[following-sibling::*[1]/name() = 'xsl:import']">
       <xsl:merge-key select="href" />
      </xsl:merge-source>
      <xsl:merge-source for-each-source="uri-collection($extdir)"
       select="xsl:stylesheet/xsl:import|xsl:stylesheet/comment()[following-sibling::*[1]/name() = 'xsl:import']">
       <xsl:merge-key select="href" />
      </xsl:merge-source>
      <xsl:merge-action>
       <xsl:copy-of select="current-merge-group()" />
      </xsl:merge-action>
     </xsl:merge>
    </xsl:if>

    <xsx:strip-space elements="*" />

    <xsl:merge><!-- Merge `xsl:param`s and these comments -->
     <xsl:merge-source for-each-source="uri-collection($srcdir)"
      select="xsl:stylesheet/xsl:param|xsl:stylesheet/comment()[following-sibling::*[1]/name() = 'xsl:param']">
      <xsl:merge-key select="name" />
     </xsl:merge-source>
     <xsl:merge-source for-each-source="uri-collection($libdir)"
      select="xsl:stylesheet/xsl:param|xsl:stylesheet/comment()[following-sibling::*[1]/name() = 'xsl:param']">
      <xsl:merge-key select="name" />
     </xsl:merge-source>
     <xsl:merge-source for-each-source="uri-collection($extdir)"
      select="xsl:stylesheet/xsl:param|xsl:stylesheet/comment()[following-sibling::*[1]/name() = 'xsl:param']">
      <xsl:merge-key select="name" />
     </xsl:merge-source>
     <xsl:merge-action>
      <xsl:copy-of select="current-merge-group()" />
     </xsl:merge-action>
    </xsl:merge>

    <xsl:merge><!-- Merge `xsl:template`s and these comments. -->
     <xsl:merge-source for-each-source="uri-collection($srcdir)"
      select="xsl:stylesheet/xsl:template|xsl:stylesheet/comment()[following-sibling::*[1]/name() = 'xsl:template']">
      <xsl:merge-key select="name|match" />
      <xsl:merge-key select="mode"/>
     </xsl:merge-source>
     <xsl:merge-source for-each-source="uri-collection($libdir)"
      select="xsl:stylesheet/xsl:template|xsl:stylesheet/comment()[following-sibling::*[1]/name() = 'xsl:template']">
      <xsl:merge-key select="name|match" />
      <xsl:merge-key select="mode"/>
     </xsl:merge-source>
     <xsl:merge-source for-each-source="uri-collection($extdir)"
      select="xsl:stylesheet/xsl:template|xsl:stylesheet/comment()[following-sibling::*[1]/name() = 'xsl:template']">
      <xsl:merge-key select="name|match" />
      <xsl:merge-key select="mode"/>
     </xsl:merge-source>
     <xsl:merge-action>
      <xsl:copy-of select="current-merge-group()" />
     </xsl:merge-action>
    </xsl:merge>
   </xsx:stylesheet>

  </xsl:result-document>
 </xsl:template>

</xsl:stylesheet>
