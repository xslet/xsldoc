<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="3.0"
 xmlns:ut="https://github.com/xslet/2020/xslutil"
 xmlns:xsx="dummy-ns" exclude-result-prefixes="xsx"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

 <xsl:namespace-alias result-prefix="xsl" stylesheet-prefix="xsx" />
 <xsl:strip-space elements="*" />


 <xsl:param name="prodtype">
  <xsl:for-each select="document('../../build.xml', /)/project">
   <xsl:value-of select="property[@name='prodtype']/@value" />
  </xsl:for-each>
 </xsl:param>


 <xsl:template match="/">
  <xsl:call-template name="merge">
   <xsl:with-param name="destfile" select="'unit-test.xsl'" />
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
   <xsx:stylesheet version="1.0">
    <xsl:if test="$prodtype != 'application'">
     <xsl:merge>
      <xsl:merge-source for-each-source="uri-collection($srcdir)"
        select="xsl:stylesheet/xsl:import">
       <xsl:merge-key select="href" />
      </xsl:merge-source>
      <xsl:merge-source for-each-source="uri-collection($libdir)"
        select="xsl:stylesheet/xsl:import">
       <xsl:merge-key select="href" />
      </xsl:merge-source>
      <xsl:merge-source for-each-source="uri-collection($extdir)"
        select="xsl:stylesheet/xsl:import">
       <xsl:merge-key select="href" />
      </xsl:merge-source>
      <xsl:merge-action>
       <xsl:copy-of select="current-merge-group()" />
      </xsl:merge-action>
     </xsl:merge>
    </xsl:if>

    <xsx:strip-space elements="*" />

    <xsl:merge>
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

    <xsl:merge>
     <xsl:merge-source for-each-source="uri-collection($srcdir)"
       select="xsl:stylesheet/xsl:template">
      <xsl:merge-key select="name|match" />
      <xsl:merge-key select="mode" />
     </xsl:merge-source>
     <xsl:merge-source for-each-source="uri-collection($libdir)"
       select="xsl:stylesheet/xsl:template">
      <xsl:merge-key select="name|match" />
      <xsl:merge-key select="mode" />
     </xsl:merge-source>
     <xsl:merge-source for-each-source="uri-collection($extdir)"
       select="xsl:stylesheet/xsl:template">
      <xsl:merge-key select="name|match" />
      <xsl:merge-key select="mode" />
     </xsl:merge-source>
     <xsl:merge-action>
      <xsl:for-each select="current-merge-group()">
       <xsl:choose>
        <xsl:when test="boolean(@match) and not(starts-with(@match, '/'))">
         <xsx:template match="{@match}">
          <xsl:if test="boolean(@mode)">
           <xsl:attribute name="mode">
            <xsl:value-of select="@mode" />
           </xsl:attribute>
          </xsl:if>
          <xsl:apply-templates select="*|text()" />
         </xsx:template>
        </xsl:when>
        <xsl:when test="boolean(@name)">
         <xsl:variable name="_name" select="@name" />
         <xsx:template name="{@name}">
          <xsl:if test="boolean(@mode)">
           <xsl:attribute name="mode">
            <xsl:value-of select="@mode" />
           </xsl:attribute>
          </xsl:if>
          <xsl:apply-templates select="*|text()" />
         </xsx:template>
         <xsx:template match="compute[@name='{$_name}']">
          <xsx:call-template name="{$_name}">
           <xsl:for-each select="xsl:param">
            <xsl:variable name="_param" select="@name" />
            <xsx:with-param name="{$_param}">
             <xsx:value-of select="param[@name='{$_param}']" />
            </xsx:with-param>
           </xsl:for-each>
          </xsx:call-template>
         </xsx:template>
        </xsl:when>
       </xsl:choose>
      </xsl:for-each>
     </xsl:merge-action>
    </xsl:merge>

    <xsx:template match="/describe">
     <xsx:variable name="_data_url" select="@data-src" />
     <html>
     <head>
      <meta charset="utf-8" />
      <title><xsx:value-of select="@title" /></title>
      <link rel="stylesheet" href="./unit-test.css" />
      <script src="./unit-test.js"></script>
     </head>
     <body>
      <div id="passFailBar"/>
      <h1><xsx:value-of select="@title" /></h1>
      <xsx:apply-templates select="describe|it">
       <xsx:with-param name="data_url" select="$_data_url" />
      </xsx:apply-templates>
     </body>
     </html>
    </xsx:template>

    <xsx:template match="describe">
     <xsx:param name="data_url" />
     <xsx:variable name="_data_url">
      <xsx:choose>
       <xsx:when test="boolean(@data-src)">
        <xsx:value-of select="@data-src" />
       </xsx:when>
       <xsx:otherwise>
        <xsx:value-of select="$data_url" />
       </xsx:otherwise>
      </xsx:choose>
     </xsx:variable>
     <section class="describe">
      <div class="title">
       <xsx:value-of select="@title" />
      </div>
      <xsx:apply-templates select="describe|it">
       <xsx:with-param name="data_url" select="$_data_url" />
      </xsx:apply-templates>
     </section>
    </xsx:template>

    <xsx:template match="it">
     <xsx:param name="data_url" />
     <xsx:variable name="_data_url">
      <xsx:choose>
       <xsx:when test="boolean(@data-src)">
        <xsx:value-of select="@data-src" />
       </xsx:when>
       <xsx:otherwise>
        <xsx:value-of select="$data_url" />
       </xsx:otherwise>
      </xsx:choose>
     </xsx:variable>
     <section>
      <xsx:choose>
       <xsx:when test="@skip='true'">
        <xsx:attribute name="class">it skip</xsx:attribute>
        <div class="title">
         <xsx:value-of select="@title" />
        </div>
       </xsx:when>
       <xsx:otherwise>
        <xsx:variable name="_computed">
         <xsx:apply-templates select="compute">
          <xsx:with-param name="data_url" select="$_data_url" />
         </xsx:apply-templates>
        </xsx:variable>
        <xsx:variable name="_expected">
         <xsx:apply-templates select="expect" />
        </xsx:variable>
        <xsx:choose>
         <xsx:when test="$_computed = $_expected">
          <xsx:attribute name="class">it pass</xsx:attribute>
          <xsx:call-template name="it-content">
           <xsx:with-param name="expected" select="$_expected" />
           <xsx:with-param name="computed" select="$_computed" />
          </xsx:call-template>
         </xsx:when>
         <xsx:otherwise>
          <xsx:attribute name="class">it fail</xsx:attribute>
          <xsx:call-template name="it-content">
           <xsx:with-param name="expected" select="$_expected" />
           <xsx:with-param name="computed" select="$_computed" />
          </xsx:call-template>
         </xsx:otherwise>
        </xsx:choose>
       </xsx:otherwise>
      </xsx:choose>
     </section>
    </xsx:template>

    <xsx:template name="it-content">
     <xsx:param name="computed"/>
     <xsx:param name="expected"/>
     <div class="title">
      <xsx:value-of select="@title" />
      <a class="to-show" href="javascript:void(0)"
       onclick="showHideComparison(this);"></a>
     </div>
     <div class="comparison hide">
      <div class="legends">
       <span class="expected">:Expected, </span>
       <span class="computed">:Computed</span>
      </div>
      <div class="code expected"><xsx:value-of select="$expected" /></div>
      <div class="code computed"><xsx:value-of select="$computed" /></div>
     </div>
    </xsx:template>
   </xsx:stylesheet>
  </xsl:result-document>
 </xsl:template>


 <xsl:template match="*|text()|@*">
  <xsl:copy>
   <xsl:apply-templates select="*|text()|@*" />
  </xsl:copy>
 </xsl:template>


</xsl:stylesheet>
