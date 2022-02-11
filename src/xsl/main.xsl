<?xml version="1.0" encoding="utf-8"?>                                          

<!--**
 xsldoc is a XSLT applet to print an API document of a XSL file on Web browsers. 

 This applet prints the lists of design items of XSLT: namespaces, import files, including files, parameters, match templates, and named templates. However, this applet regards design items of which the local-name starts with '_' as private items and doesn't print them.

 This applet also prints design comments, which are comments that immediately precede these design items and start with `**`.

 This program is written in XSLT 1.0.
-->
<xsl:stylesheet version="1.0"
 xmlns:ut="https://github.com/xslet/2020/xslutil"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

 <xsl:strip-space elements="*"/>

 <xsl:param name="_xsl_url">
  <xsl:call-template name="ut:get_xsl_url"/>
 </xsl:param>

 <xsl:param name="_xsl_dir">
  <xsl:call-template name="ut:get_dir_from_url">
   <xsl:with-param name="url" select="$_xsl_url"/>
  </xsl:call-template>
 </xsl:param>


 <!--**
  The top level element of a XML stylesheet.
 -->
 <xsl:template match="/xsl:stylesheet">
  <html>
   <head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>
     <xsl:call-template name="get_first_line_in_design_comment"/>
    </title>
    <script src="{concat($_xsl_dir, '/xsldoc.js')}"></script>
    <link rel="stylesheet" href="{concat($_xsl_dir, '/xsldoc.css')}"/>
   </head>
   <body>
    <header>
     <xsl:call-template name="_print_system_props"/>
    </header>
    <main>
     <xsl:call-template name="_print_page_comment"/>
     <xsl:call-template name="_print_namespaces"/>
     <xsl:call-template name="_print_importings"/>
     <xsl:call-template name="_print_includings"/>
     <xsl:call-template name="_print_parameters"/>
     <xsl:call-template name="_print_match_templates"/>
     <xsl:call-template name="_print_named_templates"/>
    </main>
    <footer>
     <xsl:call-template name="_print_system_props"/>
    </footer>
   </body>
  </html>
 </xsl:template>


 <!--**
  Prints current XSLT processor informations with XPath system-property() function.
 -->
 <xsl:template name="_print_system_props">
  <div class="system-props">
   <div class="system-props-title">Current XSLT Processor</div>
   <div class="system-props-item">
    <span class="system-props-item-name">xsl:version</span>
    <span class="system-props-item-value">
     <xsl:value-of select="system-property('xsl:version')"/>
    </span>
   </div>
   <div class="system-props-item">
    <span class="system-props-item-name">xsl:vendor</span>
    <span class="system-props-item-value">
     <xsl:value-of select="system-property('xsl:vendor')"/>
    </span>
   </div>
   <div class="system-props-item">
    <span class="system-props-item-name">xsl:vendor-url</span>
    <span class="system-props-item-value">
     <xsl:value-of select="system-property('xsl:vendor-url')"/>
    </span>
   </div>
  </div>
 </xsl:template>


 <!--**
  Prints the preceding comment of xsl:stylesheet element as the page title and description.
 -->
 <xsl:template name="_print_page_comment">
  <div class="page-description">
   <xsl:call-template name="get_design_comment"/>
  </div>
 </xsl:template>


 <!--**
  Prints namepaces.
  Firefox does not always print them because Firefox does not support XPath's namespace axis  (namespace::*).
 -->
 <xsl:template name="_print_namespaces">
  <xsl:if test="boolean(namespace::*)">
   <section class="namespace-section">
    <h2>Namespaces</h2>
    <div class="section-body namespace-list">
     <xsl:for-each select="namespace::*">
      <div class="namespace-item">
       <span class="namespace-prefix">
        <span class="xmlns">xmlns:</span>
        <xsl:value-of select="name()"/>
       </span>
       <xsl:text>="</xsl:text>
       <span class="namespace-url">
        <xsl:value-of select="."/>
       </span>
       <xsl:text>"</xsl:text>
      </div>
     </xsl:for-each>
    </div>
   </section>
  </xsl:if>
 </xsl:template>


 <!--**
  Prints import files with their design comments.
 -->
 <xsl:template name="_print_importings">
  <xsl:if test="boolean(xsl:import)">
   <section class="importing-section">
    <h2>Imports</h2>
    <div class="section-body importing-list">
     <xsl:for-each select="xsl:import">
      <div class="importing-item">
       <div class="importing-file">
        <a href="{concat($_xsl_dir, '/', @href)}">
         <xsl:value-of select="@href"/>
        </a>
       </div>
       <div class="importing-description">
        <xsl:variable name="_description">
         <xsl:call-template name="get_design_comment"/>
        </xsl:variable>
        <xsl:choose>
         <xsl:when test="string-length($_description) != 0">
          <xsl:value-of select="$_description"/>
         </xsl:when>
         <xsl:otherwise>
          <xsl:for-each select="document(@href, /)/xsl:stylesheet">
           <xsl:call-template name="get_design_comment"/>
          </xsl:for-each>
         </xsl:otherwise>
        </xsl:choose>
       </div>
      </div>
     </xsl:for-each>
    </div>
   </section>
  </xsl:if>
 </xsl:template>


 <!--**
  Prints include files with their design comments.
 -->
 <xsl:template name="_print_includings">
  <xsl:if test="boolean(//xsl:include)">
   <section class="including-section">
    <h2>Includes</h2>
    <div class="section-body including-list">
     <xsl:for-each select="//xsl:include">
      <div class="including-item">
       <div class="including-file">
        <a href="{concat($_xsl_dir, '/', @href)}">
         <xsl:value-of select="@href"/>
        </a>
       </div>
       <div class="including-description">
        <xsl:variable name="_description">
         <xsl:call-template name="get_design_comment"/>
        </xsl:variable>
        <xsl:choose>
         <xsl:when test="string-length($_description) != 0">
          <xsl:value-of select="$_description"/>
         </xsl:when>
         <xsl:otherwise>
          <xsl:for-each select="document(@href, /)/xsl:stylesheet">
           <xsl:call-template name="get_design_comment"/>
          </xsl:for-each>
         </xsl:otherwise>
        </xsl:choose>
       </div>
      </div>
     </xsl:for-each>
    </div>
   </section>
  </xsl:if>
 </xsl:template>


 <!--**
  Prints parameters with their design comments.
 -->
 <xsl:template name="_print_parameters">
  <xsl:if test="boolean(xsl:param[not(starts-with(@name, '_')) and not(contains(@name, ':_'))])">
   <section class="parameter-section">
    <h2>Parameters</h2>
    <div class="section-body parameter-list">
     <xsl:for-each select="xsl:param">
      <xsl:choose>
       <xsl:when test="starts-with(@name, '_')"/>
       <xsl:when test="starts-with(substring-after(@name, ':'), '_')"/>
       <xsl:otherwise>
        <div class="parameter-item">
         <div class="parameter-name">
          <xsl:value-of select="@name"/>
         </div>
         <div class="parameter-description">
          <xsl:call-template name="get_design_comment"/>
         </div>
        </div>
       </xsl:otherwise>
      </xsl:choose>
     </xsl:for-each>
    </div>
   </section>
  </xsl:if>
 </xsl:template>


 <!--**
  Prints match templates with their design comments.
 -->
 <xsl:template name="_print_match_templates">
  <xsl:if test="boolean(xsl:template/@match)">
   <section class="match-template-section">
    <h2>Match templates</h2>
    <div class="section-body match-template-list">
     <xsl:for-each select="xsl:template[boolean(@match)]">
      <xsl:choose>
       <xsl:when test="starts-with(@name, '_')"/>
       <xsl:when test="starts-with(substring-after(@name, ':'), '_')"/>
       <xsl:otherwise>
        <div class="match-template-item">
         <div class="match-template-name">
          <xsl:value-of select="@match"/>
         </div>
         <div class="match-template-description">
          <xsl:call-template name="get_design_comment"/>
         </div>
         <xsl:if test="boolean(xsl:param)">
          <div class="match-template-param-list">
           <div class="match-template-param-title">Parameters</div>
           <xsl:for-each select="xsl:param">
            <div class="match-template-param-item">
             <span class="match-template-param-name">
              <xsl:value-of select="@name"/>
             </span>
             <span class="match-template-param-description">
              <xsl:call-template name="get_first_line_in_design_comment"/>
             </span>
            </div>
           </xsl:for-each>
          </div>
         </xsl:if>
        </div>
       </xsl:otherwise>
      </xsl:choose>
     </xsl:for-each>
    </div>
   </section>
  </xsl:if>
 </xsl:template>


 <!--**
  Prints named templates with their design comments.
 -->
 <xsl:template name="_print_named_templates">
  <xsl:if test="boolean(xsl:template/@name[not(starts-with(., '_')) and not(contains(., ':_'))])">
   <section class="named-template-section">
    <h2>Named templates</h2>
    <div class="section-body named-template-list">
     <xsl:for-each select="xsl:template[boolean(@name)]">
      <xsl:choose>
       <xsl:when test="starts-with(@name, '_')"/>
       <xsl:when test="starts-with(substring-after(@name, ':'), '_')"/>
       <xsl:otherwise>
        <div class="named-template-item">
         <div class="named-template-name">
          <xsl:value-of select="@name"/>
         </div>
         <div class="named-template-description">
          <xsl:call-template name="get_design_comment"/>
         </div>
         <xsl:if test="boolean(xsl:param)">
          <div class="named-template-param-list">
           <div class="named-template-param-title">Parameters</div>
           <xsl:for-each select="xsl:param">
            <div class="named-template-param-item">
             <span class="named-template-param-name">
              <xsl:value-of select="@name"/>
             </span>
             <span class="named-template-param-description">
              <xsl:call-template name="get_first_line_in_design_comment"/>
             </span>
            </div>
           </xsl:for-each>
          </div>
         </xsl:if>
        </div>
       </xsl:otherwise>
      </xsl:choose>
     </xsl:for-each>
    </div>
   </section>
  </xsl:if>
 </xsl:template>

</xsl:stylesheet>
