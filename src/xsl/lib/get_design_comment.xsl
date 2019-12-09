<?xml version="1.0" encoding="utf-8"?>
  
<xsl:stylesheet version="1.0"
 xmlns:ut="https://github.com/xslet/2020/xslutil"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

 <!--** The prefix of a design comment. (='**') -->
 <xsl:param name="DESIGN_COMMENT_PREFIX">**</xsl:param>

 <xsl:param name="_eol" select="'&#10;'"/>

 <!--** Gets a design comment which is a preceding comment of design items. -->
 <xsl:template name="get_design_comment">
  <!--** A flag to be set 'true' if printing only first iine. -->
  <xsl:param name="only_first_line"/>
  <xsl:variable name="_prev_comment">
   <xsl:call-template name="ut:trim_start">
    <xsl:with-param name="string">
     <xsl:call-template name="_get_prev_comment"/>
    </xsl:with-param>
   </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="_prefix_len" select="string-length($DESIGN_COMMENT_PREFIX)"/>
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
     <xsl:with-param name="target" select="'&#13;'"/>
     <xsl:with-param name="replacement" select="$_eol"/>
    </xsl:call-template>
    <xsl:value-of select="$_eol"/>
   </xsl:variable>
   <xsl:value-of select="normalize-space(substring-before($_s2, $_eol))"/>
   <xsl:choose>
    <xsl:when test="$only_first_line = $ut:true"/>
    <xsl:otherwise>
     <xsl:variable name="_next" select="substring-after($_s2, $_eol)"/>
     <xsl:call-template name="_get_design_comment_rcr">
      <xsl:with-param name="design_comment" select="$_next"/>
      <xsl:with-param name="line_delimiter" select="$_eol"/>
     </xsl:call-template>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:if>
 </xsl:template>

 <xsl:template name="_get_design_comment_rcr">
  <xsl:param name="design_comment"/>
  <xsl:param name="line_delimiter"/>
  <xsl:variable name="_line" select="normalize-space(substring-before($design_comment, $_eol))"/>
  <xsl:variable name="_next" select="substring-after($design_comment, $_eol)"/>
  <xsl:variable name="_prefix_len" select="string-length($DESIGN_COMMENT_PREFIX)"/>
  <xsl:variable name="_line1" select="normalize-space($_line)"/>
  <xsl:variable name="_line2">
   <xsl:choose>
    <xsl:when test="starts-with($_line, $DESIGN_COMMENT_PREFIX)">
     <xsl:value-of select="normalize-space(substring($_line1, $_prefix_len + 1))"/>
    </xsl:when>
    <xsl:otherwise>
     <xsl:value-of select="$_line1"/>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:variable>
  <xsl:choose>
   <xsl:when test="string-length($_line2) != 0">
    <xsl:choose>
     <xsl:when test="string-length($line_delimiter) = 1"><br/></xsl:when>
     <xsl:when test="string-length($line_delimiter) &gt;= 2"><br/><br/></xsl:when>
    </xsl:choose>
    <xsl:value-of select="$_line2"/>
    <xsl:if test="string-length($_next) != 0">
     <xsl:call-template name="_get_design_comment_rcr">
      <xsl:with-param name="design_comment" select="$_next"/>
      <xsl:with-param name="line_delimiter" select="'n'"/>
     </xsl:call-template>
    </xsl:if>
   </xsl:when>
   <xsl:otherwise>
    <xsl:if test="string-length($_next) != 0">
     <xsl:call-template name="_get_design_comment_rcr">
      <xsl:with-param name="design_comment" select="$_next"/>
      <xsl:with-param name="line_delimiter" select="concat($line_delimiter, 'n')"/>
     </xsl:call-template>
    </xsl:if>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template name="_get_prev_comment">
  <xsl:variable name="_prev_comment_id" select="generate-id(preceding-sibling::comment()[1])"/>
  <xsl:variable name="_prev_node_id" select="generate-id(preceding-sibling::node()[1])"/>
  <xsl:choose>
   <xsl:when test="$_prev_comment_id = $_prev_node_id">
    <xsl:value-of select="preceding-sibling::comment()[1]"/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:variable name="_prev_2nd_node_id"
     select="generate-id(preceding-sibling::node()[2])"/>
    <xsl:if test="$_prev_comment_id = $_prev_2nd_node_id">
     <xsl:variable name="_prev_text_id" select="generate-id(preceding-sibling::text()[1])"/>
     <xsl:if test="$_prev_text_id = $_prev_node_id">
      <xsl:if test="string-length(normalize-space(preceding-sibling::text()[1])) = 0">
       <xsl:value-of select="preceding-sibling::comment()[1]"/>
      </xsl:if>
     </xsl:if>
    </xsl:if>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

</xsl:stylesheet>
