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
   <xsl:with-param name="destfile" select="$product" />
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

   <xsx:stylesheet version="1.0">
    <xsl:if test="$prodtype != 'application'">
     <xsl:merge><!-- Merge `xsl:import`s -->
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
    </xsl:if>

    <xsx:strip-space elements="*" />

    <xsl:merge><!-- Merge `xsl:param`s -->
     <xsl:merge-source for-each-source="uri-collection($srcdir)"
      select="xsl:stylesheet/xsl:param">
      <xsl:merge-key select="name" />
     </xsl:merge-source>
     <xsl:merge-source for-each-source="uri-collection($libdir)"
      select="xsl:stylesheet/xsl:param">
      <xsl:merge-key select="name" />
     </xsl:merge-source>
     <xsl:merge-source for-each-source="uri-collection($extdir)"
      select="xsl:stylesheet/xsl:param">
      <xsl:merge-key select="name" />
     </xsl:merge-source>
     <xsl:merge-action>
      <xsl:copy-of select="current-merge-group()" />
     </xsl:merge-action>
    </xsl:merge>

    <xsl:merge><!-- Merge `xsl:template`s -->
     <xsl:merge-source for-each-source="uri-collection($srcdir)"
      select="xsl:stylesheet/xsl:template">
      <xsl:merge-key select="name|match" />
      <xsl:merge-key select="mode"/>
     </xsl:merge-source>
     <xsl:merge-source for-each-source="uri-collection($libdir)"
      select="xsl:stylesheet/xsl:template">
      <xsl:merge-key select="name|match" />
      <xsl:merge-key select="mode"/>
     </xsl:merge-source>
     <xsl:merge-source for-each-source="uri-collection($extdir)"
      select="xsl:stylesheet/xsl:template">
      <xsl:merge-key select="name|match" />
      <xsl:merge-key select="mode"/>
     </xsl:merge-source>
     <xsl:merge-action>
      <xsl:for-each select="current-merge-group()">
       <xsl:choose>
        <xsl:when test="boolean(@name)">
         <xsx:template name="{@name}">
          <xsl:if test="boolean(@mode)">
           <xsl:attribute name="mode">
            <xsl:value-of select="@mode"/>
           </xsl:attribute>
          </xsl:if>
          <xsl:apply-templates select="*|text()" />
         </xsx:template>
        </xsl:when>
        <xsl:when test="boolean(@match)">
         <xsx:template match="{@match}">
          <xsl:if test="boolean(@mode)">
           <xsl:attribute name="mode">
            <xsl:value-of select="@mode"/>
           </xsl:attribute>
          </xsl:if>
          <xsl:apply-templates select="*|text()" />
         </xsx:template>
        </xsl:when>
       </xsl:choose>
      </xsl:for-each>
     </xsl:merge-action>
    </xsl:merge>
   </xsx:stylesheet>

  </xsl:result-document>
 </xsl:template>


 <xsl:template match="*|text()|@*">
  <xsl:copy>
   <xsl:apply-templates select="*|text()|@*" />
  </xsl:copy>
 </xsl:template>

</xsl:stylesheet>
