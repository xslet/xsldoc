<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
 xmlns:ut="https://github.com/xslet/2020/xslutil"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

 <!--** Gets first line of a design comment which is a preceding comment of design items. -->
 <xsl:template name="get_first_line_in_design_comment">
  <xsl:variable name="_prev_comment">
   <xsl:call-template name="ut:trim_start">
    <xsl:with-param name="string">
     <xsl:call-template name="_get_prev_comment"/>
    </xsl:with-param>
   </xsl:call-template>
  </xsl:variable>
  <xsl:if test="starts-with($_prev_comment, $DESIGN_COMMENT_PREFIX)">
   <xsl:variable name="_s0" select="substring($_prev_comment, $_prefix_len + 1)"/>
   <xsl:variable name="_s1">
    <xsl:call-template name="ut:trim_start">
     <xsl:with-param name="string" select="$_s0"/>
    </xsl:call-template>
   </xsl:variable>
   <xsl:variable name="_s2">
    <xsl:call-template name="ut:replace">
     <xsl:with-param name="string" select="$_s1"/>
     <xsl:with-param name="target" select="'&#13;&#10;'"/>
     <xsl:with-param name="replacement" select="$_eol"/>
    </xsl:call-template>
   </xsl:variable>
   <xsl:variable name="_s3">
    <xsl:call-template name="ut:replace">
     <xsl:with-param name="string" select="$_s2"/>
     <xsl:with-param name="target" select="'&#13;'"/>
     <xsl:with-param name="replacement" select="$_eol"/>
    </xsl:call-template>
   </xsl:variable>
   <xsl:variable name="_s4">
    <xsl:value-of select="$_s3"/>
    <xsl:if test="substring($_s3, string-length($_s3)) != $_eol">
     <xsl:value-of select="$_eol"/>
    </xsl:if>
   </xsl:variable>
   <xsl:value-of select="normalize-space(substring-before($_s4, $_eol))"/>
  </xsl:if>
 </xsl:template>


</xsl:stylesheet>
